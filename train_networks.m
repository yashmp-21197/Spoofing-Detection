function [] = train_networks( handles )
    
    global LMS_net;
    global RLMS_net;
    global IF_net;
    global GD_net;
    global MGD_net;
    global BPD_net;
    global train_status;
    global init_status;
    
    if ~init_status
        return;
    end
    
    train_flag = false;
    
    set(handles.create_networks,'Enable','off');
    set(handles.train_networks,'Enable','off');
    set(handles.simulate_networks,'Enable','off');
    set(handles.find_accuracy,'Enable','off');
    
    disp('start traning neural networks.');
    
    if exist('Trained_Neural_Networks.mat','file')
        answer = questdlg('Would you like to load old trained neural networks?','Confirmation','Yes','No','No');
        if strcmp(answer,'Yes')
            train_flag = true;
        else
            train_flag = false;
        end
    end
    
    if train_flag
        load Trained_Neural_Networks;
    else
        input1 = get(handles.input1,'String');
        total_files = str2num(input1);
        
        if length(total_files) == 0
            errordlg('input should be an integer','Error');
            set(handles.find_accuracy,'Enable','on');
            set(handles.simulate_networks,'Enable','on');
            set(handles.train_networks,'Enable','on');
            set(handles.create_networks,'Enable','on');
            return;
        end
        
        if total_files <= 0
            errordlg('input number should be > 0','Error');
            set(handles.find_accuracy,'Enable','on');
            set(handles.simulate_networks,'Enable','on');
            set(handles.train_networks,'Enable','on');
            set(handles.create_networks,'Enable','on');
            return;
        end
        
        window_length = 0.025; ...in ms
        overlap_length = 0.015; ...in ms
        
        STFT=512;
        NFFT=256;
        
        addpath('DATABASE\protocol\CM_protocol');
        addpath('DATABASE\wav');
        
        trainfile_name = 'DATABASE\protocol\CM_protocol\cm_train.txt';
        
        try
            fileID = fopen(trainfile_name,'r');
            formatted_data = textscan(fileID,'%s %s %s %s');
            fclose(fileID);
        catch
            errordlg('Error in open train protocol.','Error');
            set(handles.find_accuracy,'Enable','on');
            set(handles.simulate_networks,'Enable','on');
            set(handles.train_networks,'Enable','on');
            set(handles.create_networks,'Enable','on');
...            rethrow(lasterror);
            return;
        end
            
            length_of_files = length(formatted_data{1});
            inc = 1;
            counter_file = [total_files total_files total_files total_files total_files total_files];
            
            for i = 1:inc:length_of_files
                
                folder = formatted_data{1}{i};
                filename = formatted_data{2}{i};
                tech = formatted_data{3}{i};
                spoof_status = formatted_data{4}{i};
                
                if strcmp(tech,'human')
                    if counter_file(1) == 0
                        continue;
                    else
                        counter_file(1) = counter_file(1)-1;
                    end
                elseif strcmp(tech,'S1')
                    if counter_file(2) == 0
                        continue;
                    else
                        counter_file(2) = counter_file(2)-1;
                    end
                elseif strcmp(tech,'S2')
                    if counter_file(3) == 0
                        continue;
                    else
                        counter_file(3) = counter_file(3)-1;
                    end
                elseif strcmp(tech,'S3')
                    if counter_file(4) == 0
                        continue;
                    else
                        counter_file(4) = counter_file(4)-1;
                    end
                elseif strcmp(tech,'S4')
                    if counter_file(5) == 0
                        continue;
                    else
                        counter_file(5) = counter_file(5)-1;
                    end
                elseif strcmp(tech,'S5')
                    if counter_file(6) == 0
                        continue;
                    else
                        counter_file(6) = counter_file(6)-1;
                    end
                else
                    continue;
                end
                
                wavfile_name = strcat('DATABASE\wav\',folder,'\',filename,'.wav')
                disp(spoof_status);
                
                try
                    [y_whole,Fs] = audioread(wavfile_name);
                catch
                    errordlg('Error in read audio file.','Error');
                    set(handles.find_accuracy,'Enable','on');
                    set(handles.simulate_networks,'Enable','on');
                    set(handles.train_networks,'Enable','on');
                    set(handles.create_networks,'Enable','on');
...                    rethrow(lasterror);
                    return;
                end
                    [windows , n] = create_window(y_whole,Fs,window_length,overlap_length);
                    [stft_windows] = convert_stft(windows,n,STFT);
                    
                    [ LMS ] = log_magnitude_spectrum(stft_windows,n,NFFT);
                    LMS_in = LMS';
                    [ RLMS ] = residual_log_magnitude_spectrum(windows,n,Fs,STFT,NFFT);
                    RLMS_in = RLMS';
                    [ IF ] =  instantaneous_frequency(windows,n,Fs,STFT,NFFT);
                    IF_in = IF';
                    [ BPD ] = baseband_phase_difference(IF,n,Fs,STFT,NFFT,window_length,overlap_length);
                    BPD_in = BPD';
                    [ GD ] = group_delay(stft_windows,n,NFFT);
                    GD_in = GD';
                    [ MGD ] = modified_group_delay(windows,STFT,NFFT);
                    MGD_in = MGD';
                    
                    if strcmp(spoof_status,'spoof')
                        train_out = ones(1,n);
                    elseif strcmp(spoof_status,'human')
                        train_out = zeros(1,n);
                    end
                    
                 ...   for j=1:length(train_out)
                        LMS_net = train(LMS_net,LMS_in,train_out);
                 ...   end
          ...          for j=1:length(train_out)
                        RLMS_net = train(RLMS_net,RLMS_in,train_out);
          ...          end
          ...          for j=1:length(train_out)
                        IF_net = train(IF_net,IF_in,train_out);
          ...          end
          ...          for j=1:length(train_out)
                        BPD_net = train(BPD_net,BPD_in,train_out);
          ...          end
          ...          for j=1:length(train_out)
                        GD_net = train(GD_net,GD_in,train_out);
          ...          end
          ...          for j=1:length(train_out)
                        MGD_net = train(MGD_net,MGD_in,train_out);
          ...          end
                    clear LMS RLMS IF BPD GD MGD sample_out;
            end
        save('Trained_Neural_Networks.mat','LMS_net','RLMS_net','IF_net','BPD_net','GD_net','MGD_net');
        disp('new trained neural network saved...');
    end
    train_status = true;
    disp('end traning neural networks.');
    set(handles.find_accuracy,'Enable','on');
    set(handles.simulate_networks,'Enable','on');
    set(handles.train_networks,'Enable','on');
    set(handles.create_networks,'Enable','on');
    
    clear LMS_in RLMS_in IF_in BPD_in GD_in MGD_in train_out;
end

