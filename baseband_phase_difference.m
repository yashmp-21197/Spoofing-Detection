...done
function [ BPD ] = baseband_phase_difference( IF , n , Fs , STFT , NFFT , window_length , overlap_length)
    
    BPD = [];
    N = STFT;
    u = NFFT;
    L = floor(Fs*(window_length-overlap_length));
    
    for i=1:n
        win = IF(i,:);
        K = i;
        p = (2*pi*K*u/N)*L;
        bpd_win = win - (p);
        BPD = cat(1,BPD,bpd_win(1:NFFT));        
    end
    
    BPD(isnan(BPD)) = 0.0;
end