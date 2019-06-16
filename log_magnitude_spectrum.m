...done
function [ LMS ] = log_magnitude_spectrum( fft_windows , n , NFFT)
    
    LMS = [];
    
    for i = 1 : n
        fft_win = fft_windows(i,:);
        mag_fft = abs(fft_win);
        log_mag_fft = log(mag_fft);
        LMS = cat(1,LMS,log_mag_fft(1:NFFT));
    end
    LMS(isnan(LMS)) = 0.0;
end

