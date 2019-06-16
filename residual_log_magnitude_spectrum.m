...done
function [ RLMS ] = residual_log_magnitude_spectrum(windows , n , Fs ,STFT ,NFFT)

    RLMS = [];
...    F0 = [];
    residual_win = [];
    p = floor(Fs/1000)+2;
    N = size(windows,2);
    
    for i=1:n
        win = windows(i,:);
        win_corr = autocorrelation(win',N);
        win_corr = win_corr';
        win_corr = win_corr./(abs(max(win_corr)));
        A = win_corr(1:p);
        r = win_corr(2:p+1);
        A = toeplitz(A);
        L = -inv(A)*r';
        L=L';
        LPCoff(1,1:length([1,L])) = [1,L];
        
        residual = convolution(win,LPCoff);
        residual = residual(round(p/2):length(residual)-round(p/2)-1);
        residual_win = cat(1,residual_win,residual);
        
...        resi_corr = autocorrelation(residual',N);
...        resi_corr = resi_corr';
...        resi_corr = resi_corr./(abs(max(resi_corr)));
        
...        min_pitch = 20;
...        max_pitch = N;
...        sub_resi_corr = resi_corr(min_pitch:max_pitch);
...        [y_val,y_loc] = max(sub_resi_corr);
...        pitch_period = min_pitch+y_loc;
...        pitch_freq = (1./pitch_period)*Fs;
        
...        F0 = cat(1,F0,pitch_freq);
    end
    
    [stft_windows_res] = convert_stft(residual_win,n,STFT);
    [ RLMS ] = log_magnitude_spectrum(stft_windows_res , n, NFFT);
...    F0(isnan(F0)) = 0.0;
end