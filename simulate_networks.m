function [] = simulate_networks(handles)
    
    global LMS_net;
    global RLMS_net;
    global IF_net;
    global GD_net;
    global MGD_net;
    global BPD_net;
    global init_status;
    global train_status;
    global simulate_data;
    
    if (~init_status || ~train_status)
        return;
    end
    
    [filename , pathname] = uigetfile({'*.wav'},'File Selector');
    
    if ~pathname
        return
    end
    
    set(handles.create_networks,'Enable','off');
    set(handles.train_networks,'Enable','off');
    set(handles.simulate_networks,'Enable','off');
    set(handles.find_accuracy,'Enable','off');
    
    fullpath = strcat(pathname,filename);
    
    window_length = 0.025; ...in ms
    overlap_length = 0.015; ...in ms
    
    STFT = 512;
    NFFT = 256;
    
    index = strfind(simulate_data{2},filename(1:length(filename)-4));
    index = find(not(cellfun('isempty', index)));
    
    if(index)
        final_score_database = simulate_data{4}{index};
    end
    
    try
        [y_whole,Fs] = audioread(fullpath);
    catch
        errordlg('Error in open audio file.','Error');
        set(handles.find_accuracy,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.create_networks,'Enable','on');
...        rethrow(lasterror);
        return;
    end
        [windows , n] = create_window(y_whole,Fs,window_length,overlap_length);
        [stft_windows] = convert_stft(windows,n,STFT);
        
        [ LMS ] = log_magnitude_spectrum(stft_windows,n,NFFT);
        [ RLMS ] = residual_log_magnitude_spectrum(windows,n,Fs,STFT,NFFT);
        [ IF ] =  instantaneous_frequency(windows,n,Fs,STFT,NFFT);
        [ BPD ] = baseband_phase_difference(IF,n,Fs,STFT,NFFT,window_length,overlap_length);
        [ GD ] = group_delay(stft_windows,n,NFFT);
        [ MGD ] = modified_group_delay(windows,STFT,NFFT);
         
        LMS_out = LMS_net(LMS');
        RLMS_out = RLMS_net(RLMS');
        IF_out = IF_net(IF');
        BPD_out = BPD_net(BPD');
        GD_out = GD_net(GD');
        MGD_out = MGD_net(MGD');

        [score] = fusion([LMS_out;RLMS_out;IF_out;BPD_out;GD_out;MGD_out]);
        
        if (abs(1-score) <= abs(score))
            score = 1;
            final_score_neural = 'SPOOF';
        else
            score = 0;
            final_score_neural = 'HUMAN';
        end
        
        message1 = strcat('According to Database : ',final_score_database);
        message2 = strcat('According to neural network : ',final_score_neural);
        message = strvcat(message1,message2);
        msgbox(message,'Success');
        
        set(handles.find_accuracy,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.create_networks,'Enable','on');
end