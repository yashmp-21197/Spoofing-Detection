function [ stft_windows ] = convert_stft( windows , n ,STFT)
    
    stft_windows =[];
    
    for i = 1 : n
        temp_win = windows(i,:);
        stft_window = fft(temp_win , STFT);
        stft_windows = cat(1,stft_windows,stft_window);
    end
end

