% In this function, all BDS channels working on B1I, B2, B3 ... will be
% initialized as code start.
function channel = GpsCH_HotInitialize(channel, Syst, CH_Status, prn, configPage, GSAR_CONSTANTS, predictInfo, device)

% First, empty multipath structs
channel.PLL(2:end)      = [];
channel.DLL(2:end)      = [];
channel.ALL(2:end)      = [];
channel.CH_B1I(2:end)   = [];
channel.CH_L1CA(2:end)  = [];
channel.KalPreFilt(2:end)  = [];

channel.STATUS = CH_Status;
channel.IQForm = GSAR_CONSTANTS.STR_RECV.IQForm; % Complex/Real Input data format
% Initialize PLL
channel.PLL.Bn  = configPage.trackConfig.pll.Bn;
channel.PLL.Ord = configPage.trackConfig.pll.Ord;
channel.PLL.Fn  = configPage.trackConfig.pll.Fn;
channel.PLL.REG = zeros(4,1);   % Filter registers
channel.PLL.IQ_d= zeros(2,1);
channel.PLL.LoopType = configPage.trackConfig.pll.LoopType;

% Initialize DLL
channel.DLL.Dn  = configPage.trackConfig.dll.Dn;
channel.DLL.Ord = configPage.trackConfig.dll.Ord;
channel.DLL.SPACING    = configPage.trackConfig.dll.SPACING;
channel.DLL.SPACING_MP = configPage.trackConfig.dll.SPACING_MP;
channel.DLL.REG = zeros(4,1); % Filter registers

% Initialize KalmanFilter
channel.KalPreFilt.loopErrState = [0, 0, 0, 0]';
channel.KalPreFilt.P0           = channel.KalPreFilt.P0;    % 热启动中保持卡尔曼参数保持不变
channel.KalPreFilt.P            = channel.KalPreFilt.P;
channel.KalPreFilt.Q            = channel.KalPreFilt.Q;
channel.KalPreFilt.R            = channel.KalPreFilt.R;
channel.KalPreFilt.firstFiltering = int32(1);% flag indicating first loop filtering

% Initialize ALL
channel.ALL.An     = configPage.trackConfig.all.An;
channel.ALL.AFn    = configPage.trackConfig.all.AFn;
channel.ALL.ai_v   = zeros(4,1);
channel.ALL.ai_reg = zeros(4,1);
channel.ALL.ai_freg= zeros(4,1);
channel.ALL.aq_v      = zeros(4,1);
channel.ALL.aq_reg    = zeros(4,1);
channel.ALL.aq_freg   = zeros(4,1);
channel.ALL.lambda    = 1;
channel.ALL.NormSampN = 0;
channel.ALL.TslotNormSampN = 0;
channel.ALL.a_avg     = zeros(4,1);
channel.ALL.a_std     = zeros(3,1);
channel.ALL.acnt      = 0;
channel.ALL.SNR       = 0;
channel.ALL.ai_kalfilt_state = [0, 0]';
channel.ALL.ai_kalfilt_P     = zeros(2,2);
channel.ALL.aq_kalfilt_state = [0, 0]';
channel.ALL.aq_kalfilt_P     = zeros(2,2);
channel.ALL.a_kalfilt_P0     = configPage.trackConfig.all.a_kalfilt_P0;
channel.ALL.a_kalfilt_Q      = configPage.trackConfig.all.a_kalfilt_Q;
channel.ALL.a_kalfilt_R      = configPage.trackConfig.all.a_kalfilt_R;

% Initialize GPS Channel
switch Syst
    case {'GPS_L1CA','B1I_L1CA'}
        channel.CH_L1CA.CH_STATUS = CH_Status;
        channel.CH_L1CA.PRNID     = prn;
        channel.CH_L1CA.codeTable = [];
        channel.CH_L1CA.LO2_CarPhs= predictInfo.carriPhase;
        channel.CH_L1CA.LO2_IF0   = GSAR_CONSTANTS.STR_RECV.IF_L1CA;
        channel.CH_L1CA.LO2_fd    = predictInfo.carriDopp;
        channel.CH_L1CA.fdPre    = predictInfo.carriDopp;
        channel.CH_L1CA.fdIndex    = 0;
        channel.CH_L1CA.LO2_framp = 0;
        channel.CH_L1CA.codePhaseErr = 0;
        channel.CH_L1CA.LO_CodPhs = predictInfo.codePhase;
        channel.CH_L1CA.LO_Fcode0 = GSAR_CONSTANTS.STR_L1CA.Fcode0;
        channel.CH_L1CA.LO_Fcode_fd= predictInfo.codeDopp;
        channel.CH_L1CA.Fcode_fdPre = predictInfo.codeDopp;
        channel.CH_L1CA.Tcohn_cnt = 0;
        channel.CH_L1CA.preUnitNum = 0;
        %Initialize information frame format
        channel.CH_L1CA.WN        = predictInfo.WN;
        channel.CH_L1CA.TOW_6SEC  = predictInfo.SOW;
        channel.CH_L1CA.SubFrame_N= predictInfo.SubFrame_N;
        channel.CH_L1CA.Word_N    = predictInfo.Word_N;
        channel.CH_L1CA.Bit_N     = predictInfo.Bit_N;
        channel.CH_L1CA.T1ms_N    = predictInfo.T1ms_N;
        %Initialize the track parameters and registers
        channel.CH_L1CA.Trk_Count = 0;
        channel.CH_L1CA.Tcohn_N   = 10;
        channel.CH_L1CA.Tslot_I     = zeros(3,1);
        channel.CH_L1CA.Tslot_Q     = zeros(3,1);
        channel.CH_L1CA.T_I         = zeros(3,1);
        channel.CH_L1CA.T_Q         = zeros(3,1);
        channel.CH_L1CA.T_pll_I     = zeros(3,1);
        channel.CH_L1CA.T_pll_Q     = zeros(3,1);
        channel.CH_L1CA.PromptIQ_D  = zeros(2,1);
        channel.CH_L1CA.Loop_I  = zeros(3,15);
        channel.CH_L1CA.Loop_Q  = zeros(3,15);
        channel.CH_L1CA.Loop_N  = 0;
        % sis pointer Samp_Posi will be initialized at other places
        channel.CH_L1CA.Samp_Posi   = 0;
        % 错误校验
        channel.CH_L1CA.SOW_check      = -1;
        channel.CH_L1CA.SubFrame_check = -1;
        channel.CH_L1CA.invalidNum     = -1;% 电文各项参数有效性，-1：未知  0：有效   1、2、3...:连续错误的次数
        % Initialize the CNR-computing parameters
        channel.CH_L1CA.CN0_Estimator.CN0EstActive = 0;
        channel.CH_L1CA.CN0_Estimator.muavg_T      = 1;
        channel.CH_L1CA.CN0_Estimator.mupool_NMax  = round(channel.CH_L1CA.CN0_Estimator.muavg_T*1e3);
        channel.CH_L1CA.CN0_Estimator.muk_cnt      = 0;
        channel.CH_L1CA.CN0_Estimator.mu_avg       = 0;
        channel.CH_L1CA.CN0_Estimator.CN0          = 0;
        channel.CH_L1CA.CN0_Estimator.WideB_Pw_IQ  = zeros(2,1);
        channel.CH_L1CA.CN0_Estimator.NarrowB_Pw_IQ= zeros(2,1);
        %Define PLL disc sigma estimor
        channel.CH_L1CA.lockDect.snr         = 0;
        channel.CH_L1CA.lockDect.snrThre     = configPage.trackConfig.lockDect.snrThrelol;
        channel.CH_L1CA.lockDect.sigma       = 0;%channel pll discriminator output's variance estimates
        channel.CH_L1CA.lockDect.sigma_lock  = 0;
        channel.CH_L1CA.lockDect.sigma_lock_checkT  = 0;
        channel.CH_L1CA.lockDect.sigma_checkT= 1;      
        channel.CH_L1CA.lockDect.sigma_checkNMax = round(channel.CH_L1CA.lockDect.sigma_checkT*1e3 / channel.CH_L1CA.Tcohn_N);
        channel.CH_L1CA.lockDect.sigma_checkTimer= 0;
        channel.CH_L1CA.lockDect.sigma_warningCnt= 0;
        channel.CH_L1CA.lockDect.sigmaThrelol    = configPage.trackConfig.lockDect.sigmaThrelol;
        channel.CH_L1CA.lockDect.WN = predictInfo.WN;
        channel.CH_L1CA.lockDect.SOW = predictInfo.SOW;
        channel.CH_L1CA.lockDect.Frame_N = predictInfo.Frame_N;
        channel.CH_L1CA.lockDect.SubFrame_N = predictInfo.SubFrame_N;
        channel.CH_L1CA.lockDect.Word_N = predictInfo.Word_N;
        channel.CH_L1CA.lockDect.Bit_N = predictInfo.Bit_N;
        channel.CH_L1CA.lockDect.T1ms_N = predictInfo.T1ms_N;
        channel.CH_L1CA.lockDect.codePhase = predictInfo.codePhase;
        channel.CH_L1CA.lockDect.carriPhase = predictInfo.carriPhase;
        channel.CH_L1CA.lockDect.carriDopp = predictInfo.carriDopp;
        channel.CH_L1CA.lockDect.codeDopp = predictInfo.codeDopp;
        channel.CH_L1CA.lockDect.cos2phi = 0;
        channel.CH_L1CA.lockDect.CN0Thres = 0;
        channel.CH_L1CA.lockDect.cos2phiThres = 0;
        channel.CH_L1CA.lockDect.lockTime = 0;
        
        % Initialize Mems for recording the correlation shape of current Unit
        channel.CH_L1CA.CorrM_Bank = corrMBank_initialize('GPS_L1CA', channel.CH_L1CA.CorrM_Bank, GSAR_CONSTANTS);
%         channel.CH_L1CA.CorrM_Bank.corrM_Spacing  = 2;
%         channel.CH_L1CA.CorrM_Bank.corrM_Num      = 5 + 2 * round(2 * GSAR_CONSTANTS.STR_RECV.fs / GSAR_CONSTANTS.STR_L1CA.Fcode0 / channel.CH_L1CA.CorrM_Bank.corrM_Spacing);
%         channel.CH_L1CA.CorrM_Bank.corrM_I_vt     = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.corrM_Q_vt     = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.corrM_Loop_I_vt     = zeros(210, 15); %与Loop_I列数一致
%         channel.CH_L1CA.CorrM_Bank.corrM_Loop_Q_vt     = zeros(210, 15);
%         channel.CH_L1CA.CorrM_Bank.uncancelled_corrM_I_vt = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.uncancelled_corrM_Q_vt = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.normRx_I_vt    = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.normRx_Q_vt    = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.normRx_vt      = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.corrM_I_vt_Save= zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.corrM_Q_vt_Save= zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.uncancelled_corrM_I_vt_Save = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
%         channel.CH_L1CA.CorrM_Bank.uncancelled_corrM_Q_vt_Save = zeros(channel.CH_L1CA.CorrM_Bank.corrM_Num, 1);
        % Initialize navigation data frame parameters
        channel.CH_L1CA.SFNav     = zeros(10,1);
        channel.CH_L1CA.SFNav_prev= zeros(10,1);
        channel.CH_L1CA.Bit_Inv   = 0; % 1 means the nav bit should be inverted
        channel.CH_L1CA.SF_Complete=0; % Flag whether a subframe is complete
        channel.CH_L1CA.Frame_Sync= 'NOT_FOUND';
        channel.CH_L1CA.state1    = 0;
        channel.CH_L1CA.state2    = 0;
        channel.CH_L1CA.carrPhaseAccum = 0; % Accumulation of carrier phase variation due to doppler frequency
        channel.CH_L1CA.ephReady  = 0; % Flag whether ephemeris is demodulated completely, 1 for yes, 0 for not yet (just in MATLAB)
        channel.CH_L1CA.last_twobits   = 0; % the last two bits of previous code
%         channel.CH_L1CA.bitDetect = zeros(3,1); % detect whether nav bit is correct
        % Initialize acq structure
        channel.CH_L1CA.acq.STATUS     = 'strong'; %strong/weak
        channel.CH_L1CA.acq.ACQ_STATUS = 0;
        channel.CH_L1CA.acq.processing = -1;% -1：初始化，0：经过推算后，1：经过捕获初始化后
        channel.CH_L1CA.acq.TimeLen    = 0;
        channel.CH_L1CA.acq.hotWaitTime = -9999;
        channel.CH_L1CA.acq.hotAcqTime = 0;
        channel.CH_L1CA.acq.acq_parameters = CH_Hot_AcqParameters_Init(channel.SYST, ...
                                                                       [], ...
                                                                       GSAR_CONSTANTS.STR_RECV.IF_L1CA + channel.CH_L1CA.LO2_fd, ...
                                                                       configPage);
        % TC: number of code period for conherent integration, TC = 1, 1 period
        channel.CH_L1CA.acq.TC         = round(channel.CH_L1CA.acq.acq_parameters.tcoh * 1e3);
        channel.CH_L1CA.acq.L0Fc0_R    = GSAR_CONSTANTS.STR_L1CA.L0Fc0_R;
        channel.CH_L1CA.acq.IF0        = channel.CH_L1CA.acq.acq_parameters.freqCenter;
        channel.CH_L1CA.acq.freqSearch = channel.CH_L1CA.acq.acq_parameters.freqRange / channel.CH_L1CA.acq.acq_parameters.freqBin + 1;
        channel.CH_L1CA.acq.freqBin    = channel.CH_L1CA.acq.acq_parameters.freqBin;
        channel.CH_L1CA.acq.freqOrder  = [];
        
        channel.CH_L1CA.acq.CM_corrtmp  = [];
        channel.CH_L1CA.acq.CM_corr     = [];
        channel.CH_L1CA.acq.CM_peak     = 0;
        channel.CH_L1CA.acq.CL_corrtmp  = [];
        channel.CH_L1CA.acq.CL_corr     = [];
        channel.CH_L1CA.acq.CL_search   = [];
        
        codePeriod_L1CA =GSAR_CONSTANTS.STR_L1CA.ChipNum / (GSAR_CONSTANTS.STR_L1CA.Fcode0+channel.CH_L1CA.LO_Fcode_fd);
        %integer samples per TC (s32 type)
        channel.CH_L1CA.acq.sampPerTC_s= round(GSAR_CONSTANTS.STR_RECV.fs * codePeriod_L1CA);
        channel.CH_L1CA.acq.sampPer2TC_s=2*channel.CH_L1CA.acq.sampPerTC_s;
        channel.CH_L1CA.acq.skipNumberOfCodes=[];
        channel.CH_L1CA.acq.accum      = 0;
        channel.CH_L1CA.acq.corr       = [];
        channel.CH_L1CA.acq.corrtmp    = [];
        channel.CH_L1CA.acq.acqID      = 0;
        channel.CH_L1CA.acq.resiData   = [];
        channel.CH_L1CA.acq.acqResults = [];
        channel.CH_L1CA.acq.resiN      = 0;
        channel.CH_L1CA.acq.skipNumberOfSamples      = 0;
        channel.CH_L1CA.acq.skipNperCode      =  channel.CH_L1CA.acq.sampPerTC_s * ...
            (1 - GSAR_CONSTANTS.STR_L1CA.Fcode0/(GSAR_CONSTANTS.STR_L1CA.Fcode0+channel.CH_L1CA.LO_Fcode_fd));
        channel.CH_L1CA.acq.carriPhase      = 0;
        channel.CH_L1CA.acq.Samp_Posi_dot = 0;
        
        channel.CH_L1CA_L2C.acq.CM_corrtmp  = [];
        channel.CH_L1CA_L2C.acq.CM_corr     = [];
        channel.CH_L1CA_L2C.acq.CM_peak     = 0;
        channel.CH_L1CA_L2C.acq.CL_corrtmp  = [];
        channel.CH_L1CA_L2C.acq.CL_corr     = [];
        channel.CH_L1CA_L2C.acq.CL_search   = [];
        
        channel.CH_L1CA.acq.acqResults.sv           = 0;
        channel.CH_L1CA.acq.acqResults.acqed        = 0;
        channel.CH_L1CA.acq.acqResults.corr         = 0;
        channel.CH_L1CA.acq.acqResults.corrpeak     = 0;
        channel.CH_L1CA.acq.acqResults.freqOrder    = 0;
        channel.CH_L1CA.acq.acqResults.samps        = 0;
        channel.CH_L1CA.acq.acqResults.freqIdx      = 0;
        channel.CH_L1CA.acq.acqResults.codeIdx      = 0;
        channel.CH_L1CA.acq.acqResults.nc           = 0;
        channel.CH_L1CA.acq.acqResults.snr          = 0;
        channel.CH_L1CA.acq.acqResults.doppler      = 0;
        channel.CH_L1CA.acq.acqResults.RcFsratio    = 0;
        % Initialize bitsync structure
        channel.CH_L1CA.bitSync.STATUS = 'strong'; %strong/weak
        channel.CH_L1CA.bitSync.processing = 0;
        channel.CH_L1CA.bitSync.TimeLen    = 0;
        channel.CH_L1CA.bitSync.waitNum= 0;
        channel.CH_L1CA.bitSync.waitSec= 0;
        channel.CH_L1CA.bitSync.waitTimes = 0;
        channel.CH_L1CA.bitSync.TC     = 0;
        channel.CH_L1CA.bitSync.noncoh = [];
        channel.CH_L1CA.bitSync.nhCode = [];
        channel.CH_L1CA.bitSync.nhLength=0;
        channel.CH_L1CA.bitSync.frange = 0;
        channel.CH_L1CA.bitSync.fbin   = 0;
        channel.CH_L1CA.bitSync.fnum   = 0;
        channel.CH_L1CA.bitSync.Fcodesearch = 0;
        channel.CH_L1CA.bitSync.sampPerCode = 0;
        channel.CH_L1CA.bitSync.skipNumberOfSamples = 0;
        channel.CH_L1CA.bitSync.skipNperCode = 0;
        channel.CH_L1CA.bitSync.accum  = 0;
        channel.CH_L1CA.bitSync.resiData=[];
        channel.CH_L1CA.bitSync.resiN = 0;
        channel.CH_L1CA.bitSync.carriPhase  = 0;
        channel.CH_L1CA.bitSync.Samp_Posi_dot=0;
        channel.CH_L1CA.bitSync.offCarri=[];
        channel.CH_L1CA.bitSync.bitSyncResults = [];
        channel.CH_L1CA.bitSync.bitSyncID=0;
        channel.CH_L1CA.bitSync.corr   = [];
        channel.CH_L1CA.bitSync.corrtmp= [];
        
        channel.CH_L1CA.bitSync.bitSyncResults.sv     = 0;
        channel.CH_L1CA.bitSync.bitSyncResults.synced = 0;
        channel.CH_L1CA.bitSync.bitSyncResults.nc_corr= 0;
        channel.CH_L1CA.bitSync.bitSyncResults.freqIdx= 0;
        channel.CH_L1CA.bitSync.bitSyncResults.bitIdx = 0;
        channel.CH_L1CA.bitSync.bitSyncResults.doppler= 0;
    otherwise
        error('System type of GPS has not been defined yet!');
end

% Initialize CADLL
channel.STR_CAD.CADLL_MODE = 'CADLL';       % CADLL/CONVENTION
channel.STR_CAD.CAD_STATUS = 'CAD_TRACK';   % CAD_TRACK/NEWMP_LOOKFOR/TRANSIENT
channel.STR_CAD.CadCnt        = 0;
channel.STR_CAD.MONI_TYPE     = 'MONI_ALLON';  % MONI_CODPHS_DIFF/MONI_A_STD/MONI_CN0/MONI_SNR/MONI_A_AVG/MONI_ALLON
channel.STR_CAD.MONI_TYPE_TR  = 'MONI_ALLON';  % MONI_CODPHS_DIFF/MONI_A_STD/MONI_CN0/MONI_SNR/MONI_A_AVG/MONI_ALLON
% Define the supported maximum number of units in cadll algorithm, CadUnitMax<=10;
channel.STR_CAD.CadUnitMax     = configPage.cadConfig.CadUnitMax;
channel.STR_CAD.CadUnit_N      = 1;             % define current number of units;
channel.STR_CAD.MonitoringTime = configPage.cadConfig.MonitoringTime; % monitoring time before making a decision;
channel.STR_CAD.MoniNMax       = round(channel.STR_CAD.MonitoringTime/1e-3); % Equivalent maximum number that Monitor counter counts to, the counter counts at a rate of 1kHz
channel.STR_CAD.Moni_N         = 0;    % Monitor counter, counting from 0~MoniNMax-1, counting at a rate of 1kHz

switch Syst
    case {'GPS_L1CA','B1I_L1CA'}
        channel.STR_CAD.CadU2_CodeIni = configPage.cadConfig.GPS_L1CA.CadU2_CodeIni; % Initial code phase delay in chips with respect to the first unit when inserting the second unit;
        channel.STR_CAD.CadUin_CodeIni= configPage.cadConfig.GPS_L1CA.CadUin_CodeIni;% The initial code phase delay in chips with respect the unit before when inserting the third and more unit;
        channel.STR_CAD.CadUin_AIni   = configPage.cadConfig.GPS_L1CA.CadUin_AIni;   % The initial amplitude of the inserted unit with repsect to the unit before;
        channel.STR_CAD.CadUin_ThetaIni=configPage.cadConfig.GPS_L1CA.CadUin_ThetaIni; % The initial carrier phase of the inserted unit with repsect to the unit before, [cycles];
        
        channel.STR_CAD.CodPhsLagThre1 = configPage.cadConfig.GPS_L1CA.CodPhsLagThre1; % The mandatory code phase lag by force between two adjacent units,[chips]
        channel.STR_CAD.CodPhsLagThre2 = configPage.cadConfig.GPS_L1CA.CodPhsLagThre2; %The code phase lag threshold of two adjacent units; the latter unit will be shut down if its code phase delay is less than the threshold 
        channel.STR_CAD.CodPhsLag_Insrt_Thre3 = configPage.cadConfig.GPS_L1CA.CodPhsLag_Insrt_Thre3; % The least code phase lag between two adjacent units between that a trial unit can be inserted;
        
        channel.STR_CAD.AThreLow1    = configPage.cadConfig.GPS_L1CA.AThreLow1;  % the lowest amplitude1 permitted;
        channel.STR_CAD.AThreLow2    = configPage.cadConfig.GPS_L1CA.AThreLow2;  % the lowest amplitude2 permitted;
        channel.STR_CAD.AThreLow3    = configPage.cadConfig.GPS_L1CA.AThreLow3;
        channel.STR_CAD.ADevThre     = configPage.cadConfig.GPS_L1CA.ADevThre;   % permitted maximum std deviation ratio of estimated amplitude to noise's;
        
        channel.STR_CAD.SNRThre1     = configPage.cadConfig.GPS_L1CA.SNRThre1;   % permitted minimum SNR1 (estimated)
        channel.STR_CAD.SNRThre2     = configPage.cadConfig.GPS_L1CA.SNRThre2;   % permitted minimum SNR2 (estimated)
        channel.STR_CAD.SNRThre3     = configPage.cadConfig.GPS_L1CA.SNRThre3;
        channel.STR_CAD.SNRThre4     = configPage.cadConfig.GPS_L1CA.SNRThre4;

     otherwise
        error('System type of BDS has not been defined yet!');      
end
channel.STR_CAD.Unit0SNR_Det   = 0;
% channel.STR_CAD.CN0Thre      = 23;       % permitted minimum CN0 (estimated)
% channel.STR_CAD.ThetaDevThre = 15;       % permitted maximum std deviation of estimated carrier phase bias,[deg];
% % Define thresholds for loss of lock detection
% channel.STR_CAD.SNRThrelol   = 5; % [dB], TODO,unused currently
% channel.STR_CAD.sigmaThrelol = 0.015;
% channel.STR_CAD.LossThre     = 2; % Loss of lock level

channel.STR_CAD.CodPhsDiff_Avg      = zeros(channel.STR_CAD.CadUnitMax,1); % Computing the code phase lag between two adjacent units
channel.STR_CAD.CodPhsDiff_Avg_prev = zeros(channel.STR_CAD.CadUnitMax,1); %Store the previous CodPhsDiff_Avg
channel.STR_CAD.A_Avg               = zeros(channel.STR_CAD.CadUnitMax,1); % Computing the normalized average amplitude of a signal component during one monitoring time
channel.STR_CAD.A_Std               = zeros(channel.STR_CAD.CadUnitMax,1); % Compute the normalized amplitude stadard deviation of a signal component during one monitoring time.
channel.STR_CAD.UnitErrTang_N       = int32(zeros(channel.STR_CAD.CadUnitMax,1)); % Allocate the tang registers for counting the number of errors of each unit
% Initialize some parameters regarding detecting a new MP
% The checking point of a new multipath in the CADLL chain, also called the inserted point. The new 
% unit will be inserted between InsrtNo~InsrtNo+1, so InsrtNo will be 0~CadUnit_N-1.
channel.STR_CAD.InsrtNo       = 0;
channel.STR_CAD.CadCH_L1CA_Tr = channel.CH_L1CA; % Trail CH for GPS_L1CA signal in cadll detecting a new multipath
channel.STR_CAD.CadCH_L1CA_Tr.CH_STATUS = 'TRACK';
channel.STR_CAD.CadDLL_Tr     = channel.DLL;    % Trail CH's DLL structure
channel.STR_CAD.CadALL_Tr     = channel.ALL;    % Trail CH's ALL structure

channel.STR_CAD.TrConfirmT    = 1; % The time for estimating the new multipath's CNR,[s]
channel.STR_CAD.TrConfirm_NMAX = round(channel.STR_CAD.TrConfirmT/1e-3); % Equivalent number of 1ms for estimating the new multipath's CNR,[s]
% % CN0 threshold for detecting a new multipath signal, one below that is deemed as nuisances.
% channel.STR_CAD.TrCN0Thre      = 23;    %16;
% channel.STR_CAD.TrSNRThre      = -8;    %-13;
% channel.STR_CAD.TrAmpThre      = 0.08;     %0.07; % Divide amplitude of trail ch by amplitude of LOS
channel.STR_CAD.TrCodphsDiff_Avg = 0;
channel.STR_CAD.TrChkSum_Errcode = uint32(0);  % CH_Tr checksum error code
channel.STR_CAD.Codfreq_Proj_Tr_ErrTang = 0;
% Initialize the time of CAD_TRACK status and TRASIENT status 
channel.STR_CAD.CadLoopTime       = 1; % Stably tracking time between two MP detecting operations,[s]
channel.STR_CAD.CadLoop_NMAX      = round(channel.STR_CAD.CadLoopTime/1e-3); %1000
channel.STR_CAD.CadTransientTime  = 0.5; % Transient time
channel.STR_CAD.CadTransient_NMAX = round(channel.STR_CAD.CadTransientTime/1e-3); %500
% Finish the resultant initializations
switch channel.STR_CAD.CAD_STATUS
    case 'CAD_TRACK'
        channel.STR_CAD.CadCnt = channel.STR_CAD.CadLoop_NMAX;%Debugging
    case 'NEWMP_LOOKFOR'
        channel.STR_CAD.CadCnt = channel.STR_CAD.TrConfirm_NMAX;
    case 'TRANSIENT'
        channel.STR_CAD.CadCnt = channel.STR_CAD.CadTransient_NMAX;
end

% Initialize STR_CH_noise
channel.CH_ns.Codphs_ns   = 0; % noise channle's code phase
channel.CH_ns.Tslot_ns_IQ = zeros(2,1); %1ms correlations of noise channel, I,Q channels
channel.CH_ns.T_ns_IQ = zeros(4,1); %Tms correlations of noise channel, I,Q channels
channel.CH_ns.Avg_ns_IQ   = zeros(2,1); % average over 1s, I,Q channels
channel.CH_ns.Sq_ns_IQ    = zeros(2,1); % average squares over 1s, I,Q channels
channel.CH_ns.ns_Std      = 0; % noise channel's std
channel.CH_ns.NsCnt       = 0; % noise channle counter
channel.CH_ns.NormFactor  = 0; % normalizing factor

end

