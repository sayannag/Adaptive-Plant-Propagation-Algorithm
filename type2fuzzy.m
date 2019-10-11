%% FUNCTION FOR TYPE 2 FUZZY ENTROPY
function [type2entropy] = type2fuzzy(population, norm_hist, gray_levels, alpha, thresh)
    numEle = thresh; % size(population{1,1});
    numEle = (numEle); % excluding the 0th and the (n+1)th terms
    a = population{1,1};
    c = population{1,2};
    mu = zeros(numEle+1, gray_levels);
%     mulow = zeros(numEle+1, gray_levels);
%     muhigh = zeros(numEle+1, gray_levels);
   % if (numEle <= 4)
        for i = 0:gray_levels-1
            if (i <= a(1))
                mu(1,i+1) = 1;
            elseif (i <= c(1) && i > a(1))
                mu(1,i+1) = (i - c(1))/(a(1) - c(1));
            elseif(i > c(1))
                mu(1,i+1) = 0;
            end
            for k = 2:numEle
                if (i <= a(k-1))
                    mu(k,i+1) = 0;
                elseif (i <= c(k-1) && i > a(k-1))
                    mu(k,i+1) = (i - a(k-1))/(c(k-1) - a(k-1));
                elseif(i > c(k-1) && i <= a(k))
                    mu(k,i+1) = 1;
                elseif(i > a(k) && i <= c(k))
                    mu(k,i+1) = (i - c(k))/(a(k) - c(k));
                elseif(i > c(k))
                    mu(k,i+1) = 0;
                end
            end
            if (i <= a(numEle))
                mu(numEle+1,i+1) = 0;
            elseif (i <= c(numEle) && i > a(numEle))
                mu(numEle+1,i+1) = (i - c(numEle))/(c(numEle) - a(numEle));
            elseif(i > c(numEle))
                mu(numEle+1,i+1) = 1;
            end
        end
        mu = abs(mu);
        mulow = mu.^(alpha);
        muhigh = mu.^(1/alpha);
%         mulow(1,:)
%         muhigh(1,:)
        H_new = 0;
        for k = 1:numEle+1
            P(k) = 0;
            for i = 1:gray_levels
                P(k) = P(k) + norm_hist(i)*(muhigh(k,i) - mulow(k,i));
            end
            H(k) = 0;
            for i = 1:gray_levels
                if ((muhigh(k,i) - mulow(k,i))~=0 && norm_hist(i)~=0)
%                     pro1 = (muhigh(k,i) - mulow(k,i))/(P(k)) % ((norm_hist(i)*(muhigh(k,i) - mulow(k,i))/(P(k))))
%                     loge = (log(norm_hist(i)*(muhigh(k,i) - mulow(k,i))/(P(k))))
%                     pro = pro1*loge
                    H(k) = H(k) - ((norm_hist(i)*(muhigh(k,i) - mulow(k,i))/(P(k)))*(log(norm_hist(i)*(muhigh(k,i) - mulow(k,i))/(P(k)))));
                else
                    H(k) = H(k) - 0;
                end
            end
            H_new = H_new + H(k);
        end
        %P(1)
        %sh = H
        % kh=P
        % numEle+1
        type2entropy = (H_new);
   % end
end