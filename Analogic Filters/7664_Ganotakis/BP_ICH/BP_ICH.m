a1=3;
a2=7;
a3=8;
a4=0;

f0 = 1.7*10^3;
w0 = 2*pi*f0;
f1=1400+25*a4;
w1 = 2*pi*f1;
f2 = (f0^2)/f1;
w2 = 2*pi*f2;
Dbeg = 3.5*((f0^2-f1^2)/f1);
f3 = (-Dbeg + sqrt((Dbeg^2) + 4*(f0^2)))/2;
w3 = 2*pi*f3;
f4 = (f0^2)/f3;
w4 = 2*pi*f4;

%euresi twn amin kai amax
amin=33+a3*5/9;
amax=0.4+a4/36;

%Euresi prodiagrafwn
Wp = 1;
Ws = (w4-w3)/(w2-w1);
BW = w2-w1;
qc=w0/BW;

%Euresi taxis tou filtrou
n = acosh(((10^(amin/10) -1)/(10^(amax/10) -1))^(1/2))/acosh(Ws);
n = ceil(n);

e = 1/sqrt(10^(amin/10) -1);
a = (asinh(1/e))/n;
whp = 1/cosh(a);

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
imag3 = cosh(a)*sind(ps3);

real4 = -sinh(a)*cosd(ps4);
imag4 = -cosh(a)*sind(ps4);

W12 = sqrt(real1^2 + imag1^2);
W34 = sqrt(real3^2 + imag3^2);

Q12 = W12/(-2*real1);
Q34 = W34/(-2*real3);

%Poloi tou ICH
IW012 = 1/W12;
IW034 = 1/W34;

%Klimakopoiisi twn polwn
IW012 = IW012*Ws;
IW034 = IW034*Ws;

%Poloi Sinartisis Metaforas
S1= IW012/(2*Q12);
W012=sqrt(IW012^2 - S1^2);
S2= IW034/(2*Q34);
W034=sqrt(IW034^2 - S2^2);

%Midenika
Wz1 = sec(pi/(8));
Wz2 = sec(3*pi/(8));



%Klimakopoiisi twn midenikwn
Wz1=Wz1*Ws;
Wz2=Wz2*Ws;

%Metasximatismos 1ou megadikou polou
Scomplex = abs(S1);
Wcomplex = W012;
C = (Scomplex^2) + Wcomplex^2;
D = (2*Scomplex)/qc;
E = 4 + C/(qc^2);
G = sqrt((E^2) - 4*(D^2));
Qcomplex1 = (1/D)*sqrt((E+G)/2);
K = (Scomplex*Qcomplex1)/qc;
W = K + sqrt((K^2) - 1);
Wcomplex1 = w0/W;
Wcomplex2 = W * w0;

%Metasximatismos 2ou megadikou polou
Scomplex = abs(S2);
Wcomplex = W034;
C = (Scomplex^2) + Wcomplex^2;
D = (2*Scomplex)/qc;
E = 4 + C/(qc^2);
G = sqrt((E^2) - 4*(D^2));
Qcomplex2 = (1/D)*sqrt((E+G)/2);
K = (Scomplex*Qcomplex2)/qc;
W = K + sqrt((K^2) - 1);
Wcomplex3 = w0/W;
Wcomplex4 = W * w0;

%Metasximatismos midenikou  Wz1
Kzero = 2 + (Wz1^2)/(qc^2);
x = (Kzero + sqrt(Kzero^2-4))/2;
Wz12= w0/(sqrt(x));
Wz11 = w0*(sqrt(x));

%Metasximatismos midenikou  Wz2
Kzero = 2 + (Wz2^2)/(qc^2);
x = (Kzero + sqrt(Kzero^2-4))/2;
Wz14 = w0/(sqrt(x));
Wz13 = w0*(sqrt(x));

%1i Monada LPN-Boctor
wz01=Wz11/Wcomplex1;
kmin=1/(wz01^2);
k1=0.7;
R11=2/(k1*(wz01^2) -1);
R12=1/(1-k1);
R13=(1/2)*(k1/(Qcomplex1^2) + k1*wz01^2 -1);
R14=1/k1;
R15=1;
R16=1;
C1=k1/(2*Qcomplex1);
C12=2*Qcomplex1;
k12=1/((1/2)*(k1/(Qcomplex1^2) + k1*wz01^2 +1));
num1=k12*[1 0 (Wz11^2)];
denum1=[1 Wcomplex1/Qcomplex1 Wcomplex1^2];
sys1=tf(num1,denum1);

%klimakopoiisi 1is monadas
km1=C1/(Wcomplex1*10^-6);
R11new=km1*R11;
R12new=km1*R12;
R13new=km1*R13;
R14new=km1*R14;
R15new=km1*R15;
R16new=km1*R16;
C1new=10^-6;
C12new=C12/(km1*Wcomplex1);

%2i monada HPN
wz01=Wz12/Wcomplex2;
Zero = 1/(wz01^2);
%Gia tin ulopoiisi autis tis monadas prepei na elegxthei prwta an
%ikanopoieite i sxesi Qcomplex1 < 1/(1-(Zero/Wcomplex2)^2)
%Epeidi den ikanopoieite tha ulopoiithei to kiklwma tou sximatos 7.21
k21 = Zero - 1; 
R21 = 1;
R23 = 1;
R22 = Qcomplex1^2*((k21 + 2)^2);
R24 = Qcomplex1^2*(k21+ 2);
C2 = 1/(Qcomplex1*(k21 + 2));
C21 = k21*C2;
k22 = Qcomplex1^2*(k21 + 2)/(Qcomplex1^2*(k21 + 2) + 1);
%kerdos
H2=k22*Zero;

num2=H2*[1 0 (Wz12^2)];
denum2=[1 Wcomplex2/Qcomplex1 Wcomplex2^2];
sys2=tf(num2,denum2);



%Klimakopoiisi 2is monadas
kf2 = Wcomplex2;
km2 = C2/(kf2*(10^(-6)));
R21new = km2*R21;
R22new = km2*R22;
R23new = km2*R23;
R24new = km2*R24;
C21new = C21/(kf2*km2);

%3i Monada LPN-Boctor
wz03=Wz13/Wcomplex3;
kmin2=1/(wz03^2);
k2=0.5;
R31=2/(k2*(wz03^2) -1);
R32=1/(1-k2);
R33=(1/2)*(k2/(Qcomplex2^2) + k2*wz03^2 -1);
R34=1/k2;
R35=1;
R36=1;
C3=k2/(2*Qcomplex2);
C31=2*Qcomplex2;
k13=1/((1/2)*(k2/(Qcomplex2^2) + k2*wz03^2 +1));
num3=k13*[1 0 (Wz13^2)];
denum3=[1 Wcomplex3/Qcomplex2 Wcomplex3^2];
sys3=tf(num3,denum3);


%klimakopoiisi 3is monadas
km3=C3/(Wcomplex3*10^-6);
R31new=km3*R31;
R32new=km3*R32;
R33new=km3*R33;
R34new=km3*R34;
R35new=km3*R35;
R36new=km3*R36;
C3new=10^-6;
C31new=C31/(km3*Wcomplex3);

%4i monada HPN
wz04=Wz14/Wcomplex4;
Zero4 = (1)/(wz04^2);
%Gia tin ulopoiisi autis tis monadas prepei na elegxthei prwta an
%ikanopoieite i sxesi Qcomplex4 < 1/(1-(Zero/Wcomplex4)^2)
%Epeidi den ikanopoieite tha ulopoiithei to kiklwma tou sximatos 7.21
k41 = Zero4 - 1; 
R41 = 1;
R43 = 1;
R42 = Qcomplex2^2*((k41 + 2)^2);
R44 = Qcomplex2^2*(k41+ 2);
C4 = 1/(Qcomplex2*(k41 + 2));
C41 = k41*C4;
k42 = Qcomplex2^2*(k41 + 2)/(Qcomplex2^2*(k41 + 2) + 1);
%kerdos
H4=k42*Zero4;

%Klimakopoiisi 4is monadas
kf4 = Wcomplex4;
km4 = C4/(kf4*(10^(-6)));
R41new = km4*R41;
R42new = km4*R42;
R43new = km4*R43;
R44new = km4*R44;
C41new = C41/(kf4*km4);

num4=H4*[1 0 (Wz14^2)];
denum4=[1 Wcomplex4/Qcomplex2 Wcomplex4^2];
sys4=tf(num4,denum4);



%kerdos sti kentriki sixnotita
kw1=abs((Wz11^2 - w0^2)/sqrt((Wcomplex1^2-w0^2)^2+(w0*Wcomplex1)^2/Qcomplex1^2));
kw2=abs((Wz12^2 - w0^2)/sqrt((Wcomplex2^2-w0^2)^2+(w0*Wcomplex2)^2/Qcomplex1^2));
kw3=abs((Wz13^2 - w0^2)/sqrt((Wcomplex3^2-w0^2)^2+(w0*Wcomplex3)^2/Qcomplex2^2));
kw4=abs((Wz14^2 - w0^2)/sqrt((Wcomplex4^2-w0^2)^2+(w0*Wcomplex4)^2/Qcomplex2^2));
kw0=kw1*kw2*kw3*kw4;
%oliko kerdos sto dc
H=k12*H2*k13*H4*kw0;
ah=1/H;

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
ht = bodeplot(sys1,'r',sys2,'g',sys3,'b', sys4, 'y', sys, 'k');
setoptions(ht,'FreqUnits','Hz','PhaseVisible','off');
title('Inverse Chebyshev Band Pass All Units');

figure(7)
attenuation = inv(sys);
ha = bodeplot(attenuation);
setoptions(ha,'FreqUnits','Hz','PhaseVisible','off');
title('Chebyshev Band Elimination Attenuation');

%periodiko sima
fp1=f0-(f0-f1)/2;
fp2=f0+(f0+f1)/2;
fp3=0.5*f3;
fp4=2.4*f4;
fp5=3.5*f4;

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
ltiview(Fv, abs(FTx(Iv))*2)
