% LC oscillator design (GP)
% Boyd, Kim, and Mohan, "Geometric programming and its
% applications to EDA Problems", (DATE Tutorial 2005), pp.102-113.
% Original code by S. Mohan
% Written for CVX by Almir Mutapcic 02/08/06
%
% Designs an LC oscillator consisting of a loop inductor, varactors
% for fine tuning, binary weighted switching capacitors for coarse
% tuning, cross coupled NMOS transistors, and tail current source.
% The optimal LC oscillator design iwith minimum power consumption,
% and limits on phase noise, area, etc... can be formulated as a GP:
%
%   minimize   P
%       s.t.   N <= Nmax, A <= Amax, l >= lmin, etc.
%
% where optimization variables are loop inductor dimensions D,W,
% size of varactor Vc, size of switching caps Csw, width and length
% of transistors Wnmos, Lnmos, bias current Ibias, etc.

%********************************************************************
% problem data
%********************************************************************
Vdd   = 1.2;         % voltage
CL    = 0.2e-12;     % load capcitance
F     = 5e9;         % operating frequency in Hz
omega = 2*pi*F;      % operating freq. in radians

FOff   = 6e5;        % offset frequency for phase noise calculation
LoopGainSpec = 2.0;  % loop gain spec
Vbias  = 0.2;        % non ideality of current mirror

% tuning specs
T         = 0.1;     % +/- tuning range as a normalized value
CvarRatio = 3;       % maximum to minimum value of CVar
CswBits   = 3;
CswSegs   = 2^(CswBits);
CvarCswLSBOverlap = 2;

% set the quiet flag (no solver reporting)

disp('Generating the optimal tradeoff curve...')

%********************************************************************
% optimization of LC oscillator circuit (with tradeoff curve)
%********************************************************************
% varying phase noise parameter for the tradeoff curve
powers = [];
for PNSpec=0.7e-12:0.2e-12:1e-11

scp_begin gp quiet
    % optimization variables
    scp_variable D;        % diameter of loop inductor
    scp_variable W;        % width of loop inductor
    scp_variable SRF;      % self resonance frequency
    scp_variable l;        % length of CMOS transistor
    scp_variable w;        % width of CMOS transistor
    scp_variable I;        % maximum current through CMOS transistor
    scp_variable VOsc;     % differential voltage amplitude
    scp_variable CT;       % total capacitance of oscillator
    scp_variable Csw;      % maximum switching capacitance
    scp_variable Cvar;     % minimum variable capacitance
    scp_variable IBias;    % bias current
    scp_variable CMaxFreq; % capacitor max frequency

    % minimize power = Vdd*IBias;
    scp_minimize( Vdd*IBias )
    convex_begin_declare
          %*******************************************%
          % loop inductor definitions and constraints %
          %*******************************************%
          SRFSpec  = 3*F;
          omegaSRF = 2*pi*SRF;

          % inductance
          L = 2.1e-06*D^(1.28)*(W)^(-0.25)*(F)^(-0.01);
          % series resistance
          R = 0.1*D/W+3e-6*D*W^(-0.84)*F^(0.5)+5e-9*D*W^(-0.76)*F^(0.75)+0.02*D*W*F;
          % effective capacitance
          C = 1e-11*D+5e-6*D*W;

          % area, tank conductance, and inverse quality factor
          Area = (D+W)^2;
          G    = R/(omega*L)^2;
          invQ = R/(omega*L);

          % loop constraints
          Area <= 0.25e-6;
          W <= 30e-6;
          5e-6 <= W;
          10*W <= D;
          D <= 100*W;
          SRFSpec <= SRF;
          omegaSRF^2*L*C <= 1;

          %****************************************%
          % transistor definitions and constraints %
          %****************************************%
          GM  = 6e-3*(w/l)^0.6*(I/2)^(0.4);
          GD  = 4e-10*(w/l)^0.4*(I/2)^(0.6)*1/l;
          Vgs = 0.34+1e-8/l+800*(I*l/(2*w))^0.7;
          Cgs = 1e-2*w*l;
          Cgd = 1e-9*w;
          Cdb = 1e-9*w;

          % transistor constraints
          2e-6 <= w;
          0.13e-6 <= l;
          l <= 1e-6;

          %***************************************************%
          % overall LC oscillator definitions and constraints %
          %***************************************************%
          invVOsc = (G+GD)/IBias;

          % phase noise
          kT4  = 4*1.38e-23*300;
          kT4G = 2*kT4;
          LoopCurrentNoise = kT4*G;
          TransistorCurrentNoise = 0.5*kT4G*GM;
          PN = 1/(160*(FOff*VOsc*CT)^2)*(LoopCurrentNoise+TransistorCurrentNoise);

          % capacitance
          Cfix = C+0.5*(CL+Cgs+Cdb+4*Cgd); % fixed capacitance
          CDiffMaxFreq = Cfix+0.5*Cvar;

          invLoopGain = (G+0.5*GD)/(0.5*GM);

          % LC oscillator constraints
          PN <= PNSpec;
          omega^2*L*CT == 1;
          omega^2*(1+T)^2*L*CMaxFreq == 1;
          4*T/((1-T^2)^2)*CT <= Csw*(1+CvarCswLSBOverlap/CswSegs);
          Csw*CvarCswLSBOverlap/CswSegs <= 0.5*Cvar*(CvarRatio-1);
          CDiffMaxFreq <= CMaxFreq;
          VOsc+2*Vbias <= 2*Vdd;
          VOsc*invVOsc <= 1;
          invLoopGain*LoopGainSpec <= 1; % loop gain spec
          Vbias+Vgs+IBias/2*R/2 <= Vdd;  % bias constraint spec
          I == IBias;
	convex_end_declare
scp_end

  % display and store computed values
  fprintf(1,'  PNSpec = %5.2f (dBc/Hz)   min_power = %3.2f (mW)\n', ...
          10*log10(PNSpec),scp_optval/1e-3);
  powers = [powers scp_optval];
end

% plot the tradeoff curve
PNSpec = [0.7e-12:0.2e-12:1e-11];
plot(10*log10(PNSpec),powers/1e-3);
xlabel('Phase Noise (dBc/Hz)')
ylabel('Power (mW)')
disp('Optimal tradeoff curve plotted.')
