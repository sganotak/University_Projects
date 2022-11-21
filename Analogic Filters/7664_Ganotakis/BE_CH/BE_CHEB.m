a1=7;
a2=6;
a3=6;
a4=4;

f0 = 2500;
w0 = 2*pi*f0;
f1 = 1650 + 50*a3;
w1 = 2*pi*f1;
f2 = (f0^2)/f1;
w2 = 2*pi*f2;
Dbeg = ((f0^2)-(f1^2))/(f1*2.5);
f3 = (-Dbeg + sqrt((Dbeg^2) + 4*(f0^2)))/2;
w3 = 2*pi*f3;
f4 = (f0^2)/f3;
w4 = 2*pi*f4;
amin=26+a3*(5/9);
amax=0.5+a4/18;

Wp = 1;
Ws = (w2-w1)/(w4-w3);
BW = 2*pi*(f2-f1);
qc=w0/BW;

%Euresi taxis tou filtrou
n = acosh(((10^(amin/10) -1)/(10^(amax/10) -1))^(1/2))/acosh(Ws);
n = ceil(n);

e = sqrt(10^(amax/10) -1);
a = (asinh(1/e))/n;

%Gia n = 4 exoume tis parakatw gwnies Butterworth
ps1 = 22.5;
ps2 = -22.5;
ps3 = 67.5;
ps4= -67.5;

real1 = -sinh(a)*cosd(ps1);
imag1 = cosh(a)*sind(ps1);

real2 = -(sinh(a)*cosd(ps2));
imag2 = -cosh(a)*sind(ps2);

real3 = -sinh(a)*cosd(ps3);
imag3 = (cosh(a)*sind(ps3));

real4 = -sinh(a)*cosd(ps4);
imag4 = -(cosh(a)*sind(ps4));

W12 = sqrt(real1^2 + imag1^2);
W34 = sqrt(real3^2 + imag3^2);
Q12 = W12/(-2*real1);
Q34 = W34/(-2*real3);

IW12=1/W12;
IW34=1/W34;

ipsi12=acosd(1/(2*Q12));
ipsi34=acosd(1/(2*Q34));

real12new=IW12*(-cosd(ipsi12));
im12new=IW12*(sind(ipsi12));
real34new=IW34*(-cosd(ipsi34));
im34new=IW34*(sind(ipsi34));

%Metasximatismos 1ou megadikou polou
Scomplex = abs(real12new);
Wcomplex = im12new;
C = (Scomplex^2) + (abs(Wcomplex)^2);
D = (2*Scomplex)/qc;
E = 4 + C/(qc^2);
G = sqrt((E^2) - 4*(D^2));
Qcomplex1 = (1/D)*sqrt((E+G)/2);
K = (Scomplex*Qcomplex1)/qc;
W = K + sqrt((K^2) - 1);
Wcomplex1 = w0/W;
Wcomplex2 = W * w0;

%Metasximatismos 2ou megadikou polou
Scomplex = abs(real34new);
Wcomplex = im34new;
C = (Scomplex^2) + (abs(Wcomplex)^2);
D = (2*Scomplex)/qc;
E = 4 + C/(qc^2);
G = sqrt((E^2) - 4*(D^2));
Qcomplex2 = (1/D)*sqrt((E+G)/2);
K = (Scomplex*Qcomplex2)/qc;
W = K + sqrt((K^2) - 1);
Wcomplex3 = w0/W;
Wcomplex4 = W * w0;

%Monada 1- LPN
R11=1;
R14=1;
w01=w0/Wcomplex1;
C1=1/(2*Qcomplex1);
R12=4*(Qcomplex1^2);
R15=4*(Qcomplex1^2)/(w01^2 - 1);
R13=(w01^2)/(2*(Qcomplex1^2));
k1=1/(R13+1);
%Sinartisi Metaforas
num1=[1 0 w0^2];
denum1=[1 Wcomplex1/Qcomplex1 Wcomplex1^2];
sys1=tf(k1*num1,denum1);
%kerdos sto dc
k1dc=k1*(w0^2/Wcomplex1^2);

%Klimakopoiisi 1is monadas
C1new=10^-7;
kf1=Wcomplex1;
km1=C1/(kf1*C1new);
R11new=R11*km1;
R12new=R12*km1;
R13new=R13*km1;
R14new=R14*km1;
R15new=R15*km1;

%2i monada HPN
w02 = w0/Wcomplex2;
Zero=1/(w02^2);
k21 = Zero - 1; 
R21 = 1;
R23 = 1;
R22 = Qcomplex1^2*((k21 + 2)^2);
R24 = Qcomplex1^2*(k21+ 2);
C2a = 1/(Qcomplex1*(k21 + 2));
C21 = k21*C2a;
k22 = Qcomplex1^2*(k21 + 2)/(Qcomplex1^2*(k21 + 2) + 1);
%kerdos sto apeiro
k2=k22*Zero;


num2=k2*[1 0 (w0^2)];
denum2=[1 Wcomplex2/Qcomplex1 Wcomplex2^2];
sys2=tf(num2,denum2);


%Klimakopoiisi 2is monadas
kf2 = Wcomplex2;
km2 = C2a/(kf2*(10^(-7)));
R21new = km2*R21;
R22new = km2*R22;
R23new = km2*R23;
R24new = km2*R24;
C21new = C21/(kf2*km2);

%Monada 3- LPN
R31=1;
R34=1;
w03=w0/Wcomplex3;
C3=1/(2*Qcomplex2);
R32=4*(Qcomplex2^2);
R35=4*(Qcomplex2^2)/(w03^2 - 1);
R33=(w03^2)/(2*(Qcomplex2^2));
k3=1/(R33+1);
%Sinartisi Metaforas
num3=[1 0 w0^2];
denum3=[1 Wcomplex3/Qcomplex2 Wcomplex3^2];
sys3=tf(k3*num3,denum3);



%Klimakopoiisi 3is monadas
C3new=10^-7;
kf3=Wcomplex3;
km3=C3/(kf3*C3new);
R31new=R31*km3;
R32new=R32*km3;
R33new=R33*km3;
R34new=R34*km3;
R35new=R35*km3;

%4i monada HPN
w04 = w0/Wcomplex4;
Zero4=1/(w04^2);
k41 = Zero4 - 1; 
R41 = 1;
R43 = 1;
R42 = Qcomplex2^2*((k41 + 2)^2);
R44 = Qcomplex2^2*(k41+ 2);
C4a = 1/(Qcomplex2*(k41 + 2));
C41 = k41*C4a;
k42 = Qcomplex2^2*(k41 + 2)/(Qcomplex2^2*(k41 + 2) + 1);
%kerdos sto apeiro
k4=k42*Zero4;


num4=k4*[1 0 (w0^2)];
denum4=[1 Wcomplex4/Qcomplex2 Wcomplex4^2];
sys4=tf(num4,denum4);


%Klimakopoiisi 4is monadas
kf4 = Wcomplex4;
km4 = C4a/(kf4*(10^(-7)));
R41new = km4*R41;
R42new = km4*R42;
R43new = km4*R43;
R44new = km4*R44;
C41new = C41/(kf4*km4);

%oliko kerdos sto dc
H=k1*k2*k3*k4;
ah=1.778/H;

%oliki sinartisi metaforas
sys12=series(sys1,sys2);
sys123=series(sys12,sys3);
sys1234=series(sys123,sys4);
sys=ah*sys1234;

figure(1)
h = bodeplot(sys1);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev First Unit Band Elimination');

figure(2)
h = bodeplot(sys2);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Second Unit Band Elimination');

figure(3)
h = bodeplot(sys3);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Third Unit Band Elimination');

figure(4)
h = bodeplot(sys4);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Fourth Unit Band Elimination');

figure(5)
h = bodeplot(sys);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Band Elimination All Units');

figure(6)
ht = bodeplot(sys1,'r',sys2,'g',sys3,'b', sys4, 'y', sys, 'k');
setoptions(ht,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Band Elimination All Units');

figure(7)
attenuation = inv(sys);
ha = bodeplot(attenuation);
setoptions(ha,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Band Elimination Attenuation');

%periodiko sima
fp1=f0-(f0-f3)/3;
fp2=f0+(f0+f3)/4;
fp3=0.5*f1;
fp4=2.4*f2;
fp5=3*f2;

wp1=2*pi*fp1;
wp2=2*pi*fp2;
wp3=2*pi*fp3;
wp4=2*pi*fp4;
wp5=2*pi*fp5;

T = 10*(1/2000);
Period=1/2000;
Fs = 100000;
dt = 1/Fs;
t = 0:dt:T-dt;

signal=cos(wp1*t)+0.6*cos(wp2*t)+0.7*cos(wp3*t)+0.8*cos(wp4*t)+0.6*cos(wp5*t);

out=lsim(sys,signal,t);

Fn = Fs/2;                                          % Nyquist Frequency
N = length(t);
FTx = fft(signal);                                     % Fourier Transform
Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
Iv = 1:length(Fv);
figure(8)
plot(Fv, abs(FTx(Iv))*2)

Fn = Fs/2;                                          % Nyquist Frequency
N = length(t);
FTx = fft(out);                                     % Fourier Transform
Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
Iv = 1:length(Fv);                                  % Index Vector

figure(9)
plot(Fv, abs(FTx(Iv))*2)
