%Project for Digital Image Processing Course
%Point Transform/Histogram Transform
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664

%demo 3: Histogram Transform based on pdf function

clear all
close all



% Load image , and convert it to gray -scale
 x = imread('lena.bmp');
 x = rgb2gray(x);
 x = double(x) / 255;
 
%% Case 1

 %d=[0:0.1:1];
 d=[0:0.05:1];

 f=@unif1; %uniform pdf [0,1]
 h = pdf2hist(d, f);
 
 v=zeros(length(d)-1,1); 
   for i=1:length(d)-1 %defining intensity at the half of each interval
       v(i)=abs(d(i)+d(i+1))/2;
   end
 Y = histtransform(x, h, v);
        
 figure(1);
 subplot(1,2,1)
 imshow(Y);
 
 %title('Uniform distribution [0,1]');
 [hn , hx] = hist(Y(:), 0:1/255:1);
            
hn=100*hn/sum(hn); %making the histogram %
h=h*100;
        
subplot(1,2,2)
        
bar(hx , hn,2,'facecolor','b');
        

hold on;
stem(v,h,'LineWidth',1,'Color','r');
plot(v,h,'LineWidth',1,'Color','r');
xlim([min(v)-0.02,max(v)+0.02]);
set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
grid on;
xlabel('Intensity')
ylabel('Histogram %')

hold off
suptitle('Uniform distribution [0,1]');

%% Case 2

d=[0:0.2:2];
 %d=[0:0.1:1];

 f=@unif2; %uniform pdf [0,2]
 h = pdf2hist(d, f);
 
 v=zeros(length(d)-1,1); 
   for i=1:length(d)-1 %defining intensity at the half of each interval
       v(i)=abs(d(i)+d(i+1))/2;
   end
 Y = histtransform(x, h, v);
        
 figure(2);
 subplot(1,2,1)
 imshow(Y);
 
 %title('Uniform distribution [0,2]');
 [hn , hx] = hist(Y(:), 0:1/255:2);
            
hn=100*hn/sum(hn); %making the histogram %
h=h*100;
        
subplot(1,2,2)
        
bar(hx , hn,2,'facecolor','b');
        

hold on;
stem(v,h,'LineWidth',1,'Color','r');
plot(v,h,'LineWidth',1,'Color','r');
xlim([min(v)-0.02,max(v)+0.02]);
set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
grid on;
xlabel('Intensity')
ylabel('Histogram %')

hold off
suptitle('Uniform distribution [0,2]');

%% Case 3
mean=0.5;
sigma=0.1;

%d=linspace(mean -2*sigma,mean+2*sigma,20);
d=linspace(0,1,20);

f=@normalpdf;

h = pdf2hist(d, f);
 
 v=zeros(length(d)-1,1); 
   for i=1:length(d)-1 %defining intensity at the half of each interval
       v(i)=abs(d(i)+d(i+1))/2;
   end
 Y = histtransform(x, h, v);
        
 figure(3);
 subplot(1,2,1)
 imshow(Y);
 
 [hn , hx] = hist(Y(:), 0:1/255:1);
            
hn=100*hn/sum(hn); %making the histogram %
h=h*100;
        
subplot(1,2,2)
        
bar(hx , hn,2,'facecolor','b');
        

hold on;
stem(v,h,'LineWidth',1,'Color','r');
plot(v,h,'LineWidth',1,'Color','r');
xlim([min(v)-0.02,max(v)+0.02]);
set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
grid on;
xlabel('Intensity')
ylabel('Histogram %')
hold off
suptitle('Normal Distribution');
