% Demo for Noise Prediction 
% Written by R.A. de Callafon, Dept. of MAE, UCSD <callafon@ucsd.edu>

% Legal Dogma
% * This software is part of the course MAE283a: "Parametric System Identification - 
%   theory and tools (Fall, 2016)", called the MAE283A 2012 course.
% * Use this software to study and understand the main computational tools 
%   behind the system identification techniques used in the MAE283A 2016
%   course only.
% * Feel free to re-use some of the code for your final project in the MAE283a 2016 course
% * UNAUTHORIZED COPYING, REPRODUCTION, REPUBLISHING, UPLOADING, POSTING, TRANSMITTING 
%   OR DUPLICATING OF ANY OF THE CODE BELOW OTHER THAN FOR THE PURPOSE OF
%   THE MAE283A COURSE IS PROHIBITED

% creation of orginal noise filter listed below
%wn=1;b=0.1;num=wn^2;den=[1 2*b*wn wn^2];F=tf(num,den);
%H1=c2d(F,0.1,'foh');
%[num,den]=butter(2,0.1,'high');
%num=[0.9 -1.6 0.7];
%H2=tf(num,den,0.1);
%H0=H1*H2;
%[num,den]=tfdata(H0,'v');
%num=polystab(num);
%num=num/num(1);

num=[1  -1.241567735005714  -0.103606015562001   0.289268246739752   0.055905503827963];
den=[1  -3.531324333508970   4.697233894510167  -2.793766795733357   0.628651926727270];

disp('Transfer function of orginal noise filter')
H0=tf(num,den,1)

pause

figure(1)
bodemag(H0)
title('Amplitude Bode response of noise filter')
pause

% creating noise
N=500;
e=randn(N+100,1);
v=lsim(H0,e);
v=v(101:end);
figure(2),figure(gcf)
plot(v,'x')
xlabel('samples');
title('observed noise signal')
pause

% creating 1-step ahead prediction based on actual noise model knowledge
F=1-inv(H0);
vp=lsim(F,v);
figure(3),figure(gcf)
plot(1:N,v,'x',1:N,vp,'o',1:N,v-vp)
legend('observed','predicted','error');
xlabel('samples');
title('observed and one-step ahead predicted noise signal')
