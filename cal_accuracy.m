function [  ] = cal_accuracy( handles )
    
    global LMS_net;
    global RLMS_net;
    global IF_net;
    global GD_net;
    global MGD_net;
    global BPD_net;
    global train_status;
    global init_status;
    
    if ~init_status || ~train_status
        return;
    end
    
    set(handles.create_networks,'Enable','off');
    set(handles.train_networks,'Enable','off');
    set(handles.simulate_networks,'Enable','off');
    set(handles.find_accuracy,'Enable','off');
    
    input2 = get(handles.input2,'String');
    total_files = str2num(input2);
    
    if length(total_files) == 0
        errordlg('input should be an integer','Error');
        set(handles.find_accuracy,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.create_networks,'Enable','on');
        return;
    end
    
    if total_files <= 2
        errordlg('input number should be >= 5','Error');
        set(handles.find_accuracy,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.create_networks,'Enable','on');
        return;
    end
    
    addpath('DATABASE\protocol\CM_protocol');
    addpath('DATABASE\wav');
        
    trainfile_name = 'DATABASE\protocol\CM_protocol\cm_evaluation.txt';
    
    try
        fileID = fopen(trainfile_name,'r');
        formatted_data = textscan(fileID,'%s %s %s %s');
        fclose(fileID);
    catch
        errordlg('Error in open evaluation protocol.','Error');
        set(handles.create_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.find_accuracy,'Enable','on');
%        rethrow(lasterror);
        return;
    end
    
    pas0=10000;
    true_result=0;
    false_result=0;
    genuine_scores=[]; %like human output human
    impostor_scores=[]; %like spoof output spoof
    impostor_s1s5k_LMS=[];impostor_s1s5k_RLMS=[];impostor_s1s5k_IF=[];impostor_s1s5k_BPD=[];impostor_s1s5k_GD=[];impostor_s1s5k_MGD=[];
    impostor_s6s9u_LMS=[];impostor_s6s9u_RLMS=[];impostor_s6s9u_IF=[];impostor_s6s9u_BPD=[];impostor_s6s9u_GD=[];impostor_s6s9u_MGD=[];
    impostor_s10u_LMS=[];impostor_s10u_RLMS=[];impostor_s10u_IF=[];impostor_s10u_BPD=[];impostor_s10u_GD=[];impostor_s10u_MGD=[];
    FAR_val=0;
    FAR_val_s1s5k_LMS=0;FAR_val_s1s5k_RLMS=0;FAR_val_s1s5k_IF=0;FAR_val_s1s5k_BPD=0;FAR_val_s1s5k_GD=0;FAR_val_s1s5k_MGD=0;
    FAR_val_s6s9u_LMS=0;FAR_val_s6s9u_RLMS=0;FAR_val_s6s9u_IF=0;FAR_val_s6s9u_BPD=0;FAR_val_s6s9u_GD=0;FAR_val_s6s9u_MGD=0;
    FAR_val_s10u_LMS=0;FAR_val_s10u_RLMS=0;FAR_val_s10u_IF=0;FAR_val_s10u_BPD=0;FAR_val_s10u_GD=0;FAR_val_s10u_MGD=0;
    
    window_length = 0.025; %in ms
    overlap_length = 0.015; %in ms
    
    STFT = 512;
    NFFT = 256;
        
    length_of_file = length(formatted_data{1});
    inc = 1;
    counter_file = [total_files total_files total_files total_files total_files total_files total_files total_files total_files total_files total_files];
    
    msgh = 'human : ';
    msgs1 = 'S1    : ';
    msgs2 = 'S2    : ';
    msgs3 = 'S3    : ';
    msgs4 = 'S4    : ';
    msgs5 = 'S5    : ';
    msgs6 = 'S6    : ';
    msgs7 = 'S7    : ';
    msgs8 = 'S8    : ';
    msgs9 = 'S9    : ';
    msgs10 = 'S10   : ';
    
        for i = 1:inc:length_of_file
            
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
            elseif strcmp(tech,'S6')
                if counter_file(7) == 0
                    continue;
                else
                    counter_file(7) = counter_file(7)-1;
                end
            elseif strcmp(tech,'S7')
                if counter_file(8) == 0
                    continue;
                else
                    counter_file(8) = counter_file(8)-1;
                end
            elseif strcmp(tech,'S8')
                if counter_file(9) == 0
                    continue;
                else
                    counter_file(9) = counter_file(9)-1;
                end
            elseif strcmp(tech,'S9')
                if counter_file(10) == 0
                    continue;
                else
                    counter_file(10) = counter_file(10)-1;
                end
            elseif strcmp(tech,'S10')
                if counter_file(11) == 0
                    continue;
                else
                    counter_file(11) = counter_file(11)-1;
                end
            else
                continue;
            end
            
            wavfile_name = strcat('DATABASE\wav\',folder,'\',filename,'.wav')
            
            try
                [y_whole,Fs] = audioread(wavfile_name);
            catch
                errordlg('Error in read audio file.','Error');
                set(handles.create_networks,'Enable','on');
                set(handles.train_networks,'Enable','on');
                set(handles.simulate_networks,'Enable','on');
                set(handles.find_accuracy,'Enable','on');
%                rethrow(lasterror);
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
            
            LMS_out = LMS_net(LMS_in);
            RLMS_out = RLMS_net(RLMS_in);
            IF_out = IF_net(IF_in);
            BPD_out = BPD_net(BPD_in);
            GD_out = GD_net(GD_in);
            MGD_out = MGD_net(MGD_in);
            
            [score] = fusion([LMS_out;RLMS_out;IF_out;BPD_out;GD_out;MGD_out]);
            [score_LMS] = fusion(LMS_out);
            [score_RLMS] = fusion(RLMS_out);
            [score_IF] = fusion(IF_out);
            [score_BPD] = fusion(BPD_out);
            [score_GD] = fusion(GD_out);
            [score_MGD] = fusion(MGD_out);
            
            if strcmp(spoof_status,'human')
                genuine_scores = cat(2,genuine_scores,score);
                desire_result=0;
            elseif strcmp(spoof_status,'spoof')
                impostor_scores = cat(2,impostor_scores,score);
                desire_result=1;
                
                if(abs(1-score_LMS) <= abs(score_LMS))  %for LMS
                    final_LMS = 1;
                else
                    final_LMS = 0;
                end
                if(abs(1-score_RLMS) <= abs(score_RLMS))  %for RLMS
                    final_RLMS = 1;
                else
                    final_RLMS = 0;
                end
                if(abs(1-score_IF) <= abs(score_IF))  %for IF
                    final_IF = 1;
                else
                    final_IF = 0;
                end
                if(abs(1-score_BPD) <= abs(score_BPD))  %for BPD
                    final_BPD = 1;
                else
                    final_BPD = 0;
                end
                if(abs(1-score_GD) <= abs(score_GD))  %for GD
                    final_GD = 1;
                else
                    final_GD = 0;
                end
                if(abs(1-score_MGD) <= abs(score_MGD))  %for MGD
                    final_MGD = 1;
                else
                    final_MGD = 0;
                end
                
                if strcmp(tech,'S1') || strcmp(tech,'S2') || strcmp(tech,'S3') || strcmp(tech,'S4') || strcmp(tech,'S5')
                    impostor_s1s5k_LMS = cat(2,impostor_s1s5k_LMS,score_LMS);
                    impostor_s1s5k_RLMS = cat(2,impostor_s1s5k_RLMS,score_RLMS);
                    impostor_s1s5k_IF = cat(2,impostor_s1s5k_IF,score_IF);
                    impostor_s1s5k_BPD = cat(2,impostor_s1s5k_BPD,score_BPD);
                    impostor_s1s5k_GD = cat(2,impostor_s1s5k_GD,score_GD);
                    impostor_s1s5k_MGD = cat(2,impostor_s1s5k_MGD,score_MGD);
                    
                    if desire_result==1 && final_LMS==0   %for LMS
                        FAR_val_s1s5k_LMS = FAR_val_s1s5k_LMS+1;
                    end
                    if desire_result==1 && final_RLMS==0   %for RLMS
                        FAR_val_s1s5k_RLMS = FAR_val_s1s5k_RLMS+1;
                    end
                    if desire_result==1 && final_IF==0   %for IF
                        FAR_val_s1s5k_IF = FAR_val_s1s5k_IF+1;
                    end
                    if desire_result==1 && final_BPD==0   %for BPD
                        FAR_val_s1s5k_BPD = FAR_val_s1s5k_BPD+1;
                    end
                    if desire_result==1 && final_GD==0   %for GD
                        FAR_val_s1s5k_GD = FAR_val_s1s5k_GD+1;
                    end
                    if desire_result==1 && final_MGD==0   %for MGD
                        FAR_val_s1s5k_MGD = FAR_val_s1s5k_MGD+1;
                    end
                elseif strcmp(tech,'S6') || strcmp(tech,'S7') || strcmp(tech,'S8') || strcmp(tech,'S9')
                    impostor_s6s9u_LMS = cat(2,impostor_s6s9u_LMS,score_LMS);
                    impostor_s6s9u_RLMS = cat(2,impostor_s6s9u_RLMS,score_RLMS);
                    impostor_s6s9u_IF = cat(2,impostor_s6s9u_IF,score_IF);
                    impostor_s6s9u_BPD = cat(2,impostor_s6s9u_BPD,score_BPD);
                    impostor_s6s9u_GD = cat(2,impostor_s6s9u_GD,score_GD);
                    impostor_s6s9u_MGD = cat(2,impostor_s6s9u_MGD,score_MGD);
                    
                    if desire_result==1 && final_LMS==0   %for LMS
                        FAR_val_s6s9u_LMS = FAR_val_s6s9u_LMS+1;
                    end
                    if desire_result==1 && final_RLMS==0   %for RLMS
                        FAR_val_s6s9u_RLMS = FAR_val_s6s9u_RLMS+1;
                    end
                    if desire_result==1 && final_IF==0   %for IF
                        FAR_val_s6s9u_IF = FAR_val_s6s9u_IF+1;
                    end
                    if desire_result==1 && final_BPD==0   %for BPD
                        FAR_val_s6s9u_BPD = FAR_val_s6s9u_BPD+1;
                    end
                    if desire_result==1 && final_GD==0   %for GD
                        FAR_val_s6s9u_GD = FAR_val_s6s9u_GD+1;
                    end
                    if desire_result==1 && final_MGD==0   %for MGD
                        FAR_val_s6s9u_MGD = FAR_val_s6s9u_MGD+1;
                    end
                elseif strcmp(tech,'S10')
                    impostor_s10u_LMS = cat(2,impostor_s10u_LMS,score_LMS);
                    impostor_s10u_RLMS = cat(2,impostor_s10u_RLMS,score_RLMS);
                    impostor_s10u_IF = cat(2,impostor_s10u_IF,score_IF);
                    impostor_s10u_BPD = cat(2,impostor_s10u_BPD,score_BPD);
                    impostor_s10u_GD = cat(2,impostor_s10u_GD,score_GD);
                    impostor_s10u_MGD = cat(2,impostor_s10u_MGD,score_MGD);
                    
                    if desire_result==1 && final_LMS==0   %for LMS
                        FAR_val_s10u_LMS = FAR_val_s10u_LMS+1;
                    end
                    if desire_result==1 && final_RLMS==0   %for RLMS
                        FAR_val_s10u_RLMS = FAR_val_s10u_RLMS+1;
                    end
                    if desire_result==1 && final_IF==0   %for IF
                        FAR_val_s10u_IF = FAR_val_s10u_IF+1;
                    end
                    if desire_result==1 && final_BPD==0   %for BPD
                        FAR_val_s10u_BPD = FAR_val_s10u_BPD+1;
                    end
                    if desire_result==1 && final_GD==0   %for GD
                        FAR_val_s10u_GD = FAR_val_s10u_GD+1;
                    end
                    if desire_result==1 && final_MGD==0   %for MGD
                        FAR_val_s10u_MGD = FAR_val_s10u_MGD+1;
                    end
                end
            end
                        
            if(abs(1-score) <= abs(score))  %for final
                final_score = 1;
                score_status = 'spoof';
            else
                final_score = 0;
                score_status = 'human';
            end
            
            if(final_score==desire_result)  %for final
                true_result = true_result+1;
            else
                false_result = false_result+1;
            end
            
            if desire_result==1 && final_score==0   %for final
                FAR_val = FAR_val+1;
            end
            
            if strcmp(tech,'human')
                msgh = strcat(msgh,score_status,', ');
            elseif strcmp(tech,'S1')
                msgs1 = strcat(msgs1,score_status,', ');
            elseif strcmp(tech,'S2')
                msgs2 = strcat(msgs2,score_status,', ');
            elseif strcmp(tech,'S3')
                msgs3 = strcat(msgs3,score_status,', ');
            elseif strcmp(tech,'S4')
                msgs4 = strcat(msgs4,score_status,', ');
            elseif strcmp(tech,'S5')
                msgs5 = strcat(msgs5,score_status,', ');
            elseif strcmp(tech,'S6')
                msgs6 = strcat(msgs6,score_status,', ');
            elseif strcmp(tech,'S7')
                msgs7 = strcat(msgs7,score_status,', ');
            elseif strcmp(tech,'S8')
                msgs8 = strcat(msgs8,score_status,', ');
            elseif strcmp(tech,'S9')
                msgs9 = strcat(msgs9,score_status,', ');
            elseif strcmp(tech,'S10')
                msgs10 = strcat(msgs10,score_status,', ');
            end
            
        end
    
    total_result = true_result + false_result;    
    FAR_val_per = (FAR_val/length(impostor_scores))*100;
    FAR_val_per_s1s5k_LMS = (FAR_val_s1s5k_LMS/length(impostor_s1s5k_LMS))*100;
    FAR_val_per_s1s5k_RLMS = (FAR_val_s1s5k_RLMS/length(impostor_s1s5k_RLMS))*100;
    FAR_val_per_s1s5k_IF = (FAR_val_s1s5k_IF/length(impostor_s1s5k_IF))*100;
    FAR_val_per_s1s5k_BPD = (FAR_val_s1s5k_BPD/length(impostor_s1s5k_BPD))*100;
    FAR_val_per_s1s5k_GD = (FAR_val_s1s5k_GD/length(impostor_s1s5k_GD))*100;
    FAR_val_per_s1s5k_MGD = (FAR_val_s1s5k_MGD/length(impostor_s1s5k_MGD))*100;
    FAR_val_per_s6s9u_LMS = (FAR_val_s6s9u_LMS/length(impostor_s6s9u_LMS))*100;
    FAR_val_per_s6s9u_RLMS = (FAR_val_s6s9u_RLMS/length(impostor_s6s9u_RLMS))*100;
    FAR_val_per_s6s9u_IF = (FAR_val_s6s9u_IF/length(impostor_s6s9u_IF))*100;
    FAR_val_per_s6s9u_BPD = (FAR_val_s6s9u_BPD/length(impostor_s6s9u_BPD))*100;
    FAR_val_per_s6s9u_GD = (FAR_val_s6s9u_GD/length(impostor_s6s9u_GD))*100;
    FAR_val_per_s6s9u_MGD = (FAR_val_s6s9u_MGD/length(impostor_s6s9u_MGD))*100;
    FAR_val_per_s10u_LMS = (FAR_val_s10u_LMS/length(impostor_s10u_LMS))*100;
    FAR_val_per_s10u_RLMS = (FAR_val_s10u_RLMS/length(impostor_s10u_RLMS))*100;
    FAR_val_per_s10u_IF = (FAR_val_s10u_IF/length(impostor_s10u_IF))*100;
    FAR_val_per_s10u_BPD = (FAR_val_s10u_BPD/length(impostor_s10u_BPD))*100;
    FAR_val_per_s10u_GD = (FAR_val_s10u_GD/length(impostor_s10u_GD))*100;
    FAR_val_per_s10u_MGD = (FAR_val_s10u_MGD/length(impostor_s10u_MGD))*100;
    
    final_msg = strvcat(msgh,msgs1,msgs2,msgs3,msgs4,msgs5,msgs6,msgs7,msgs8,msgs8,msgs10);
    msgbox(final_msg,'final outputs of system');
    
    try
        [EER confInterEER OP confInterOP] = EER_DET_conf(genuine_scores,impostor_scores,FAR_val_per,pas0,true);
        
        accuracy = (true_result/total_result)*100;
        message1 = strcat('accuracy of the system is : ',num2str(accuracy),'%');
        message2 = strcat('equal error rate of the whole system is : ',num2str(EER));
        message = strvcat(message1,message2);
        msgbox(message,'accuracy and eer');
        
%        [EER_s1s5k_LMS confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_LMS,FAR_val_per_s1s5k_LMS,pas0,false);
%        [EER_s1s5k_RLMS confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_RLMS,FAR_val_per_s1s5k_RLMS,pas0,false);
%        [EER_s1s5k_IF confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_IF,FAR_val_per_s1s5k_IF,pas0,false);
%        [EER_s1s5k_BPD confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_BPD,FAR_val_per_s1s5k_BPD,pas0,false);
%        [EER_s1s5k_GD confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_GD,FAR_val_per_s1s5k_GD,pas0,false);
%        [EER_s1s5k_MGD confInterEER_s1s5k OP_s1s5k confInterOP_s1s5k] = EER_DET_conf(genuine_scores,impostor_s1s5k_MGD,FAR_val_per_s1s5k_MGD,pas0,false);
        
%        [EER_s6s9u_LMS confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_LMS,FAR_val_per_s6s9u_LMS,pas0,false);
%        [EER_s6s9u_RLMS confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_RLMS,FAR_val_per_s6s9u_RLMS,pas0,false);
%        [EER_s6s9u_IF confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_IF,FAR_val_per_s6s9u_IF,pas0,false);
%        [EER_s6s9u_BPD confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_BPD,FAR_val_per_s6s9u_BPD,pas0,false);
%        [EER_s6s9u_GD confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_GD,FAR_val_per_s6s9u_GD,pas0,false);
%        [EER_s6s9u_MGD confInterEER_s6s9u OP_s6s9u confInterOP_s6s9u] = EER_DET_conf(genuine_scores,impostor_s6s9u_MGD,FAR_val_per_s6s9u_MGD,pas0,false);
        
%        [EER_s10u_LMS confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_LMS,FAR_val_per_s10u_LMS,pas0,false);
%        [EER_s10u_RLMS confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_RLMS,FAR_val_per_s10u_RLMS,pas0,false);
%        [EER_s10u_IF confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_IF,FAR_val_per_s10u_IF,pas0,false);
%        [EER_s10u_BPD confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_BPD,FAR_val_per_s10u_BPD,pas0,false);
%        [EER_s10u_GD confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_GD,FAR_val_per_s10u_GD,pas0,false);
%        [EER_s10u_MGD confInterEER_s10u OP_s10u confInterOP_s10u] = EER_DET_conf(genuine_scores,impostor_s10u_MGD,FAR_val_per_s10u_MGD,pas0,false);
        
    catch
        errordlg(strvcat('There is some error with number of files,','please try with big number of files.'),'Error');
        set(handles.create_networks,'Enable','on');
        set(handles.train_networks,'Enable','on');
        set(handles.simulate_networks,'Enable','on');
        set(handles.find_accuracy,'Enable','on');
        rethrow(lasterror);
        return;
    end
    
%    avg_eer_s1s5k = mean([EER_s1s5k_LMS EER_s1s5k_RLMS EER_s1s5k_IF EER_s1s5k_BPD EER_s1s5k_GD EER_s1s5k_MGD],2);
%    avg_eer_s6s9u = mean([EER_s6s9u_LMS EER_s6s9u_RLMS EER_s6s9u_IF EER_s6s9u_BPD EER_s6s9u_GD EER_s6s9u_MGD],2);
%    avg_eer_s10u = mean([EER_s10u_LMS EER_s10u_RLMS EER_s10u_IF EER_s10u_BPD EER_s10u_GD EER_s10u_MGD],2);
    
%    msg0 = 'spoof type Vs features EER';
%    msg1 = 'Type  LMS   RLMS  IF    BPD   GD    MGD   AVG   ';
%    msg2 = strcat('S1-S5 ', num2str(EER_s1s5k_LMS) , '    ' , num2str(EER_s1s5k_RLMS) , '    ' , num2str(EER_s1s5k_IF) , '    ' , num2str(EER_s1s5k_BPD) , '    ' , num2str(EER_s1s5k_GD) , '    ' , num2str(EER_s1s5k_MGD) , '    ' , num2str(avg_eer_s1s5k) );
%    msg3 = strcat('S6-S9 ', num2str(EER_s6s9u_LMS) , '    ' , num2str(EER_s6s9u_RLMS) , '    ' , num2str(EER_s6s9u_IF) , '    ' , num2str(EER_s6s9u_BPD) , '    ' , num2str(EER_s6s9u_GD) , '    ' , num2str(EER_s6s9u_MGD) , '    ' , num2str(avg_eer_s6s9u) );
%    msg4 = strcat('S10   ', num2str(EER_s10u_LMS) , '    ' , num2str(EER_s10u_RLMS) , '    ' , num2str(EER_s10u_IF) , '    ' , num2str(EER_s10u_BPD) , '    ' , num2str(EER_s10u_GD) , '    ' , num2str(EER_s10u_MGD) , '    ' , num2str(avg_eer_s10u) );
%    msg = strvcat(msg0,msg1,msg2,msg3,msg4);
%    msgbox(msg,'spoof type Vs features EER');
    
    set(handles.create_networks,'Enable','on');
    set(handles.train_networks,'Enable','on');
    set(handles.simulate_networks,'Enable','on');
    set(handles.find_accuracy,'Enable','on');
end