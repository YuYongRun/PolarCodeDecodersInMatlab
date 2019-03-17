function x = typeV(alpha)
N = length(alpha)/8;
sum_alpha = [sum(alpha(1 : end/8)) sum(alpha(end/8 + 1 : end/4)) sum(alpha(end/4 + 1 : end*3/8)) sum(alpha(end*3/8 + 1 : end/2))...
             sum(alpha(end/2 + 1 : end*5/8)) sum(alpha(end*5/8 + 1 : end*3/4)) sum(alpha(end*3/4 + 1 : end*7/8)) sum(alpha(end*7/8 + 1 : end))];
         
% z = 2*(atanh(tanh(sum_alpha(1)/2)*tanh(sum_alpha(2)/2)) + atanh(tanh(sum_alpha(3)/2)*tanh(sum_alpha(4)/2)) + ...
%           atanh(tanh(sum_alpha(5)/2)*tanh(sum_alpha(6)/2)) + atanh(tanh(sum_alpha(7)/2)*tanh(sum_alpha(8)/2))) < 0;
z = sign(sum_alpha(1))*sign(sum_alpha(2))*min(abs(sum_alpha(1)), abs(sum_alpha(2))) + ...
    sign(sum_alpha(3))*sign(sum_alpha(4))*min(abs(sum_alpha(3)), abs(sum_alpha(4))) +...
    sign(sum_alpha(5))*sign(sum_alpha(6))*min(abs(sum_alpha(5)), abs(sum_alpha(6))) +...
    sign(sum_alpha(7))*sign(sum_alpha(8))*min(abs(sum_alpha(7)), abs(sum_alpha(8)));
z = z < 0;
x = zeros(8, 1);

x(2) = (1 - 2*z)*sum_alpha(1) + sum_alpha(2) < 0;
x(4) = (1 - 2*z)*sum_alpha(3) + sum_alpha(4) < 0;
x(6) = (1 - 2*z)*sum_alpha(5) + sum_alpha(6) < 0;
x(8) = (1 - 2*z)*sum_alpha(7) + sum_alpha(8) < 0;

if x(2) ~= mod(x(4) + x(6) + x(8), 2)
    abs_alpha_tmp = [abs((1 - 2*z)*sum_alpha(1) + sum_alpha(2)) abs((1 - 2*z)*sum_alpha(3) + sum_alpha(4)) ...
        abs((1 - 2*z)*sum_alpha(5) + sum_alpha(6)) abs((1 - 2*z)*sum_alpha(7) + sum_alpha(8))];
    index = find(abs_alpha_tmp == min(abs_alpha_tmp));
    switch index
        case 1
            x(2) = mod(x(2) + 1, 2);
        case 2
            x(4) = mod(x(4) + 1, 2);
        case 3
            x(6) = mod(x(6) + 1, 2);
        case 4
            x(8) = mod(x(8) + 1, 2);
    end
end
x(1) = mod(x(2) + z, 2);
x(3) = mod(x(4) + z, 2);
x(5) = mod(x(6) + z, 2);
x(7) = mod(x(8) + z, 2);
x = [x(1) * ones(N, 1); x(2) * ones(N, 1); x(3) * ones(N, 1); x(4) * ones(N, 1); x(5) * ones(N, 1); x(6) * ones(N, 1); x(7) * ones(N, 1); x(8) * ones(N, 1)];
end

% function x = typeV(alpha)
% N = length(alpha)/8;
% sum_alpha = [sum(alpha(1 : end/8)) sum(alpha(end/8 + 1 : end/4)) sum(alpha(end/4 + 1 : end*3/8)) sum(alpha(end*3/8 + 1 : end/2))...
%              sum(alpha(end/2 + 1 : end*5/8)) sum(alpha(end*5/8 + 1 : end*3/4)) sum(alpha(end*3/4 + 1 : end*7/8)) sum(alpha(end*7/8 + 1 : end))];
%          
% % z = 2*(atanh(tanh(sum_alpha(1)/2)*tanh(sum_alpha(2)/2)) + atanh(tanh(sum_alpha(3)/2)*tanh(sum_alpha(4)/2)) + ...
% %           atanh(tanh(sum_alpha(5)/2)*tanh(sum_alpha(6)/2)) + atanh(tanh(sum_alpha(7)/2)*tanh(sum_alpha(8)/2))) < 0;
% z = sign(sum_alpha(1))*sign(sum_alpha(2))*min(abs(sum_alpha(1)), abs(sum_alpha(2))) + ...
%     sign(sum_alpha(3))*sign(sum_alpha(4))*min(abs(sum_alpha(3)), abs(sum_alpha(4))) +...
%     sign(sum_alpha(5))*sign(sum_alpha(6))*min(abs(sum_alpha(5)), abs(sum_alpha(6))) +...
%     sign(sum_alpha(7))*sign(sum_alpha(8))*min(abs(sum_alpha(7)), abs(sum_alpha(8)));
% z = z < 0;
% x = zeros(8, 1);
% 
% x(2) = sum_alpha(2) < 0;
% x(4) = sum_alpha(4) < 0;
% x(6) = sum_alpha(6) < 0;
% x(8) = sum_alpha(8) < 0;
% 
% if x(2) ~= mod(x(4) + x(6) + x(8), 2)
%     abs_alpha_tmp = abs([sum_alpha(2) sum_alpha(4) sum_alpha(6) sum_alpha(8)]);
%     index = find(abs_alpha_tmp == min(abs_alpha_tmp));
%     switch index
%         case 1
%             x(2) = mod(x(2) + 1, 2);
%         case 2
%             x(4) = mod(x(4) + 1, 2);
%         case 3
%             x(6) = mod(x(6) + 1, 2);
%         case 4
%             x(8) = mod(x(8) + 1, 2);
%     end
% end
% x(1) = mod(x(2) + z, 2);
% x(3) = mod(x(4) + z, 2);
% x(5) = mod(x(6) + z, 2);
% x(7) = mod(x(8) + z, 2);
% x = [x(1) * ones(N, 1); x(2) * ones(N, 1); x(3) * ones(N, 1); x(4) * ones(N, 1); x(5) * ones(N, 1); x(6) * ones(N, 1); x(7) * ones(N, 1); x(8) * ones(N, 1)];
% end
       
