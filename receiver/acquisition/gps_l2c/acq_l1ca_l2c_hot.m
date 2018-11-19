function channel = acq_l1ca_l2c_hot(config, channel, sis, N)% 对CA进行热捕获。 若要提升灵敏度，此处可进行3码联合热捕获，待实现% 利用相关进行部分码相位搜索，码相位搜索步长小于半码片, 默认码片搜索范围正负4channel.CH_L1CA_L2C.acq.TimeLen = N; %进入热捕获后推算时长计为N，如果成功，这个值不会起作用，如果失败，则在通道调度模块中推算时间global GSAR_CONSTANTS;channel_spc = channel.CH_L1CA_L2C;acq_config = config.recvConfig.configPage.acqConfig.GPS_L1CA;fd0 = channel_spc.LO2_fd;  %热捕获频率搜索中心freqN = round( acq_config.hotFreqRange / acq_config.hotFreqBin )+1; %频率搜索数codeN = 9; %默认奇数fd_search = fd0 + ( -acq_config.hotFreqRange/2 : acq_config.hotFreqBin : acq_config.hotFreqRange/2 ); %多普勒搜索位置IF_search = GSAR_CONSTANTS.STR_RECV.IF_L1CA + fd_search; %实际搜索频率位置Tc = round(acq_config.tcoh_hot*1000); %相干积分毫秒数 5Nc = acq_config.nnchList(1)/Tc; %累加次数 20/5=4N_1ms = GSAR_CONSTANTS.STR_RECV.fs * 0.001;  %1ms数据对应的采样点数if (channel_spc.acq.processing ~= 1) %第一次进来要初始化    CA_code = GSAR_CONSTANTS.PRN_CODE.CA_code(channel_spc.PRNID,:);    channel_spc.acq.accum = 0; %非相干累加次数    channel_spc.acq.corr = zeros(freqN,codeN); %总积分结果    channel_spc.acq.corrtmp = zeros(freqN,codeN); %相干积分结果    channel_spc.acq.carriPhase_vt = zeros(1, freqN); %保存每个频率搜索位置的载波相位    channel_spc.acq.Samp_Posi_dot = 0; %采样点位置的小数部分    %skipNperCode：每1ms的跳采样点数。如值为1，则表示每次1ms积分后要将Samp_Posi减1。    channel_spc.acq.skipNperCode = N_1ms * channel_spc.LO_Fcode_fd / GSAR_CONSTANTS.STR_L1CA.Fcode0;        channel_spc.acq.processing = 1;endfprintf('\t\tHot acq GPS L1CA PRN%2.2d:  Coherent time: %d*%.3fs ; FreqBin: %.0fHz ; FreqRange: %.0f~%.0fHz\n', ...    channel_spc.PRNID, Nc, acq_config.tcoh_hot, acq_config.hotFreqBin, fd_search(1), fd_search(freqN));%热捕获算法与精捕获比较类似，对于本地采样码，统一采用中心频率生成1ms的长度，给不同的频率用。而跳采样仅在一次相干积分结束后进行。codeTable = zeros(codeN, N_1ms);sampStep = floor(0.5*GSAR_CONSTANTS.STR_RECV.fs/1.023e6); %半码片搜索精度对应的采样点步长%生成起始位置依次相差sampStep个采样点的本地码for i = 1:codeN    sampDiff = sampStep * (i-(codeN+1)/2);    t = ( (0:N_1ms-1)+sampDiff ) / GSAR_CONSTANTS.STR_RECV.fs;  %毫秒时间戳    codePhase = mod( floor((GSAR_CONSTANTS.STR_L1CA.Fcode0 + channel_spc.LO_Fcode_fd)*t), 1023 ) + 1;    codeTable(i,:) = CA_code(codePhase);endt_1ms = (0:N_1ms-1)/GSAR_CONSTANTS.STR_RECV.fs; % 1ms主循环while(1)    sis_seg = sis( channel_spc.Samp_Posi + (1:N_1ms) );        %二维搜索    for i=1:freqN                carrier = exp( -1i*( 2*pi*IF_search(i)*t_1ms + channel_spc.acq.carriPhase_vt(i) ) );  %本地载波信号        channel_spc.acq.carriPhase_vt(i) = mod( channel_spc.acq.carriPhase_vt(i) + 2*pi*IF_search(i)*0.001, 2*pi);        sis_swpt = sis_seg.*carrier; %载波剥离        for j = 1:codeN  %码剥离            channel_spc.acq.corrtmp(i,j) = channel_spc.acq.corrtmp(i,j) + sum(sis_swpt.*codeTable(j,:));        end            end        channel_spc.acq.accum = channel_spc.acq.accum + 1;    channel_spc.Samp_Posi = channel_spc.Samp_Posi + N_1ms;        if ( mod(channel_spc.acq.accum,Tc)==0 ) %达到相干积分时间        channel_spc.acq.corr = channel_spc.acq.corr + abs(channel_spc.acq.corrtmp);        channel_spc.acq.corrtmp = zeros(freqN,codeN);        %处理跳采样        channel_spc.acq.Samp_Posi_dot = channel_spc.acq.Samp_Posi_dot - Tc*channel_spc.acq.skipNperCode;        channel_spc.Samp_Posi = channel_spc.Samp_Posi + round(channel_spc.acq.Samp_Posi_dot);        channel_spc.acq.carriPhase_vt = channel_spc.acq.carriPhase_vt + ...            round(channel_spc.acq.Samp_Posi_dot)*2*pi*IF_search/GSAR_CONSTANTS.STR_RECV.fs;         channel_spc.acq.Samp_Posi_dot = channel_spc.acq.Samp_Posi_dot - round(channel_spc.acq.Samp_Posi_dot);    end        if ( channel_spc.acq.accum == Tc*Nc ) %达到累加次数        channel_spc.acq.processing = -1;        [~, peak_freq_idx, peak_code_idx, th] = find2DPeakWithThre(channel_spc.acq.corr, 'hotAcq');        if (th>3)  %门限待定，临时            if config.logConfig.isAcqPlotMesh                Title = ['Hot acq GPS_L1CA PRN=',num2str(channel_spc.PRNID)];                figure('Name',Title,'NumberTitle','off');                mesh(1:codeN, fd_search, channel_spc.acq.corr);                xlabel('Code position');                ylabel('Freq doppler / Hz');                zlabel('Corr');            end            %更新多普勒            channel_spc.LO2_fd = fd_search(peak_freq_idx);            channel_spc.LO2_fd_L2 = channel_spc.LO2_fd * GSAR_CONSTANTS.STR_L2C.L2L1_FreqRatio;            channel_spc.LO_Fcode_fd = channel_spc.LO2_fd / GSAR_CONSTANTS.STR_L1CA.L0Fc0_R;            %更新码相位推算值。由于热捕获成功后会进入热牵入状态，此时只需用捕获结果对通道时间信息进行校准,时间推到0位置            sampDiff = sampStep * (peak_code_idx-(codeN+1)/2);            channel_spc.Samp_Posi = 0;            channel_spc = hotTimeInc_L1L2(channel_spc, sampDiff); %时间校准            channel_spc.CH_STATUS = 'HOT_PULLIN';            channel.STATUS = 'HOT_PULLIN';            channel.CH_L1CA_L2C = channel_spc;            channel = track_phase_ini(channel);  %热牵入初始化                        fprintf('\t\t\tSucceed!SampBias: %d ; Doppler: %.2fHz Strength: %.4f \n', ...                sampDiff, channel_spc.LO2_fd, th);                else            if (channel_spc.acq.hotWaitTime == -9999)                channel_spc.acq.hotWaitTime = config.recvConfig.hotTime;  %冷启动的时间                            end            channel_spc.acq.hotAcqTime = config.recvConfig.hotAcqPeriod; %再次热捕获的时间            channel_spc.CH_STATUS = 'HOT_ACQ_WAIT';            channel.STATUS = 'HOT_ACQ_WAIT';            channel.CH_L1CA_L2C = channel_spc;                        fprintf('\t\t\tFailed!Strength: %.4f Cold start after %.4f second! \n', th, channel_spc.acq.hotWaitTime);                     end                return;            end            end    