%% Initialization for GSARx receiver structure
function receiver = ReceiverConstruct()

sysNum = 2;     % 系统的总数量

receiver = struct( ...
    'syst',            [], ...
    'config',          [], ...
    'channels',        [], ...
    'satelliteTable',  [], ...
    'acqCHTable',      [], ...%捕获通道维护表
    'actvPvtChannels', [], ...%The channels are subframe_synced and epheris is ready, so can ben used in PVT.
    'naviMsg',         [], ...
    'timer',           [], ...
    'preFilt',         [], ...
    'pvtCalculator',   [], ...
    'recvRecor',       [], ...% Keep the information related to receiver's running status 
    'recorder',        [], ...% Keep the information related to receiver's channels running status
    'elapseTime',      [], ...
    'Loop',            [], ...%receiver running loops
    'Trun',            [], ...%receiver running time
    'environment',     [], ...
    'UI',              [], ...
    'device',          [] ...
);

% % Config the pre-filtering module
% receiver.preFilt = ConfigurePreFilter();

%% Config UI parameters
receiver.UI = struct( ...
    'statusTable',          [], ...
    'position',             []  ...
    );

%% channels
receiver.channels = struct(...
    'SYST',                  '', ...
    'STATUS',                '', ...
    'IQForm',                [], ...% Complex/Real Input data format
    'CH_L1CA',               [], ...%
    'CH_L1CA_L2C',           [], ...%
    'CH_B1I',                [], ...%
    'CH_B1I_B2I',            [], ...
    'PLL',                   [], ...%
    'DLL',                   [], ...%
    'ALL',                   [], ...% 
    'STR_CAD',               [], ...
    'KalPreFilt',            [], ...
    'CH_ns',                 [], ...% Definition of noise channel
    'bpSampling_OddFold',    [] ...
);

receiver.acqCHTable = struct(...
    'coldAcqCHWaitList',         [], ...
    'coldAcqCHWaitNum',          0 , ...
    'hotAcqCHWaitList',          [],  ...
    'hotAcqCHWaitNum',           0  ...
);
receiver.acqCHTable(1:sysNum) = receiver.acqCHTable;

receiver.actvPvtChannels = struct(...
    'actChnsNum_BDS',        0, ...
    'BDS',                   [], ...
    'actChnsNum_GPS',        0, ...
    'GPS',                   [] ...
);

receiver.config = struct( ...
    'recvConfig',           [],     ...%Configurations about receiver
    'sisConfig',            [],     ...%Configurations about signal data stream
    'logConfig',            []      ...%Configurations about log files
);

%% recvConfig
recvConfig = struct(...
    'startMode',            '',     ...
    'timeType',             'Null',     ...
    'reacquireMode',        '',     ...
    'configPage',           '',     ...
    ...Define Positioning Mode: 00 signle-point least-square; 01 signle-point Kalman filter;
    ...                         10 RTD least-square;
    'positionType',         00,      ...
    'truePosition',         [],     ...
    'trueTime',             -1,     ...
    'targetSatellites',     [],     ...
    'numberOfChannels',     [],     ...
    'elevationMask',        0,      ...
    'reAcqPeriod',          5,      ...
    'satTableUpdatPeriod',  5,      ...
    'acqEngineParallelNum', 2,      ...%同时启动捕获或Bitsync的通道数目
    'raimFailure',          12      ...
);
receiver.config.recvConfig = recvConfig;

% 目前共有两个系统
receiver.config.recvConfig.targetSatellites = struct( ...
    'syst',                 '',     ...
    'prnNum',               []      ...
);
receiver.config.recvConfig.targetSatellites(1:sysNum) = receiver.config.recvConfig.targetSatellites;

receiver.config.recvConfig.numberOfChannels = struct( ...
    'syst',                 '',     ...     % 系统
    'channelNum',           0,      ...     % 每个系统的通道数目
    'channelNumAll',        0       ...     % 总通道数目
);
receiver.config.recvConfig.numberOfChannels(1:sysNum) = receiver.config.recvConfig.numberOfChannels;

%% sisConfig
sisConfig = struct(...
    'skipTime',             0,    ...
    'runTime',              0,    ...
    'skipNumberOfBytes',    0,      ...
    'skipNumberOfSamples',  0,      ...
    'codePeriod',           [],      ...
    'samplesPerCode',       []   ...
    );
receiver.config.sisConfig = sisConfig;

%% logConfig
logConfig = struct(...
    'debugLevel',           0,      ...
    'debugFilePath',        '',     ...
    'logFilePath',          '',     ...
    'isStoreResult',        0,      ...
    'isAcqPlotMesh',        0,      ...
    'isSyncPlotMesh',       0,      ...
    'isTrackPlot',          0,      ...
    'isCorrShapeStore',     0,      ...
    'isStoreCorrMovie',     0      ...
    );
receiver.config.logConfig = logConfig;

%% satelliteTable
ST_updateTime = struct(...
    'recvSOW',                -1,...
    'weeknum',                -1,...
    'timeInterval',           0 ...     % 距离上一次更新的时间间隔
    );
receiver.satelliteTable = struct(...   
    'syst',                   '',   ...System Tag: BDS_B1I/GPS_L1CA
    'updateTime',             ST_updateTime,   ...update receiver time
    'PRN',                    [],   ...
    'satInOperation',         [],   ...% 0: sat not in operation
                                    ...% 1: sats in operation
                                    ...% 2: sats in-operation & target 
    'satVisible',             [],   ...% -1:   cold start, no eph or ala info, don't know if the target satellites are visible (default)
                                    ...% 0:    sat invisible
                                    ...% 1:    sat visible
    'satHealth',              [],   ...% 1: sat healthy (default)
                                    ...% 0: sat unhealthy
    ...satBlock flag is active when satVisible=1 (which means the sat's eph is already avaible or it has been acquired)
    ...if satVisible=-1/0, this flag is unactive.
    'satBlock',               [],   ...% -1: sat not yet processed (default)
                                    ...% 0: unblocked 
                                    ...% 1: blocked
    'satBlockAge',            0,    ...% age of this sat's blocking, only active when satBlock=1. Should be updating every second
    'ephemerisReady',         [],   ...% 0: no complete ephemeris available for this sat
                                    ...% 1: sat's ephemeris available
    'ephemerisAge',           0,    ...% age of the available eph, updating every second or when the new checked eph is updated to receiver.ephemeris
    'almanacReady',           [],   ...% 0: no complete almanac available for this sat
                                    ...% 1: sat's almanac is available
    'almanacAge',             0,    ...% age of the available alm, updating every second or when the new checked eph is updated to receiver.almanac
    'satPosxyz',              [],   ...% sat position in space
    'satElevation',           [],   ...% sat elevation
    'satAzimuth',             [],   ...% sat azimuth
    'SCNR',                   -100*ones(2,1), ...% The estimated SNR and CNR for this sat.Only the sat that is tracked by a channel has this value. Initial -100 (default)
    'MPStatus',               0,    ...% Indicating if this sat has multipath
                                    ...% 0: no mp / 1: one mp / 2: more than one mp
    ...processState: indicating what stauts this sat is being processed by a channel: acq/pullin\track\Synced\PVT\re-acq\IDLE ...
    ...It actives only when this sat is being processed by a Channel.
    'processState',          '',   ...
    'satCandiPrio',           [],   ...% The priori sats PRN list for waiting for process
    'nCandiPrio',             0,    ...% number of satCandidates
    'satCandi',              [],   ...% The sats PRN list for waiting for process
    'nCandi',                0     ...% number of satCandidates
    );
receiver.satelliteTable(1:sysNum) = receiver.satelliteTable;


%% 导航电文
% almanac of L1CA or B1I
str_almanac = struct( ...
    'syst',                 '',     ...
    'almAllReady',          0,      ...
    'dect',                 [],     ...
    'hea',                  [],     ...
    'WNa',                  0,      ...
    'alm',                  []      ...
);
% ephemeris of L1CA or B1I
str_ephemeris = struct( ...
    'syst',                 '',     ...
    'para',                 []      ...
);

str_B1I_L1CA = struct(...
    'ephemeris',      str_ephemeris, ...
    'almanac',        str_almanac ...
);

% struct for GPS CNAV
str_GPS_L2C = struct();

% 导航电文顶层结构
receiver.naviMsg = struct(...
    'BDS_B1I',        str_B1I_L1CA, ...
    'GPS_L1CA',       str_B1I_L1CA, ...
    'GPS_L2C',        str_GPS_L2C ...
);

%% Timer
receiver.timer = struct(...
    'recvSOW',              [], ...% 接收机本地时间
    'recvSOW_BDS',          [], ...%（北斗系统时间）
    'recvSOW_GPS',          [], ...%（GPS系统时间）
    'weeknum',              [], ...% 周数
    'weeknum_BDS',          [], ... % 北斗周
    'weeknum_GPS',          [], ...% GPS周
    'year',                 [], ...
    'month',                [], ...
    'day',                  [], ...
    'hour',                 [], ...
    'min',                  [], ...
    'sec',                  [], ...
    'timeType',             '', ...% NULL / GPST / BDT / UTC
    'timeCheck',            [], ...% 时间更新标志位
    ...% the updating counter of receiver clk error to different systems.
    ...% The counter content stands for the time elapsed since last receiver
    ...% clock error correcttion.
    ...% (1)-BDS; (2)-GPS; (3)-GLONASS; (4)-GALILEO
    'rclkErr2Syst_UpCnt',   ones(1,4), ...
    ...% rclkErr2Syst updating counter threshold, exceeding this length without 
    ...% updating means the current receiver clk error to the current system might be invalid
    'rclkErr2Syst_Thre',    3600, ...
    'BDT2GPST',             [], ...
    'tNext',                [], ...% 下一次定位的时间
    'CL_time',              -1  ...% CL码时间，0~1.5s, 用于CL码捕获加速
);

%% PVT Calculator Structure
pvtCalculator = struct(...
        'BDS',                      [], ...
        'GPS',                      [], ...
        'positionValid',            -1, ...% Receiver PVT valid flag: -1 invalid / 1 valid
        'positionXYZ',              2e10*ones(3,1), ...
        'positionLLH',              2e10*ones(3,1), ...
        'positionTime',             2e10*ones(6,1), ...
        'positionDOP',              zeros(5,1), ... % GDOP、PDOP、HDOP、VDOP、TDOP
        'positionVelocity',         zeros(3,1),     ...
        'positionAccelaration',         zeros(3,1),     ...
        'clkErr',                   zeros(2,3),     ... % receiver clock error, error velocity,error accelaration; row1 is for BDS; row2 is for GPS
        'posiLast',                 zeros(3,1),     ...     % 记录上一次正确的定位及定速结果
        'posiTag',                  -1,              ...     % reserved
        ...% posiCheck indicates the PVT solution confidence:
        ...     -1:  initial status and no pvt solution
        ...      0:  pvt solution computed but no confidence (no raim checking)
        ...      1:  pvt solution computed with confidence (passing raim)
        ...      2:  pvt solution is the predicted one
        'posiCheck',                -1,              ...     % 若定位方程大于等于5个，且残差小于阈值，则认为定位结果可信，则置1
        'timeLast',                 -1,              ...     % 记录此次定位结果对应的时间（SOW）
        'maxInterval',              10,             ...     % 信任上次定位结果的最长时间间隔（/s）
        'raimTimes',                0,              ...     % 本次定位进入raim的次数
        'pvtSats',                  [],             ... % sats involved in pvt solution
        'pvtReadySats',             [],             ... % sats ready for pvt computation
        'kalman',                   '',             ...
        'posForecast',              zeros(3,1),     ... % predicted position at next epoch
        'clkErrForecast',           zeros(2,1),     ... % predicted local clk error caused by the drifting at next epoch
        'pvtT',                     1,              ... % PVT updating interval [sec]
        'dataNum',                  -1,             ...
        'logOutput',                ''              ...     
);
pvtCalculator.pvtSats = struct(...
    'pvtS_Num',                 0, ...% number of satellites used in pvt
    'pvtS_prnList',             [] ...% prn list of satellites used in pvt
);
pvtCalculator.pvtSats(1:sysNum) = pvtCalculator.pvtSats;
pvtCalculator.pvtReadySats      = pvtCalculator.pvtSats;

pvtCalculator.kalman = struct(...
    'preTag',                   0,...% Kalman filter initialization flag: 1 - initialized
    ...'state',                    zeros(8,1),...%[x,y,z,vx,vy,vz,ax,ay,az,dt,dtf,daf]
    'stt_x',                    zeros(3,1), ... %[x,vx], x-component position-velocity state vector
    'stt_y',                    zeros(3,1), ... %[y,vy], y-component position-velocity state vector
    'stt_z',                    zeros(3,1), ... %[z,vz], z-component position-velocity state vector
    'stt_dtf',                  zeros(3,2), ... %col1 for receiver2system1 clk error state vector; col2 for receiver2system2 clk error state vector
    'T',                        0, ...% Kalman updating period T
    ...'PHI',                      zeros(8,8), ...% Kalman state transition matrix
    'Ac',                       zeros(3,3), ...% sub-transition matrix, [2x2]
    'Qp',                       zeros(3,3), ...% sub-transition covariance matrix for pos-vel set
    'Qb',                       zeros(3,3), ...% sub-transition covariance matrix for clk error 
    ...'Q',                        zeros(8,1), ...% state transition covariance matrix in continuous sense
    ...'Qw',                       zeros(8,8), ...% Kalman state transition digitial covariance matrix
    'Rv',                       zeros(3,1), ...% Kalman measurement covariance matrix floor value [psr, vel]
    'Pxyz0',                    zeros(3,1), ...% Initial state covariance diagonal vector for x/y/z componet vector;:e1 is for position, e2 is for velocity
    'Pb0',                      zeros(3,1), ...% initial state covariance diagonal vector for receiver2system clk error: e1 for dt, e2 for df
    'Ra',                       zeros(3,1),...
     'P',                        [] ...% array(3,1, zeros(2,2)), Real time state covariance matrix respectively for x/y/z components
    ...'Pb',                       [] ...% array(2,1, zeros(2,2)), Real time state covariance matrix respectively for clk error components of BDS and GPS
);
% pvtCalculator.kalman.Pxyz.Psub = zeros(2,2); % covariance matrix of sub-vector [x,vx]/[y,vy]/[z,vz]
% pvtCalculator.kalman.Pb.Ptdf = zeros(2,2); % covariance matrix of sub-vector [dt1,df1]/[dt2,df2]/[dtxxx,dfxxx]

pvtCalculator.logOutput = struct(...
    'logReady',             0,  ...     % 值为1的时候log
    'logName',              '', ...     % log文件的文件名
    'transmitTime',         '',...      % 发射时间
    'logTimes',             '',...      % 记录次数
    'rawP',                 '', ...     % 观测伪距
    'satClkErr',            '', ...     % 卫星钟差和钟漂
    'GPSephUpdate',         [], ...     % GPS星历更新标志位
    'BDSephUpdate',         [], ...     % BD星历更新标志位
    'GPSionoUpdate',        [], ...     % GPS电离层更新标志位
    'satPos',               '', ...     % 定位时刻粗卫星位置
    'position',             '' ...     %      
    );

DS = struct(...                      % 初始化差分信息和界面显示信息
        'SOW',                  '', ...
        'subFrameID',           '', ...
        'CNR',                  '', ...
        'SNR',                  '', ...
        'carriVar',             '', ...
        'hatchValue',               [],    ...
        'prevEph',                  '',             ...
        'prError',                  '',             ...
        'diffFile',                 '',             ...
        'carriError',               '',             ...
        'towSec',                   '',             ...
        'doubleDiff',               '',             ...
        'sateStatus',               [],    ...
        ...% BDS/GPS.doppSmooth: matrix [BDS/GPS_maxPrnNo x 4]
        ...% col1 - 当前时刻的积分多普勒值
        ...% col2 - 前一时刻的积分多普勒值
        ...% col3 - 当前时刻的多普勒值
        ...% col4 - flag for valid continuous two smothDoppler values
        'doppSmooth',               []     ...
);
DS.doubleDiff = struct(...           % 初始化载波相位双差参数
        'basePrn',                  '',             ...
        'numTime',                  -5,             ...
        'vector',                   [],             ...
        'nfixedValue',              0,              ...
        'obs',                      []              ...
);
pvtCalculator.BDS = DS;
pvtCalculator.GPS = DS;

receiver.pvtCalculator = pvtCalculator;

%% recvRecor
receiver.recvRecor = struct(...
    'recvStatuslogName',            [] ...%receiver status log file name
);

%% environment
receiver.environment = struct(...
    'recvMotion',           'unknown',          ... % unknown / static / dynamic....
    'scene',                'unknown',          ... % unknown / highway / suburb / urban ......
    'averageVel',           0                   ...
);

end