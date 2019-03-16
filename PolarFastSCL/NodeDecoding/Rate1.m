function [PM, activepath, candidate_codeword, lazy_copy] = Rate1(M, LLR_array, activepath, PM, L, lazy_copy)
candidate_codeword = zeros(M, L);
llr_ordered = zeros(M, L);
sub_lazy_copy = 1 : L;%lazy_copy used in this function.
for l_index = 1 : L
    if activepath(l_index) == 0
        continue;
    end
    %sort length-Nv LLR in its absolute value.
    [~, llr_ordered(:, l_index)] = sort(abs(LLR_array(:, l_index)));
    candidate_codeword(:, l_index) = LLR_array(:, l_index) < 0;%ML codeword loaded
end
for i_split = 1 : min(M, L - 1)%number of splits in codeword sense
    PM_rate_1 = realmax * ones(2, L);
    compare_rate_1 = zeros(2, L);
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue;
        end
        PM_rate_1(1, l_index) = PM(l_index);
        %the first row remains the same.
        PM_rate_1(2, l_index) = PM(l_index) + abs(LLR_array(llr_ordered(i_split, sub_lazy_copy(l_index)), sub_lazy_copy(l_index)));
        %the 2nd row is penalized.
    end
    num_surviving_path = min(L, 2 * sum(activepath));
    PM_sorted = sort(PM_rate_1(:));
    PM_cv = PM_sorted(num_surviving_path);
    cnt = 0;
    for j = 1 : L
        for i = 1 : size(PM_rate_1, 1)  %****CAUTION!!!*****
            if cnt == num_surviving_path
                break;
            end
            if PM_rate_1(i, j) <= PM_cv
                compare_rate_1(i, j) = 1;
                cnt = cnt + 1;
            end
        end
    end
    kill_index = zeros(L, 1);
    kill_cnt = 0;
    for l_index = 1 : L
        if sum(compare_rate_1(:, l_index)) == 0
            activepath(l_index) = 0;
            kill_cnt = kill_cnt + 1;%push stack
            kill_index(kill_cnt) = l_index;
        end
    end
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue
        end
        if sum(compare_rate_1(:, l_index)) == 2
            new_index = kill_index(kill_cnt);
            kill_cnt = kill_cnt - 1;
            activepath(new_index) = 1;
            sub_lazy_copy(new_index) = sub_lazy_copy(l_index);
            codeword_tmp = candidate_codeword(:, l_index);
            codeword_tmp(llr_ordered(i_split, sub_lazy_copy(l_index))) = mod(codeword_tmp(llr_ordered(i_split, sub_lazy_copy(l_index))) + 1, 2);
            candidate_codeword(:, new_index) = codeword_tmp;
            PM(new_index) = PM(l_index) + abs(LLR_array(llr_ordered(i_split, sub_lazy_copy(l_index)), sub_lazy_copy(l_index)));%PM updated
        end
    end
end
for l_index = 1 : L
    if activepath(l_index) == 0
        continue
    end
    lazy_copy(:, l_index) = lazy_copy(:, sub_lazy_copy(l_index));
end
end