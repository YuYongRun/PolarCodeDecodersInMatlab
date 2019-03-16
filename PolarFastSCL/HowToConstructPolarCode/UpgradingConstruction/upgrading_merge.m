function W = upgrading_merge(W, miu)
N = size(W, 2);%N is not a constant if merge is needed
if N <= miu
    return
else
%         sum_before_merge = 0;
%         for i = 1 : N/2
%           sum_before_merge = sum_before_merge + norm(W(:, i) - W(end:-1:1, N - i + 1));
%         end       
%         sum_before_merge
%         
%         if sum_before_merge > 0.01
%             sum(W(1, :))
%              sum(W(2, :))
%              W
%         end
% 
%         if sum_before_merge ~= 0
%             sum_before_merge
%             W
%             sum(W(1, :))
%             sum(W(2, :))
%             LLR = log(W(1,:)) - log(W(2,:))
%             [~, orderd] = sort(LLR, 'descend')
%         end
    
    epsilon = 1e-3;
    while(N > miu)

        W_first_half = W(:, 1 : N/2);
        LR = W_first_half(1, :)./W_first_half(2, :);
        numerical_warning = 0;
        
        for i = 1 : N/2 - 1
            ratio = LR(i)/LR(i + 1);
            if ratio < 1 + epsilon
                numerical_warning = 1;
                break;
            end
        end
        
        if numerical_warning == 1

            min_deltaI = realmax;
            min_index = 0;
            for i = 1 : N/2 - 1
                a2 = W(1, i);
                b2 = W(2, i);
                a1 = W(1,i + 1);
                b1 = W(2, i + 1);
                deltaI = delta_capacity_lemma9(a1, a2, b1, b2);
                if deltaI < min_deltaI %find minimum delta I
                    min_deltaI = deltaI;
                    min_index = i;
                end
            end

            if min_index == 0
                for k = 1 : N/2
                    if sum(W(:, k)) < 1e-20
                        min_index = k;
                        W(:, min_index) = [];
                        W(:, N - min_index) = [];
                        N = size(W, 2);
                        break;
                    end
                end
                continue;
            end

            a2 = W(1, min_index);
            b2 = W(2, min_index);
            a1 = W(1, min_index + 1);
            b1 = W(2, min_index + 1);

           

            
            if a2/b2 < inf
                lambda2 = a2/b2;
                alpha2 = lambda2 * (a1 + b1)/(lambda2 + 1);
                beta2 = (a1 + b1)/(lambda2 + 1);
            else
                alpha2 = a1 + b1;
                beta2 = 0;
            end

            W(1, min_index) =  a2 + alpha2;
            W(2, min_index) =  b2 + beta2;
            W(1, N - min_index + 1) =  b2 + beta2;
            W(2, N - min_index + 1) =  a2 + alpha2;
            
            W(:, min_index + 1) = [];
            W(:, N - min_index - 1) = [];
            N = size(W, 2);
            
        else

            min_deltaI = realmax;
            min_index = 0;

            for i = 1 : N/2 - 2
                a3 = W(1, i);
                b3 = W(2, i);
                a2 = W(1,i + 1);
                b2 = W(2, i + 1);
                a1 = W(1,i + 2);
                b1 = W(2, i + 2);
                
                deltaI = delta_capacity_lemma11(a1, a2, a3, b1, b2, b3);

                if deltaI < min_deltaI %find minimum delta I
                    min_deltaI = deltaI;
                    min_index = i;
                end
            end

            if min_index == 0
                for k = 1 : N/2
                    if sum(W(:, k)) < 1e-20
                        min_index = k;
                        W(:, min_index) = [];
                        W(:, N - min_index) = [];
                        N = size(W, 2);
                        break;
                    end    
                end
                continue;
            end
            
            a3 = W(1, min_index);
            b3 = W(2, min_index);
            a2 = W(1, min_index + 1);
            b2 = W(2, min_index + 1);
            a1 = W(1, min_index + 2);
            b1 = W(2, min_index + 2);

            lambda1 = a1/b1;
            if a3/b3 < inf
                lambda3 = a3/b3;
                alpha1 = lambda1 * (lambda3 * b2 - a2) / (lambda3 - lambda1);
                beta1 = (lambda3 * b2 - a2) / (lambda3 - lambda1);
                alpha3 = lambda3 * (a2 - lambda1 * b2) / (lambda3 - lambda1);
                beta3 = (a2 - lambda1 * b2) / (lambda3 - lambda1);
            else
                alpha1 = lambda1 * b2;
                beta1 = b2;
                alpha3 = a2 - lambda1 * b2;
                beta3 = 0;
            end
            
            W(1, min_index) =  a3 + alpha3;
            W(2, min_index) =  b3 + beta3;
            
            W(1, min_index + 1) =  a1 + alpha1;
            W(2, min_index + 1) =  b1 + beta1;
            
            W(1, N - min_index + 1) =  b3 + beta3;
            W(2, N - min_index + 1) =  a3 + alpha3;
            
            W(1, N - min_index) =  b1 + beta1;
            W(2, N - min_index) =  a1 + alpha1;
            
            W(:, min_index + 2) = [];
            W(:, N - min_index - 2) = [];
            N = size(W, 2);

%             if N == miu
%                 W
%             end
        end
    end
    
    
    
%         sum_after_merge = 0;
%         for i = 1 : N/2
%             sum_after_merge = sum_after_merge + norm(W(:, i) - W(end:-1:1, N - i + 1));
%         end
%         sum_after_merge
% W
end
end