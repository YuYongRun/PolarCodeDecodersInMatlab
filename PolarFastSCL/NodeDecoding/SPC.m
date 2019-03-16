function [PM, activepath, candidate_codeword, lazy_copy] = SPC(index_vec, LLR_array, activepath, PM, L, lazy_copy)
M = length(index_vec);
candidate_codeword = zeros(M, L);
llr_ordered = zeros(M, L);
parity_check_track = zeros(L, 1); %caution, default value must be 0s.
sub_lazy_copy = 1 : L;%Lazy copy used in this function
for l_index = 1 : L
    if activepath(l_index) == 0
        continue;
    end
    abs_LLR = abs(LLR_array(:, l_index));
    [~, llr_ordered(:, l_index)] = sort(abs_LLR);%Ascending sorting
    candidate_codeword(:, l_index) = LLR_array(:, l_index) < 0;%quasi-ML codeword
    if mod(sum(candidate_codeword(:, l_index)), 2) == 1 %Do not satisfy parity check
        candidate_codeword(llr_ordered(1, l_index), l_index) = mod(candidate_codeword(llr_ordered(1, l_index), l_index) + 1, 2);
        %Least reliable Bit flip
        parity_check_track(l_index) = 1;%initialize parity check
        PM(l_index) = PM(l_index) + abs_LLR(llr_ordered(1, l_index));
        %PM changes accordingly.
    end
end
for t = 2 : min(M, L)
    PM_spc = realmax * ones(2, L);
    compare_spc = zeros(2, L);
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue;
        end
        LLR = LLR_array(:, sub_lazy_copy(l_index));
        PM_spc(1, l_index) = PM(l_index); %remain the same as original path
        PM_spc(2, l_index) = PM(l_index) + abs(LLR(llr_ordered(t, sub_lazy_copy(l_index)))) + (1 - 2 * parity_check_track(l_index)) * abs(LLR(llr_ordered(1, sub_lazy_copy(l_index))));
    end
    num_surviving_path = min(L, 2 * sum(activepath));
    PM_sorted = sort(PM_spc(:));
    PM_cv = PM_sorted(num_surviving_path);
    cnt = 0;
    for j = 1 : L
        for i = 1 : size(PM_spc, 1)  %****CAUTION!!!*****
            if cnt == num_surviving_path
                break;
            end
            if PM_spc(i, j) <= PM_cv
                compare_spc(i, j) = 1;
                cnt = cnt + 1;
            end
        end
    end
    kill_index = zeros(L, 1);
    kill_cnt = 0;
    for i = 1 : L
        if all(compare_spc(:, i) == 0)
            activepath(i) = 0;
            kill_cnt = kill_cnt + 1;%push stack
            kill_index(kill_cnt) = i;
        end
    end
    for l_index = 1 : L
        if activepath(l_index) == 0
            continue
        end
        path_state = sum(compare_spc(:, l_index));
        switch path_state
            case 2
                new_index = kill_index(kill_cnt);
                kill_cnt = kill_cnt - 1;
                activepath(new_index) = 1;
                sub_lazy_copy(new_index) = sub_lazy_copy(l_index);
                %generate a new sub-codeword        
                codeword_tmp = candidate_codeword(:, l_index);
                codeword_tmp(llr_ordered(t, sub_lazy_copy(l_index))) = mod(codeword_tmp(llr_ordered(t, sub_lazy_copy(l_index))) + 1, 2);%t-th index (after llr sorting)
                codeword_tmp(llr_ordered(1, sub_lazy_copy((l_index)))) = mod(codeword_tmp(llr_ordered(1, sub_lazy_copy(l_index))) + 1, 2);%1-st index always
                candidate_codeword(:, new_index) = codeword_tmp;
                parity_check_track(new_index) = mod(parity_check_track(l_index) + 1, 2);
                %When you split path, the parity check sign should be fliped accordingly.
                PM(new_index) = PM_spc(2, l_index);%PM updated
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