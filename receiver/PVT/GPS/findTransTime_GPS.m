function [transmitTime] = findTransTime_GPS(channels, activeChannel)

% Initialize the transmitting time
transmitTime=zeros(1,32);

% Calculate the transmitting time of each satellite using interpolations
for Nr = 1: length(activeChannel)
    if (strcmp(channels(activeChannel(Nr)).SYST,'GPS_L1CA'))
        transmitTime(channels(activeChannel(Nr)).CH_L1CA(1).PRNID) = ...
            (channels(activeChannel(Nr)).CH_L1CA(1).TOW_6SEC)*6 + ...
            channels(activeChannel(Nr)).CH_L1CA(1).Word_N * 6/10 + ...
            channels(activeChannel(Nr)).CH_L1CA(1).Bit_N * 0.6/30 + ...
            channels(activeChannel(Nr)).CH_L1CA(1).T1ms_N * 0.001 + ...
            channels(activeChannel(Nr)).CH_L1CA(1).LO_CodPhs/1.023e6;
    elseif (strcmp(channels(activeChannel(Nr)).SYST,'GPS_L1CA_L2C'))
        transmitTime(channels(activeChannel(Nr)).CH_L1CA_L2C(1).PRNID) = ...
            (channels(activeChannel(Nr)).CH_L1CA_L2C(1).TOW_6SEC)*6 + ...
            channels(activeChannel(Nr)).CH_L1CA_L2C(1).Word_N * 6/10 + ...
            channels(activeChannel(Nr)).CH_L1CA_L2C(1).Bit_N * 0.6/30 + ...
            channels(activeChannel(Nr)).CH_L1CA_L2C(1).T1ms_N * 0.001 + ...
            channels(activeChannel(Nr)).CH_L1CA_L2C(1).LO_CodPhs/1.023e6;
    end
end
end