...done
function [ GD ] = group_delay( stft_windows , n ,NFFT)
    
    GD = [];
    
    for i=1:n
        win = stft_windows(i,:);
        g = -1*diff(unwrap(angle(win)));
        GD = cat(1,GD,abs(g(1:NFFT)));
    end
    GD(isnan(GD)) = 0.0;
end

