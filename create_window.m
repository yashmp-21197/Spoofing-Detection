function [windows , n] = create_window(y_whole , Fs , window_length , overlap_length)
    
    n = 0;
    windows = [];
    
    window_size = floor(Fs*window_length);
    overlap_size = floor(Fs*overlap_length);
    
    t = 0 : 1 : window_size-1;
    ham_win = 0.54 - 0.46*cos(2*pi*t/(window_size-1));
    
    y_length = length(y_whole);
    
    for i = 1 : (window_size-overlap_size) : y_length
        if((i+window_size-1) > y_length)
            samples = [y_whole(i : y_length)' zeros(1 , window_size-(y_length-i+1))];
        else
            samples = y_whole(i : i + window_size - 1)';
        end
        samples = samples./(1.01*abs(max(samples)));
        sample_ham_win = samples .* ham_win;
        windows = cat(1,windows,sample_ham_win);
        n = n + 1;
    end
end