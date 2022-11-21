clear
clc

a1=7;
a2=6;
a3=6;
a4=4;

mu = 0;
fp = (3 + mu)*(10^3);
wp = 2*pi*fp;
fs = fp/1.8;
ws = 2*pi*fs;

amin = 25 + a3*(3/9);
amax = 0.4 + a4/36;

%Prodiagrafes
Wp = 1;
Ws = wp/ws;

IWs=1/Ws;

e = 1/sqrt(10^(amin/10) - 1);

n = acosh(((10^(amin/10) - 1)/(10^(amax/10)-1))^(1/2))/acosh(1/IWs);
n = ceil(n);

a = (1/n)*asinh(1/e);

%Sixnotita imiseias isxios katwdiavatis sinartisis
Whp = 1/cosh(acosh(1/e)/n);

%Gia n = 5 exoume tis parakatw gwnies Butterworth
ps1 = 0;
ps2 = 36;
ps3 = -36;
ps4 = 72;
ps5 = -72;
%Opote oi poloi tou Chebyshev prokiptoun ws exis
real1 = -sinh(a)*cosd(ps1);
imag1 = cosh(a)*sind(ps1);

real2 = -(sinh(a)*cosd(ps2));
imag2 = cosh(a)*sind(ps2);

real3 = -sinh(a)*cosd(ps3);
imag3 = -(cosh(a)*sind(ps3));

real4 = -sinh(a)*cosd(ps4);
imag4 = (cosh(a)*sind(ps4));

real5 = -sinh(a)*cosd(ps5);
imag5 = -(cosh(a)*sind(ps5));

W1 = sqrt(real1^2 + imag1^2);
W23 = sqrt(real2^2 + imag2^2);
W45 =  sqrt(real4^2 + imag4^2);   

Q1 = W1/(-2*real1);
Q23 = W23/(-2*real2);
Q45 = W45/(-2*real4);

%Antistrofi twn polwn
IW1=1/W1;
IW23=1/W23;
IW45=1/W45;
%poloi ICH
ip1=IW1*complex(cosd(ps1),sind(ps1));
ip23=IW1*complex(cosd(ps2),sind(ps2));
ip45=IW1*complex(cosd(ps4),sind(ps4));
%midenika apokrisis ICH
Wz23 = sec(pi/10);
Wz45 = sec(3*pi/10);
%antistrofi polwn katwdiavatis apokrisis
wo1=wp/(Ws*IW1);
wo23=wp/(Ws*IW23);
wo45=wp/(Ws*IW45);
wz23=wp/(Ws*Wz23);
wz45=wp/(Ws*Wz45);


%Monada 1 anwdiavato filtro 1is taksis
R1=1;
C1=1;
sys1=tf([0 1 0],[1 wo1]);
%Klimakopoiisi
kf1=wo1;
C1new=10^(-7);
km=1/(kf1*C1new);
R1new=R1*km;

%2i Monada HPN-kiklwma Boctor
R21=1.213726599756047e+02;
R22=1.025472985735630e+04;
R23=1.170600842425778;
R24=100;
R25=100;
C21=10^(-7);
C22=10^(-7);
k1=2;
%Sinartisi Metaforas
num2=k1*[1 0 wz23^2];
denum2=[1 (wo23/Q23) wo23^2];
sys2=tf(num2,denum2);

%Monada 3 HPN
w03 = wz45/wo45;
Zero=1/(w03^2);
k21 = Zero - 1; 
R21 = 1;
R23 = 1;
R22 = Q45^2*((k21 + 2)^2);
R24 = Q45^2*(k21+ 2);
C2a = 1/(Q45*(k21 + 2));
C21 = k21*C2a;
k22 = Q45^2*(k21 + 2)/(Q45^2*(k21 + 2) + 1);
%kerdos stis ipsiles sixnotites
k2=k22*Zero;
%Sinartisi Metaforas
num3=k2*[1 0 wz45^2];
denum3=[1 wo45/Q45 wo45^2];
sys3=tf(num3,denum3);

%Klimakopoiisi 3is monadas
kf2 = wo45;
km2 = C2a/(kf2*(10^(-7)));
R21new = km2*R21;
R22new = km2*R22;
R23new = km2*R23;
R24new = km2*R24;
C21new = 10^(-7)*k21;

%Sinoliko kerdos 
ktot = k1*k2;

%Rithmisi kerdous
ah=1/ktot;
r01=10000;
r02=ah*r01;
%oliki sinartisi metaforas
sys12=series(sys1,sys2);
sys=series(sys12,sys3);
sys=ah*sys;
figure(1)
h = bodeplot(sys1);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('First Unit HighPass');

figure(2)
h = bodeplot(sys2);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Second Unit HighPass');

figure(3)
h = bodeplot(sys3);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Third Unit HighPass');

figure(4)
h = bodeplot(sys);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Total Unit Inverse Chebyshev HighPass');

figure(5)
attenuation = inv(sys);
ha = bodeplot(attenuation);
setoptions(ha,'FreqUnits','Hz','PhaseVisible','off');
title('Inverse Chebyshev HighPass Attenuation');

figure(6)
ht = bodeplot(sys1,'r',sys2,'g',sys3,'b',sys,'y');
setoptions(ht,'FreqUnits','Hz','PhaseVisible','off');
title('Inverse Chebyshev All Units');

%pigi diegersis
ph1=0.4*fs;
ph2=0.9*fs;
ph3=1.4*fp;
ph4=2.4*fp;
ph5=4.5*fp;

wp1=2*pi*ph1;
wp2=2*pi*ph2;
wp3=2*pi*ph3;
wp4=2*pi*ph4;
wp5=2*pi*ph5;

T = 10*(1/2000);
Period=1/2000;
Fs = 100000;
dt = 1/Fs;
t = 0:dt:T-dt;

signal=cos(wp1*t)+0.6*cos(wp2*t)+cos(wp3*t)+0.8*cos(wp4*t)+0.4*cos(wp5*t);



out=lsim(sys,signal,t);

Fn = Fs/2;                                          % Nyquist Frequency
N = length(t);
FTin = fft(signal);                                     % Fourier Transform
Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
Iv = 1:length(Fv);
figure(8)
plot(Fv, abs(FTin(Iv))*2)

FTx= fft(out);

figure(9)
plot(Fv, abs(FTx(Iv))*2)
