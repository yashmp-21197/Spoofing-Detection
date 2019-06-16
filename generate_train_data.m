function [ LMS_in , RLMS_in ,IF_in ,BPD_in ,GD_in ,MGD_in , train_out ] = generate_train_data()

    window_length = 0.025; ...in ms
    overlap_length = 0.015; ...in ms
    
    addpath('DATABASE\protocol\CM_protocol');
    addpath('DATABASE\wav');
    
    trainfile_name = 'DATABASE\protocol\CM_protocol\cm_train.txt';

    try
        fileID = fopen(trainfile_name,'r');

        formatted_data = textscan(fileID,'%s %s %s %s');
        fclose(fileID);
        
        length_of_file = length(formatted_data{1});
        
        train_out = [];
        LMS_in = [];
        RLMS_in = [];
        IF_in = [];
        BPD_in = [];
        GD_in = [];
        MGD_in = [];
        inc=1;
...        inc = floor(length_of_file/100);
        inc = floor(length_of_file/10);
        length_of_file=1;
        for i = 1:inc:length_of_file
                
            folder = formatted_data{1}{i};
            filename = formatted_data{2}{i};
            spoof_status = formatted_data{4}{i};
            
            wavfile_name = strcat('DATABASE\wav\',folder,'\',filename,'.wav')
            
            try
                [y_whole,Fs] = audioread(wavfile_name);
                [windows , n] = create_window(y_whole,Fs,window_length,overlap_length);
                [stft_windows] = convert_stft(windows,n,512);

        ...        [ LMS ] = log_magnitude_spectrum(stft_windows , n);
        ...        [ RLMS , F0 ] = residual_log_magnitude_spectrum(windows,n,Fs);
        ...        F0
        ...        [ IF ] =  instantaneous_frequency(windows , n , Fs);
        ...        size(IF)
        ...       [ BPD ] = baseband_phase_difference(IF , n , window_length , overlap_length , Fs , stft_windows);
        ...        size(BPD);
                [ GD ] = group_delay(stft_windows , n,256);
                size(GD)
        ...        [ MGD ] = modified_group_delay(windows);

                if strcmp(spoof_status,'spoof')
                    sample_out = ones(1,n);
                elseif strcmp(spoof_status,'human')
                    sample_out = zeros(1,n);
                end
                
        ...        train_out = cat(2,train_out,sample_out);
        ...        LMS_in = cat(2,LMS_in,LMS');
        ...        RLMS_in = cat(2,RLMS_in,RLMS');
        ...        IF_in = cat(2,IF_in,IF');
        ...        BPD_in = cat(2,BPD_in,BPD');
        ...        GD_in = cat(2,GD_in,GD');
        ...        MGD_in = cat(2,MGD_in,MGD');
         ...       size(GD_in)
              
                clear LMS RLMS IF BPD GD MGD sample_out;
            catch
                rethrow(lasterror);
            end
        end
    catch
        rethrow(lasterror);
    end
end