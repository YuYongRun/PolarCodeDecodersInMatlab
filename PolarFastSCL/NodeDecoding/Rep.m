function [PM, activepath, lazy_copy, candidate_codeword] = Rep(PM, LLR_array, activepath, L, M, lazy_copy)
num_surviving_path = min(L, 2 * sum(activepath));
PM_pair = realmax * ones(2, L);
%In rep node, one exsiting path generates two candidates
candidate_codeword = zeros(M, L);
for l_index = 1 : L
    if activepath(l_index) == 0
        continue;
    end
    Delta0 = 0;
    Delta1 = 0;
    for i_llr = 1 : M
        if LLR_array(i_llr, l_index) < 0
            Delta0 = Delta0 - LLR_array(i_llr, l_index);
        else
            Delta1 = Delta1 + LLR_array(i_llr, l_index);
        end
    end
    PM_pair(1, l_index) = PM(l_index) + Delta0;
    PM_pair(2, l_index) = PM(l_index) + Delta1;
end
PM_sort = sort(PM_pair(:));
PM_cv = PM_sort(num_surviving_path);
compare = zeros(2, L);
cnt = 0;
for j = 1 : L
    for i = 1 : 2
        if cnt == num_surviving_path
            break;
        end
        if PM_pair(i, j) <= PM_cv
            compare(i, j) = 1;
            cnt = cnt + 1;
        end
    end
end
kill_index = zeros(L, 1);
kill_cnt = 0;
for i = 1 : L
    if (compare(1, i) == 0)&&(compare(2, i) == 0)
        %indicates that this path should be killed
        activepath(i) = 0;
        kill_cnt = kill_cnt + 1;%push stack
        kill_index(kill_cnt) = i;
    end
end

for l_index = 1 : L
    if sum(compare(:, l_index)) == 0
        continue;
    end
    path_state = compare(1, l_index) * 2 + compare(2, l_index);
    switch path_state
        case 1
            candidate_codeword(:, l_index) = 1;
            PM(l_index) = PM_pair(2, l_index);
        case 2
            PM(l_index) = PM_pair(1, l_index);%initilized values are 0s, so no update here.
        case 3
            new_index = kill_index(kill_cnt);
            kill_cnt = kill_cnt - 1;
            activepath(new_index) = 1;
            lazy_copy(:, new_index) = lazy_copy(:, l_index);
            candidate_codeword(:, new_index) = 1;
            PM(l_index) = PM_pair(1, l_index);
            PM(new_index) = PM_pair(2, l_index);
    end
end
