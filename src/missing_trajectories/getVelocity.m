function [velocity] = getVelocity(dframe, point1, point2, cameraFlag)
%GETVELOCITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

if dframe > 0 
    if cameraFlag == false
        velocity = (point2 - point1) .* 1000 ./ dframe;
    elseif  point1(1) == point2(1)
        velocity = (point2(2: 3) - point1(2: 3)) .* 1000 ./ dframe;
    else
        velocity = [0, 0];
    end
else
    velocity = [0, 0];
end

end

