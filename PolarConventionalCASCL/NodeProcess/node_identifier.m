function node_identifier(f, z)
N = length(f);
global code_structure cnt_structure
if N >= 8
    if (f(end - 4) == 0) && all(f(end - 2 : end) == 0) && all(f(1 : end - 5) == 1) && (f(end - 3) == 1)
        code_structure(cnt_structure, 1) = z(1);
        code_structure(cnt_structure, 2) = N;
        code_structure(cnt_structure, 3) = 8;
        cnt_structure = cnt_structure + 1;
        %disp('tppe V')
    else
        if all(f(1 : end - 2) == 1) && all(f(end - 1 : end) == 0)
            code_structure(cnt_structure, 1) = z(1);
            code_structure(cnt_structure, 2) = N;
            code_structure(cnt_structure, 3) = 4;
            cnt_structure = cnt_structure + 1;
            %disp('tppe I')
        else
            if all(f(1 : end - 3) == 1) && all(f(end - 2 : end) == 0)
                code_structure(cnt_structure, 1) = z(1);
                code_structure(cnt_structure, 2) = N;
                code_structure(cnt_structure, 3) = 5;
                cnt_structure = cnt_structure + 1;
                %disp('tppe II')
            else
                if all(f(1 : 2) == 1) && all(f(3 : end) == 0)
                    code_structure(cnt_structure, 1) = z(1);
                    code_structure(cnt_structure, 2) = N;
                    code_structure(cnt_structure, 3) = 6;
                    cnt_structure = cnt_structure + 1;
                    %disp('tppe III')
                else
                    if all(f(1 : 3) == 1) && all(f(4 : end) == 0)
                        code_structure(cnt_structure, 1) = z(1);
                        code_structure(cnt_structure, 2) = N;
                        code_structure(cnt_structure, 3) = 7;
                        cnt_structure = cnt_structure + 1;
                        %disp('tppe IV')
                    else
                        if all(f(1 : end - 1) == 1) && (f(end) == 0)
                            code_structure(cnt_structure, 1) = z(1);
                            code_structure(cnt_structure, 2) = N;
                            code_structure(cnt_structure, 3) = 2;
                            cnt_structure = cnt_structure + 1;
                            %disp('REP')
                        else
                            if (f(1) == 1) && all(f(2 : end) == 0)
                                code_structure(cnt_structure, 1) = z(1);
                                code_structure(cnt_structure, 2) = N;
                                code_structure(cnt_structure, 3) = 3;
                                cnt_structure = cnt_structure + 1;
                                %disp('SPC')
                            else
                                if all(f == 0)%rate 1 node
                                    code_structure(cnt_structure, 1) = z(1);
                                    code_structure(cnt_structure, 2) = N;
                                    code_structure(cnt_structure, 3) = 1;
                                    cnt_structure = cnt_structure + 1;
                                    %disp('RATE 1')
                                else
                                    if all(f == 1)%rate 0 node
                                        code_structure(cnt_structure, 1) = z(1);
                                        code_structure(cnt_structure, 2) = N;
                                        code_structure(cnt_structure, 3) = -1;
                                        cnt_structure = cnt_structure + 1;
                                        %disp('RATE 0')
                                    else
                                        node_identifier(f(1:N/2), z(1:N/2));
                                        node_identifier(f(N/2+1:end), z(N/2+1:end));
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
else
    if N >= 4%New Type Nodes I~IV and REP and SPC Nodes
        if all(f(1 : end - 2) == 1) && all(f(end - 1 : end) == 0)
            code_structure(cnt_structure, 1) = z(1);
            code_structure(cnt_structure, 2) = N;
            code_structure(cnt_structure, 3) = 4;
            cnt_structure = cnt_structure + 1;
            %disp('tppe I')
        else
            if all(f(1 : end - 3) == 1) && all(f(end - 2 : end) == 0)
                code_structure(cnt_structure, 1) = z(1);
                code_structure(cnt_structure, 2) = N;
                code_structure(cnt_structure, 3) = 5;
                cnt_structure = cnt_structure + 1;
                %disp('tppe II')
            else
                if all(f(1 : 2) == 1) && all(f(3 : end) == 0)
                    code_structure(cnt_structure, 1) = z(1);
                    code_structure(cnt_structure, 2) = N;
                    code_structure(cnt_structure, 3) = 6;
                    cnt_structure = cnt_structure + 1;
                    %disp('tppe III')
                else
                    if all(f(1 : 3) == 1) && all(f(4 : end) == 0)
                        code_structure(cnt_structure, 1) = z(1);
                        code_structure(cnt_structure, 2) = N;
                        code_structure(cnt_structure, 3) = 7;
                        cnt_structure = cnt_structure + 1;
                        %disp('tppe IV')
                    else
                        if all(f(1 : end - 1) == 1) && (f(end) == 0)
                            code_structure(cnt_structure, 1) = z(1);
                            code_structure(cnt_structure, 2) = N;
                            code_structure(cnt_structure, 3) = 2;
                            cnt_structure = cnt_structure + 1;
                            %disp('REP')
                        else
                            if (f(1) == 1) && all(f(2 : end) == 0)
                                code_structure(cnt_structure, 1) = z(1);
                                code_structure(cnt_structure, 2) = N;
                                code_structure(cnt_structure, 3) = 3;
                                cnt_structure = cnt_structure + 1;
                                %disp('SPC')
                            else
                                if all(f == 0)%rate 1 node
                                    code_structure(cnt_structure, 1) = z(1);
                                    code_structure(cnt_structure, 2) = N;
                                    code_structure(cnt_structure, 3) = 1;
                                    cnt_structure = cnt_structure + 1;
                                    %disp('RATE 1')
                                else
                                    if all(f == 1)%rate 0 node
                                        code_structure(cnt_structure, 1) = z(1);
                                        code_structure(cnt_structure, 2) = N;
                                        code_structure(cnt_structure, 3) = -1;
                                        cnt_structure = cnt_structure + 1;
                                        %disp('RATE 0')
                                    else
                                        node_identifier(f(1:N/2), z(1:N/2));
                                        node_identifier(f(N/2+1:end), z(N/2+1:end));
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        if N == 1
            return
        else
            % N = 2 或者 1 的情况就不再单独讨论 已经非常简单了 没必要再化简了
            node_identifier(f(1:N/2), z(1:N/2));
            node_identifier(f(N/2+1:end), z(N/2+1:end));
        end
    end
end



