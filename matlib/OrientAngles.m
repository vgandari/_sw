function [th1 th2] = OrientAngles(type,C)
%finds two nutation, four precession

if type == 'B131'
    
th2_1 = acosd(C(1,1));
th2_2 = -th2_1;

%chooses correct nut
if th2_1 <= 180 & th2_1 >= 0
    th2 = th2_1;
else
    th2 = th2_2;
end

th1_1 = asind(C(3,1)/sind(th2));
th1_2 = 180 - th1_1;
th1_3 = acosd(C(2,1)/sind(th2));
th1_4 = -th1_3;

end

%makes angles similar
[th1_1 th1_2 th1_3 th1_4] = PosAngles(real(th1_1),real(th1_2),real(th1_3),real(th1_4));

%chooses correct prec
if (th1_1 == 0 & th1_3 == 0) | (th1_1 == 0 & th1_4 == 0)
th1 = th1_1;
elseif (th1_2 == 0 & th1_3 == 0) | (th1_2 == 0 & th1_4 == 0)
th1 = th1_2;
elseif (th1_1 < 1e-4 & th1_3 < 1e-4) | (th1_1 < 1e-4 & th1_4 < 1e-4)
th1 = th1_1;
elseif (th1_2 < 1e-4 & th1_3 < 1e-4) | (th1_2 < 1e-4 & th1_4 < 1e-4)
th1 = th1_2;
elseif abs(th1_1-th1_3)/th1_1<0.0001
th1 = th1_1;
elseif abs(th1_1-th1_4)/th1_1<0.0001
th1 = th1_1;
elseif abs(th1_2-th1_3)/th1_2<0.0001
th1 = th1_2;
elseif abs(th1_2-th1_4)/th1_2<0.0001
th1 = th1_2;
else
error('th1 not found')
end