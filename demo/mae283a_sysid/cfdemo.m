% Demo for Curve Fitting (Frequency Domain identification) 
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
theta0=[0.8 -0.5 0.6 0.5 -0.1 0.6 0.1]';

pause

if exist('data_prim1.mat')
    disp('Loading noise free and periodic data')
    load data_prim1
    N=length(u);
else
    disp('Generating noise free and periodic data')
    % number of data points
    N=2048;
    % input (that is periodic)
    u=randn(N,1);u=[u;u];
    ynf=lsim(G0,u);
    u=u(N+1:end);
    ynf=ynf(N+1:end);
    
    % generating noise to be used later with a noise level:
    lambda=5;
    % and not periodic and low frequent:
    [numh,denh]=butter(2,0.1);
    H0=tf(numh,denh,1);
    e=sqrt(lambda)*randn(N,1);
    v=lsim(H0,e);
end


figure(1)
plot([u ynf]);
legend('(periodic) input u','(noise free) output y')
title('I/O signals)')
pause

disp('Comparing estimated and weighted cross correlation functions with impulse response')
% impulse response
imp=impulse(G0,49);

% estimated (cross0 correlation function
Ruu=xcorr(u,u,N/2);
Ryu=xcorr(ynf,u,N/2);

% multiply with hanning window of size gamma
gamma=100;
W=[zeros((N-gamma)/2,1);hanning(gamma+1);zeros((N-gamma)/2,1)];
Ruu_weighted = Ruu.*W;    
Ryu_weighted = Ryu.*W;    


figure(2)
l=plot(0:49,imp,0:49,Ryu(N/2+1:N/2+49+1)/N,'r',0:49,W(N/2+1:N/2+49+1),'r--',0:49,Ryu_weighted(N/2+1:N/2+49+1)/N,'g');
set(l,'linewidth',1.5);
xlabel('\tau');
legend('g_0(\tau)','R_y_u(\tau)','W(\tau)','R_y_u(\tau)W(\tau)');
title('Estimated and weighted cross correlation function compared with actual impulse response')
pause


disp('Performing Spectral Analysis to estimate frequency response of G_0')

% make it suitable for fft
Suu=1/N*fft([Ruu_weighted(N/2+1:N);Ruu_weighted(1:N/2)]);
Syu=1/N*fft([Ryu_weighted(N/2+1:N);Ryu_weighted(1:N/2)]);

% spectral estimate
P=Suu(1:N/2+1).\Syu(1:N/2+1);

% compare with actual Bode response of system
w=linspace(0,pi,N/2+1)';
[m,p]=bode(G0,w);
figure(3)
l=loglog(w,abs(P),'go',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
title(['Amplitude Bode plot of SPA with Hanning window of width ' num2str(gamma) ])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_s_p_a','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])
pause

disp('Estimate model parameters via LS Curve Fitting using direct regression of data:')
X=[ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w) -P.*exp(-j*w) -P.*exp(-2*j*w) -P.*exp(-3*j*w)];
theta=[real(X);imag(X)]\[real(P);imag(P)];
[theta theta0]
Ghat=tf(theta(1:4)',[1 theta(5:7)'],1);
pause

disp('Comparing Bode plots of model with real system')
figure(4)
[mghat,pghat]=bode(Ghat,w);
l=loglog(w,mghat(:),'g-',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
%axis([1e-2 1e1 1e-2 1])
title(['Amplitude Bode plot of Curve Fitted model'])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_c_f','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])

pause
disp('Let''s see the effect of the weighting function W(\tau) on the spectral estimation');

% multiply with hanning window of size gamma that is much smaller
gamma=28;
W=[zeros((N-gamma)/2,1);hanning(gamma+1);zeros((N-gamma)/2,1)];
Ruu_weighted = Ruu.*W;    
Ryu_weighted = Ryu.*W;    


figure(5)
l=plot(0:49,imp,0:49,Ryu(N/2+1:N/2+49+1)/N,'r',0:49,W(N/2+1:N/2+49+1),'r--',0:49,Ryu_weighted(N/2+1:N/2+49+1)/N,'g');
set(l,'linewidth',1.5);
xlabel('\tau');
legend('g_0(\tau)','R_y_u(\tau)','W(\tau)','R_y_u(\tau)W(\tau)');
title('Estimated and weighted cross correlation function compared with actual impulse response')
pause


disp('Performing Spectral Analysis to estimate frequency response of G_0')

% make it suitable for fft
Suu=1/N*fft([Ruu_weighted(N/2+1:N);Ruu_weighted(1:N/2)]);
Syu=1/N*fft([Ryu_weighted(N/2+1:N);Ryu_weighted(1:N/2)]);

% spectral estimate
P=Suu(1:N/2+1).\Syu(1:N/2+1);

% compare with actual Bode response of system
[m,p]=bode(G0,w);
figure(6)
l=loglog(w,abs(P),'go',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
title(['Amplitude Bode plot of SPA with Hanning window of width ' num2str(gamma) ])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_s_p_a','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])
pause

disp('Estimate model parameters via LS Curve Fitting using direct regression of data:')
X=[ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w) -P.*exp(-j*w) -P.*exp(-2*j*w) -P.*exp(-3*j*w)];
theta=[real(X);imag(X)]\[real(P);imag(P)];
[theta theta0]
Ghat=tf(theta(1:4)',[1 theta(5:7)'],1);
pause

disp('Comparing Bode plots of model with real system')
figure(7)
[mghat,pghat]=bode(Ghat,w);
l=loglog(w,mghat(:),'g-',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
%axis([1e-2 1e1 1e-2 1])
title(['Amplitude Bode plot of Curve Fitted model'])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_c_f','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])

pause
if exist('cfdata.mat')==2,
    disp('Using loaded noisy data (but still with periodic input)')
else
    disp('Using generating noisy data (but still with periodic input)')
end
y=ynf+v;

figure(8)
plot([u y v]);
legend('(periodic) input u','(noisy) output y','output noise v')
title('I/O signals)')
pause

disp('Comparing estimated and weighted cross correlation functions with impulse response')

% estimated (cross) correlation function
Ruu=xcorr(u,u,N/2);
Ryu=xcorr(y,u,N/2);

% multiply with hanning window of size gamma
gamma=100;
W=[zeros((N-gamma)/2,1);hanning(gamma+1);zeros((N-gamma)/2,1)];
Ruu_weighted = Ruu.*W;    
Ryu_weighted = Ryu.*W;    


figure(9)
l=plot(0:49,imp,0:49,Ryu(N/2+1:N/2+49+1)/N,'r',0:49,W(N/2+1:N/2+49+1),'r--',0:49,Ryu_weighted(N/2+1:N/2+49+1)/N,'g');
set(l,'linewidth',1.5);
xlabel('\tau');
legend('g_0(\tau)','R_y_u(\tau)','W(\tau)','R_y_u(\tau)W(\tau)');
title('Estimated and weighted cross correlation function compared with actual impulse response')
pause


disp('Performing Spectral Analysis to estimate frequency response of G_0')

% make it suitable for fft
Suu=1/N*fft([Ruu_weighted(N/2+1:N);Ruu_weighted(1:N/2)]);
Syu=1/N*fft([Ryu_weighted(N/2+1:N);Ryu_weighted(1:N/2)]);

% spectral estimate
P=Suu(1:N/2+1).\Syu(1:N/2+1);

% compare with actual Bode response of system
[m,p]=bode(G0,w);
figure(10)
l=loglog(w,abs(P),'go',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
title(['Amplitude Bode plot of SPA with Hanning window of width ' num2str(gamma) ])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_s_p_a','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])
pause

disp('Estimate model parameters via LS Curve Fitting using direct regression of data:')
X=[ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w) -P.*exp(-j*w) -P.*exp(-2*j*w) -P.*exp(-3*j*w)];
theta=[real(X);imag(X)]\[real(P);imag(P)];
size(theta)
Ghat=tf(theta(1:4)',[1 theta(5:7)'],1);
pause

disp('Comparing Bode plots of model with real system')
figure(11)
[mghat,pghat]=bode(Ghat,w);
l=loglog(w,mghat(:),'g-',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
%axis([1e-2 1e1 1e-2 1])
title(['Amplitude Bode plot of Curve Fitted model'])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_c_f','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])
pause

disp('Optional: additional iterations to de-emphasize the implicit high frequency weighting')
max_par_diff=1;
counter=1;
while max_par_diff>1e-8;
    Weight=[ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w)]*[1;theta(5:7)];
    %Weight=abs(Weight).^4;
    X=[Weight.\ones(N/2+1,1) Weight.\exp(-j*w) Weight.\exp(-2*j*w) Weight.\exp(-3*j*w) -Weight.\P.*exp(-j*w) -Weight.\P.*exp(-2*j*w) -Weight.\P.*exp(-3*j*w)];
    theta_new=[real(X);imag(X)]\[real(Weight.\P);imag(Weight.\P)];
    counter=counter+1;
    max_par_diff=max(abs(theta-theta_new));
    disp([num2str(counter) ': max. par. difference = ' num2str(max_par_diff) ', OE = ' num2str(norm(sqrt(N)\(P-([ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w)]*[1;theta(5:7)]).\([ones(N/2+1,1) exp(-j*w) exp(-2*j*w) exp(-3*j*w)]*theta(1:4))))) '.']);
    theta=theta_new;
end

[theta theta0]
Ghat=tf(theta(1:4)',[1 theta(5:7)'],1);
pause

disp('Comparing Bode plots of model with real system')
figure(12)
[mghat,pghat]=bode(Ghat,w);
l=loglog(w,mghat(:),'g-',w,m(:),'r');figure(gcf);
set(l,'linewidth',1.5);
%axis([1e-2 1e1 1e-2 1])
title(['Amplitude Bode plot of Curve Fitted model'])
ylabel('mag  [gain]')
xlabel('w  [rad/s]');
legend('G_c_f','G_0','SouthWest')
axis([1e-3 10 1e-1 1e1])
disp('Observer the (slight) improvement by comparing Fig. 12 with Fig. 11')

