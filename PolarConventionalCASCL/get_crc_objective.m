function [gen, det, g] = get_crc_objective(crc_length)
switch crc_length
    case 4
        gen = crc.generator('Polynomial',[1 0 0 1 1],'InitialState',zeros(1, 4),'FinalXOR',zeros(1, 4));
        det = crc.detector('Polynomial',[1 0 0 1 1],'InitialState',zeros(1, 4),'FinalXOR',zeros(1, 4));
        g = [1 0 0 1 1];
    case 6
        gen = crc.generator('Polynomial',[1 0 0 0 0 1 1],'InitialState',zeros(1, 6),'FinalXOR',zeros(1, 6));
        det = crc.detector('Polynomial',[1 0 0 0 0 1 1],'InitialState',zeros(1, 6),'FinalXOR',zeros(1, 6));
        g = [1 0 0 0 0 1 1];
    case 8
        gen = crc.generator('Polynomial','0xA6','InitialState','0x00','FinalXOR','0x00');
        det = crc.detector('Polynomial','0xA6','InitialState','0x00','FinalXOR','0x00');
%         g = [1 0 1 0 0 1 1 0 1];
g = [1 1 1 1 1 1 0 0 1];
    case 10
        gen = crc.generator('Polynomial',[1 1 0 0 1 0 0 1 1 1 1],'InitialState',zeros(1, 10),'FinalXOR',zeros(1, 10));
        det = crc.detector('Polynomial',[1 1 0 0 1 0 0 1 1 1 1],'InitialState',zeros(1, 10),'FinalXOR',zeros(1, 10));
        g = [1 1 0 0 1 0 0 1 1 1 1];
    case 12
        gen = crc.generator('Polynomial',[1 1 0 0 0 0 0 0 0 1 1 0 1],'InitialState',zeros(1, 12),'FinalXOR',zeros(1, 12));
        det = crc.detector('Polynomial',[1 1 0 0 0 0 0 0 0 1 1 0 1],'InitialState',zeros(1, 12),'FinalXOR',zeros(1, 12));
        g = [1 1 0 0 0 0 0 0 0 1 1 0 1];
    case 16
        gen = crc.generator('Polynomial',[1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1],'InitialState',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0],'FinalXOR',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
        det = crc.detector('Polynomial',[1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1],'InitialState',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0],'FinalXOR',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
        g = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1];
    case 24
        gen = crc.generator('Polynomial',[1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1],'InitialState',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0],...
            'FinalXOR',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
        det = crc.detector('Polynomial',[1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1],'InitialState',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0],...
            'FinalXOR',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);
        g = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1];
    otherwise
        disp('Unsupported CRC length. Program terminates')
end