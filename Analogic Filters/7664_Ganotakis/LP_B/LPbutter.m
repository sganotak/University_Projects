clear
clc

a1=7;
a2=6;
a3=6;
a4=4;
mu=2;

fp=(3+mu)*1200;
fs=2.3*fp;
amin=24+(max(1,a3)-5)*0.5;
amax=0.75+(max(1,a4)-5)/16;
wp = 2*pi*fp;
ws = 2*pi*fs;

n = log((10^(amin/10) -1)/(10^(amax/10) -1))/(2*log(ws/wp));
n = ceil(n);

wo=wp/((10^(amax/10)-1)^(1/(2*n)));

%For n = 5
Q1 = 0.5;
Q2 = 0.62;
Q3 = 1.62;
ps1 = 0;
ps2 = 36;
ps3 = 72;

%first unit
R1=1;
C1=1;
%klimakopoiisi
kf=wo;
km1 = 1/(kf*10^-7);
R1new=R1*km1;

%second unit
kf = wo;
k2=3-1/Q2;
R21old = 1;
R22old = 1;
C21old = 1;
C22old = 1;
r1old=1;
r2old=2-1/Q2;
%klimakopoiisi
km2 = 1/(kf*10^-7);
R21=R21old*km2
R22new = R22old*km2;
r1new=r1old*km2
r2new=r2old*km2;

%third unit
kf3 = wo;
k3=3-1/Q3;
R31old = 1;
R32old = 1;
C31old = 1;
C32old = 1;
r31old=1;
r32old=2-1/Q3;
%klimakopoiisi
km3 = 1/(kf3*10^-7);
R31=R31old*km3
R32new = R32old*km3;
r31new=r31old*km3
r32new=r32old*km3;

%Rithmisi kerdous
kol = k2*k3;
ktel = 0;
a = 1/kol;
Z2 = kol;
Z3=kol/(kol-1);

%Sinartisi metaforas prwtis vathmidas
num1 = [wo];
den1 = [1 wo];
TH1 = tf(num1,den1);


%Sinartisi metaforas deuteris vathmidas
num2=[k2*(wo^2)];
den2=[1 wo/Q2 wo^2];
TH2 = tf(num2,den2);

%Sinartisi metaforas tritis vathmidas
num3=[k3*(wo^2)];
den3=[1 wo/Q3 wo^2];
TH3 = tf(num3,den3);

%Sinoliki sinartisi metaforas
TH12=series(TH1,TH2);
TH123=series(TH12,TH3);
TH=((1/3.303)*TH123);


figure(1)
h = bodeplot(TH1);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('First Unit LowPass');

figure(2)
h = bodeplot(TH2);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Second Unit LowPass');

figure(3)
h = bodeplot(TH3);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Third Unit LowPass');

figure(4)
h = bodeplot(TH);
setoptions(h,'FreqUnits','Hz','PhaseVisible','off');
title('Butterworth LowPass');

figure(5)
attenuation = inv(TH);
ha = bodeplot(attenuation);
setoptions(ha,'FreqUnits','Hz','PhaseVisible','off');
title('Butterworth LowPass Attenuation');

figure(6)
ht = bodeplot(TH1,'r',TH2,'g',TH3,'b',TH,'y');
setoptions(ht,'FreqUnits','Hz','PhaseVisible','off');
title('Butterworth All Units');



%trigwniko sima
T = 10*(1/2000);
Period=1/2000;
Fs = 100000;
dt = 1/Fs;
t = 0:dt:T-dt;
x = sawtooth(2*pi*2000*t,0.5);
   

out=lsim(TH,x,t)


Fn = Fs/2;                                          % Nyquist Frequency
N = length(t);
FTx = fft(out);                                        % Fourier Transform
Fv = linspace(0, 1, fix(N/2)+1)*Fn;                 % Frequency Vector
Iv = 1:length(Fv);                                  % Index Vector
FTin= fft(x);

figure(7)
plot(Fv, abs(FTin(Iv))*2)
figure(8)
plot(Fv, abs(FTx(Iv))*2)