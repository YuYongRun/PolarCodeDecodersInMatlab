function Pe = bit_channel_upgrading_procedure(W, z, miu)
N = length(z);
if N == 1
    Pe = 0.5 * sum(min(W));
    disp(['Bit index = ' num2str(z) '  ML detection Bit Error rate = ' num2str(Pe)])
else
    W_up = get_W_up(W);
    W_up = LR_sort(W_up);
    W_up_after_erasure_symbol_merge = erasure_symbol_merge(W_up);
    W_up_after_merge = upgrading_merge(W_up_after_erasure_symbol_merge, miu);
    Pe1 = bit_channel_upgrading_procedure(W_up_after_merge, z(1 : N/2), miu);

    W_down= get_W_down(W);
    W_down = LR_sort(W_down);
    W_down_after_erasure_symbol_merge = erasure_symbol_merge(W_down);
    W_down_after_merge = upgrading_merge(W_down_after_erasure_symbol_merge, miu);
    Pe2 = bit_channel_upgrading_procedure(W_down_after_merge, z(N/2 + 1 : end), miu);

    Pe = [Pe1 Pe2];
end
end

% function Pe = bit_channel_upgrading_procedure(W, z, miu)
% N = length(z);
% m = round(log2(N));
% Pe = zeros(N, 1);
% for k = N - 7 : N - 1
%     char_bin_expansion = dec2bin(k, m);
%     W_tmp = W;
%     for i_level = 1 : m
%         if char_bin_expansion(i_level) == '0'
%             W_up = get_W_up(W_tmp);
%             W_up = LR_sort(W_up);
%             W_up_after_erasure_symbol_merge = erasure_symbol_merge(W_up);
%             W_tmp = upgrading_merge(W_up_after_erasure_symbol_merge, miu);
%         else
%             W_down = get_W_down(W_tmp);
%             W_down = LR_sort(W_down);
%             W_down_after_erasure_symbol_merge = erasure_symbol_merge(W_down);
%             W_tmp = upgrading_merge(W_down_after_erasure_symbol_merge, miu);
%         end
%     end
%     Pe(k + 1) = 0.5 * sum(min(W_tmp));
%     disp(['Bit index = ' num2str(k + 1) ' ML detection Bit Error rate = ' num2str(Pe(k + 1))])
% end
% end




