...done
function [ MGD ] = modified_group_delay( windows,STFT,NFFT )

    rho=0.7;
    gamma=0.2;
    
    frame_num    = size(windows, 1);
    frame_length = size(windows, 2);
    delay_vector = 1:1:frame_length;
    delay_matrix = repmat(delay_vector, frame_num, 1);

    delay_frames = windows .* delay_matrix;
    x_spec = [];
    y_spec = [];
    
    for i=1:frame_num
        x_s = fft(windows(i,:), STFT);
        y_s = fft(delay_frames(i,:), STFT);
        x_spec = cat(1,x_spec,x_s);
        y_spec = cat(1,y_spec,y_s);
    end
        
    x_spec = x_spec(: , 1:NFFT);
    y_spec = y_spec(: , 1:NFFT);

    temp_x_spec = abs(x_spec);
    
    smooth_spec = [];
    for i =1:frame_num
        mf = medfilt1(log(temp_x_spec(i,:)), 5);
        ds = dct(mf);
        ss = idct(ds(1:30), NFFT);
        smooth_spec = cat(1,smooth_spec,ss);
    end
    
    grp_phase1 = (real(x_spec).*real(y_spec) + imag(y_spec) .* imag(x_spec)) ./(exp(smooth_spec).^ (2*rho));
    grp_phase = (grp_phase1 ./ abs(grp_phase1)) .* (abs(grp_phase1).^ gamma);
        
    grp_phase = grp_phase ./ (max(max(abs(grp_phase))));
    
    MGD = grp_phase;
    MGD(isnan(MGD)) = 0.0;
end