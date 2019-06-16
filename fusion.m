function [ fusion_score ] = fusion( whole_score_arr )
	whole_score_arr(isnan(whole_score_arr)) = 0.0;
	if(size(whole_score_arr,1)~=1)
		whole_score_arr = mean(whole_score_arr,1);
	end
	n = size(whole_score_arr,2);
	fus_0=0;
	fus_1=0;
	fus0_count=0;
	fus1_count=0;
	
	for i=1:n
		if(abs(whole_score_arr(i)) >= abs(1-whole_score_arr(i)))
			fus1_count=fus1_count+1;
			fus_1=fus_1+whole_score_arr(i);
		else
			fus0_count=fus0_count+1;
			fus_0=fus_0+whole_score_arr(i);
		end
	end
	
	if fus0_count~=fus1_count
		if fus0_count>fus1_count
			fusion_score = (fus_0/fus0_count);
		elseif fus0_count<fus1_count
			fusion_score = (fus_1/fus1_count);
		end
	else
		avg0 = (fus_0/fus0_count);
        avg1 = (fus_1/fus1_count);
        if(abs(avg0) >= abs(1-avg1))
            fusion_score = avg1;
        else
            fusion_score = avg0;
        end
    end	
    fusion_score(isnan(fusion_score))=0.0;
end

