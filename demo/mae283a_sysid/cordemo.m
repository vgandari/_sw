% Demo for XCORR (correlation function) and DFT (Discrete Fourier Transform) for MAE283a
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


% NOTE: change the value of N (number of data points) here to see effects
N=99;
u=randn(N,1);
Ru=xcorr(u,'biased');
tau=-N+1:N-1;

figure(1)
plot(tau,Ru);
xlabel('\tau');ylabel('R_u(\tau)');
title(['Auto covariance for N = ' num2str(N) ]);

pause

Pu=fft(Ru);
disp('Notice how Pu is not real valued!');
disp(Pu(1:10))

pause
index=[N:2*N-1 1:N-1];
figure(2)
plot(tau,Ru(index));
xlabel('\tau');ylabel('R_u(\tau)');
title(['Symmetric auto covariance for FFT']);

pause 

Pu=fft(Ru(index));
disp('Notice how Pu is now real valued!');
disp(Pu(1:10))

pause
Deltaf=2*pi/(2*N-1);
w=[0:Deltaf:pi];
figure(3)
plot(w,real(Pu(1:N)))
xlabel('w [rad/s]');ylabel('real{P_u(w)}');
grid