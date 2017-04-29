function [th_1 th_2 th_3 th_4] = PosAngles(th_1,th_2,th_3,th_4)

if th_1 < 0
    th_1 = th_1 + 360;
end
if th_2 < 0
    th_2 = th_2 + 360;
end
if th_3 < 0
    th_3 = th_3 + 360;
end
if th_4 < 0
    th_4 = th_4 + 360;
end