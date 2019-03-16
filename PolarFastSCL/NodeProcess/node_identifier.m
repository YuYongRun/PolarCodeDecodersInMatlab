function node_identifier(f, z)
N = length(f);
global code_structure cnt_structure
if all(f(1 : end - 1) == 1) && (f(end) == 0)%REP
    code_structure(cnt_structure, 1) = z(1);
    code_structure(cnt_structure, 2) = N;
    code_structure(cnt_structure, 3) = 2;
    cnt_structure = cnt_structure + 1;
else
    if (f(1) == 1) && all(f(2 : end) == 0)%SPC
        code_structure(cnt_structure, 1) = z(1);
        code_structure(cnt_structure, 2) = N;
        code_structure(cnt_structure, 3) = 3;
        cnt_structure = cnt_structure + 1;
    else
        if all(f == 0)%R1
            code_structure(cnt_structure, 1) = z(1);
            code_structure(cnt_structure, 2) = N;
            code_structure(cnt_structure, 3) = 1;
            cnt_structure = cnt_structure + 1;
        else
            if all(f == 1)%R0
                code_structure(cnt_structure, 1) = z(1);
                code_structure(cnt_structure, 2) = N;
                code_structure(cnt_structure, 3) = -1;
                cnt_structure = cnt_structure + 1;
            else
                node_identifier(f(1:N/2), z(1:N/2));
                node_identifier(f(N/2+1:end), z(N/2+1:end));
            end
        end
    end
end
end