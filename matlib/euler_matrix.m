function C = euler_matrix(e1,e2,e3,e4)


%%


C11 = 1 -2*e2^2 - 2*e3^2;
C12 = 2*(e1*e2-e3*e4);
C13 = 2*(e3*e1+e2*e4);
C21 = 2*(e1*e2+e3*e4);
C22 = 1 - 2*e3^2-2*e1^2;
C23 = 2*(e2*e3-e1*e4);
C31 = 2*(e3*e1-e2*e4);
C32 = 2*(e2*e3 + e1*e4);
C33 = 1 - 2*e1^2 - 2*e2^2;

C11dot = 1 -4*e2 - 4*e3;
C12dot = 2*(e1*e2-e3*e4);
C13dot = 2*(e3*e1+e2*e4);
C21dot = 2*(e1*e2+e3*e4);
C22dot = 1 - 2*e3^2-2*e1^2;
C23dot = 2*(e2*e3-e1*e4);
C31dot = 2*(e3*e1-e2*e4);
C32dot = 2*(e2*e3 + e1*e4);
C33dot = 1 - 2*e1^2 - 2*e2^2;
% 
C = [C11 C12 C13; C21 C22 C23; C31 C32 C33];
% 
% if (((C11^2 + C12^2 + C13^2) == 1) && ((C21^2 + C22^2 + C23^2) == 1 ) && ((C31^2 + C32^2 + C33^2) == 1))
%     disp('satisfies constraint equation')
% else 
%     disp('error: Matrix does not satisfies constraints')
% end 

return 