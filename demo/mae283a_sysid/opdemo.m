% Demo for Output Prediction 
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

clc
disp('Transfer function of orginal system')
G0=tf([0.8 -0.5 0.6 0.5],[1 -0.1 0.6 0.1],1)

disp('Transfer function of orginal noise filter')
H0=tf([1 -1.8 1.15 -0.3],[1 -0.1 0.6 0.1],1)

disp('Press any key...');
pause

disp('Figure 1: Bode plots of G0 and H0');
figure(1)
bode(G0,H0)
legend('G_0','H_0');

disp('Press any key...');
pause


N=10000;
lambda=0.1;
u=randn(N,1);
e=sqrt(lambda)*randn(N,1);
ynf=lsim(G0,u);
v=lsim(H0,e);
y=ynf+v;

disp('Figure 2: I/O data');
figure(2)
subplot(2,1,1);
plot(1:N,u);
title('I/O signals')
ylabel('input');
subplot(2,1,2);
plot(1:N,y);
ylabel('output');
xlabel('samples')

disp('Press any key...');
pause

disp('Figure 3: comparison between actual and simulated output');
figure(3)
plot(1:N,y,1:N,ynf)
title('comparison between actual and simulated output')
ylabel('output');
xlabel('samples')
legend('measured output','simulated output');

disp('Press any key...');
pause

disp('Figure 4: comparison between actual and predicted output');
figure(4)
F=[H0\G0 1-inv(H0)];
yp=lsim(F,[u y]);
plot(1:N,y,1:N,yp,'r')
title('comparison between actual and predicted output')
ylabel('output');
xlabel('samples')
legend('measured output','predicted output');

disp('Press any key...');
pause

disp('Figure 5: comparison between simulation and predicted error');
figure(5)
plot(1:N,y-ynf,1:N,y-yp,'r')
title('comparison between simulation and predicted error')
ylabel('error');
xlabel('samples')
legend('simulation error','predicted error');

disp('Press any key...');
pause

Rs=xcorr(y-ynf,y-ynf,10,'biased');
Rp=xcorr(y-yp,y-yp,10,'biased');

disp('Figure 6: comparison between autocorrelations functions of simulation and predicted error');
figure(6)
plot(-10:10,Rs,-10:10,Rp,'r')
title('comparison between autocorrelation of simulation and predicted error')
ylabel('auto correlation');
xlabel('lag')
legend('autocorrelation of simulation error','autocorrelation of predicted error');