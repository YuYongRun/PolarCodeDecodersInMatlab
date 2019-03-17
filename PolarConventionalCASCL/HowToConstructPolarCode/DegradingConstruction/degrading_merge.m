function W = degrading_merge(W, miu)
N = size(W, 2);%N is not a constant if merge is needed
if N <= miu
    return
else  
%     sum_before_merge = 0; 
%     for i = 1 : N/2
%       sum_before_merge = sum_before_merge + norm(W(:, i) - W(end:-1:1, N - i + 1));
%     end
%      sum_before_merge
%     if sum_before_merge > 0.01
%         sum(W(1,:));
%         sum(W(2, :))
%     end
        
    
%     if sum_before_merge ~= 0
%         sum_before_merge
%         W
%         sum(W(1, :))
%         sum(W(2, :))
%         LLR = log(W(1,:)) - log(W(2,:))
%         [~, orderd] = sort(LLR, 'descend')
%     end
    while(N > miu)
        min_deltaI = realmax;
        min_index = 0;
        for i = 1 : N/2 - 1
            a1 = W(1, i);
            b1 = W(2, i);
            a2 = W(1,i + 1);
            b2 = W(2, i + 1);
            deltaI = capacity(a1, b1) + capacity(a2, b2) - capacity(a1 + a2, b1 + b2);

            if deltaI < min_deltaI %find minimum delta I
                min_deltaI = deltaI;
                min_index = i;
            end
        end
        
%         indicator = 0;
%         
%         for k = 1 : N/2
%             if sum(W(:, k)) < 1e-20
%                 indicator = 1;
%                 W(:, k) = [];
%                 W(:, N -  k) = [];
%                 N = size(W, 2);
%                 break;
%             end
%         end
%         
%         if indicator == 1
%             continue
%         end

        W(1, min_index) =  W(1, min_index) + W(1, min_index + 1);
        W(2, min_index) =  W(2, min_index) + W(2, min_index + 1);
        W(1, N - min_index + 1) =  W(1, N - min_index + 1) + W(1, N - min_index);
        W(2, N - min_index + 1) =  W(2, N - min_index + 1) + W(2, N - min_index);
        W(:, min_index + 1) = [];
        W(:, N - min_index - 1) = [];
        N = size(W, 2);
    end
%     sum_after_merge = 0;
%     for i = 1 : N/2
%         sum_after_merge = sum_after_merge + norm(W(:, i) - W(end:-1:1, N - i + 1));
%     end
%     sum_after_merge
end
end