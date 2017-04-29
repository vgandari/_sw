theta1 = 0;
theta2 = 0;
theta3 = 0;

% body-three
% 123
C = [cos(theta2)*cos(theta3) -cos(theta2)*sin(theta3) sin(theta2);
    sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1) -sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -sin(theta1)*cos(theta2);
    -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1) cos(theta1)*cos(theta2)]
% body-three
% 231
C = [cos(theta1)*cos(theta2) -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1);
    sin(theta2) cos(theta2)*cos(theta3) -cos(theta2)*sin(theta3);
    -sin(theta1)*cos(theta2) sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1) -sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% body-three
% 312
C = [-sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -sin(theta1)*cos(theta2) sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1);
    cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1) cos(theta1)*cos(theta2)  -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1);
    -cos(theta2)*sin(theta3) sin(theta2) cos(theta2)*cos(theta3)]
% body-three
% 132
C = [cos(theta2)*cos(theta3) -sin(theta2) cos(theta2)*sin(theta3);
    cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta1)*cos(theta2) cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1);
    sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1) sin(theta1)*cos(theta2) sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% body-three
% 213
C = [sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1) sin(theta1)*cos(theta2);
    cos(theta2)*sin(theta3) cos(theta2)*cos(theta3) -sin(theta2);
    cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta1)*cos(theta2)]
% body-three
% 321
C = [cos(theta1)*cos(theta2) cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1);
    sin(theta1)*cos(theta2) sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1);
    -sin(theta2) cos(theta2)*sin(theta3) cos(theta2)*cos(theta3)]

% body-two
% 121
C = [cos(theta2) sin(theta2)*sin(theta3) sin(theta2)*cos(theta3);
    sin(theta1)*sin(theta2) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -sin(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*cos(theta1);
    -cos(theta1)*sin(theta2) cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1)]
% body-two
% 131
C = [cos(theta2) -sin(theta2)*cos(theta3) sin(theta2)*sin(theta3);
    cos(theta1)*sin(theta2) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta3)*sin(theta1);
    sin(theta1)*sin(theta2) sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]

% =========================================================================
% body-two
% 212
C = [-sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta1)*sin(theta2) sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1);
    sin(theta2)*sin(theta3) cos(theta2) -sin(theta2)*cos(theta3);
    -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta1)*sin(theta2) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1)]
% body-two
% 232
C = [cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -cos(theta1)*sin(theta2) cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1);
    sin(theta2)*cos(theta3) cos(theta2) sin(theta2)*sin(theta3);
    -sin(theta1)*cos(theta2)*cos(theta3) sin(theta1)*sin(theta2) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1)]
% body-two
% 313
C = [-sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -sin(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*cos(theta1) sin(theta1)*sin(theta2);
    cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -cos(theta1)*sin(theta2);
    sin(theta2)*sin(theta3) sin(theta2)*cos(theta3) cos(theta2)]
% body-two
% 323
C = [cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta1)*sin(theta2);
    sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta1)*sin(theta2);
    -sin(theta2)*cos(theta3) sin(theta2)*sin(theta3) cos(theta2)]

% space-three
% 123
C = [cos(theta2)*cos(theta3) sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1) cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1);
    cos(theta2)*sin(theta3) sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1);
    -sin(theta2) sin(theta1)*cos(theta2) cos(theta1)*cos(theta2)]
% space-three
% 231
C = [cos(theta1)*cos(theta2) -sin(theta2) sin(theta1)*cos(theta2);
    cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta2)*cos(theta3) sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1);
    cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta2)*sin(theta3) sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% space-three
% 312
C = [sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) cos(theta1)*sin(theta2)*sin(theta3)-cos(theta3)*sin(theta1) cos(theta2)*sin(theta3);
    sin(theta1)*cos(theta2) cos(theta1)*cos(theta2) -sin(theta2);
    sin(theta1)*sin(theta2)*cos(theta3)-sin(theta3)*cos(theta1) cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) cos(theta2)*cos(theta3)]
% space-three
% 132
C = [cos(theta2)*cos(theta3) -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1);
    sin(theta2) cos(theta1)*cos(theta2) -sin(theta1)*cos(theta2);
    -cos(theta2)*sin(theta3) cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1) -sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% space-three
% 213
C = [-sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -cos(theta2)*sin(theta3) cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1);
    sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1) cos(theta2)*cos(theta3) -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1);
    -sin(theta1)*cos(theta2) sin(theta2) cos(theta1)*cos(theta2)]
% space-three
% 321
C = [cos(theta1)*cos(theta2) -sin(theta1)*cos(theta2) sin(theta2);
    cos(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*sin(theta1) -sin(theta1)*sin(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -cos(theta2)*sin(theta3);
    -cos(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*sin(theta1) sin(theta1)*sin(theta2)*cos(theta3)+sin(theta3)*cos(theta1) cos(theta2)*cos(theta3)]

% space-two
% 121
C = [cos(theta2) sin(theta1)*sin(theta2) cos(theta1)*sin(theta2);
    sin(theta2)*sin(theta3) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta3)*sin(theta1);
    -sin(theta2)*cos(theta3) sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1)]
% space-two
% 131
C = [cos(theta2) -cos(theta1)*sin(theta2) sin(theta1)*sin(theta2);
    sin(theta2)*cos(theta3) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -sin(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*cos(theta1);
    sin(theta2)*sin(theta3) cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% space-two
% 212
C = [-sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta2)*sin(theta3) cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1);
    sin(theta1)*sin(theta2) cos(theta2) -cos(theta1)*sin(theta2);
    -sin(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*cos(theta1) sin(theta2)*cos(theta3) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1)]
% space-two
% 232
C = [cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -sin(theta2)*cos(theta3) sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1);
    cos(theta1)*sin(theta2) cos(theta2) sin(theta1)*sin(theta2);
    -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta1)*sin(theta1) sin(theta2)*sin(theta3) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1)]
% space-two
% 313
C = [-sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) -cos(theta1)*cos(theta2)*sin(theta3)-cos(theta3)*sin(theta1) sin(theta2)*sin(theta3);
    sin(theta1)*cos(theta2)*cos(theta3)+sin(theta3)*cos(theta1) cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -sin(theta2)*cos(theta3);
    sin(theta1)*sin(theta2) cos(theta1)*sin(theta2) cos(theta2)]
% space-two
% 323
C = [cos(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*sin(theta1) -sin(theta1)*cos(theta2)*cos(theta3)-sin(theta3)*cos(theta1) sin(theta2)*cos(theta3);
    cos(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*sin(theta1) -sin(theta1)*cos(theta2)*sin(theta3)+cos(theta3)*cos(theta1) sin(theta2)*sin(theta3);
    -cos(theta1)*sin(theta2) sin(theta1)*sin(theta2) cos(theta2)]

