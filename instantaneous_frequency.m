...done
function [ IF ] = instantaneous_frequency( windows , n , Fs,STFT,NFFT)
    
    IF = [];
    
    for i = 1 : n
        z = hilbert(windows(i,:));
        instfreq_t = Fs/(2*pi)*diff(unwrap(angle(z)));
        instfreq_w = fft(instfreq_t,STFT);
        IF = cat(1,IF,abs(instfreq_w(1:NFFT)));
    end
    IF(isnan(IF)) = 0.0;
end

