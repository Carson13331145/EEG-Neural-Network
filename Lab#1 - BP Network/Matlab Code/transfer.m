function [ ] = transfer( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

enum_cpd = { '0.05cpd' '0.1cpd' '0.3cpd' };
enum_cpd_nodot = { '005cpd' '01cpd' '03cpd' };
enum_cps = { '1cps' '5cps' '10cps' };
enum_deg = { '0deg' '90deg' };
enum_channel = [ 27, 29, 64 ];

dir = 'E:\DATA\';
savefolder = [ 'E:\DATA\' ];

if (~isdir(savefolder))
    mkdir(savefolder);
end

fid = fopen('sub_train_v4.csv', 'a');
fid_t = fopen('sub_test_v4.csv', 'a');
for personI = 4 : 4
    for cpdI = 2 : 3
        for blockI = 1 : 5
            openfolder = [ dir 'sub' num2str(personI) '\' ];
            dataFile = [ openfolder 'sub' num2str(personI) '_' ...
               enum_cpd{cpdI} '_block' num2str(blockI) '.set' ];
            
            EEG_beforeEpoch = pop_loadset(dataFile);
            % get epochNum ...
            for cpsI = 1 : 3
                for degI = 1 : 2
                    epochNum = (cpsI - 1) * 2 + degI;
                    EEG = pop_epoch( EEG_beforeEpoch, num2cell(epochNum) , ...
                        [ -0.2 0.8 ], 'newname', [ EEG_beforeEpoch.setname ...
                        ' epoch' num2str(epochNum) ], 'epochinfo', 'yes');
                    [CH, TI, EV] = size(EEG.data);
                    
                    %toFile = double(zeros(1, 8193));
                    label = (cpdI - 1) * 6 + (cpsI - 1) * 2 + degI;
                    %toFile(1, 1) = label;
                    for eventI = 1 : EV/2
                        fprintf(fid, '%d,', label);
                        fix_mean = 0;
                        for channelI = 1 : 3
                            fix_mean = mean( ...
                                EEG.data(enum_channel(1, channelI), 1:2048, eventI));
                            for timeI = 1 : 2048
                                %toFile(1, (channelI - 1) * 2048 + timeI + 1) = ...
                                %    EEG.data(channelI * 8 - 1, timeI, eventI);
                                fprintf(fid, '%.1f,', ...
                                    EEG.data(enum_channel(1, channelI), ...
                                    timeI, eventI)-fix_mean);
                            end
                        end
                        fprintf(fid, '1\n');
                    end
                    for eventI = EV/2 + 1 : EV
                        fprintf(fid_t, '%d,', label);
                        fix_mean = 0;
                        for channelI = 1 : 3
                            fix_mean = mean( ...
                            EEG.data(enum_channel(1, channelI), 1:2048, eventI));
                            for timeI = 1 : 2048
                                %toFile(1, (channelI - 1) * 2048 + timeI + 1) = ...
                                %    EEG.data(channelI * 8 - 1, timeI, eventI);
                                fprintf(fid_t, '%.1f,', ...
                                    EEG.data(enum_channel(1, channelI), ...
                                    timeI, eventI)-fix_mean);
                            end
                        end
                        fprintf(fid_t, '1\n');
                    end
                end
            end
            process = [ num2str((personI - 1) * 15 ...
                + (cpdI - 1) * 5 + blockI) '/60']
        end
    end
end

end

