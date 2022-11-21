%Project for Digital Image Processing Course
%Point Transform/Histogram Transform
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664

%demo 2: Histogram Transform

clear all
close all


% Load image , and convert it to gray -scale
 x = imread('lena.bmp');
 x = rgb2gray(x);
 x = double(x) / 255;
 
%% Case 1
 L = 10;
 v = linspace (0, 1, L);
 h = ones([1, L]) / L;
 
 Y = histtransform(x, h, v);
        
 figure(1);
 subplot(1,2,1)
 imshow(Y);
 
 
 [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
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
  hold off;
  suptitle('Case 1 : Uniform distribution [0,1]');
 
%% Case 2
 L = 20;
 v = linspace (0, 1, L);
 h = ones([1, L]) / L;
 
 Y = histtransform(x, h, v);
        
 figure(2);
 subplot(1,2,1)
 imshow(Y);
 %suptitle('Case 1 : Uniform distribution [0,1]');
 
 [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
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
  hold off;
  suptitle('Case 2 : Uniform distribution [0,1]');
  
%% Case 3
 L = 10;
 v = linspace (0, 1, L);
 h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));
 
 Y = histtransform(x, h, v);
        
 figure(3);
 subplot(1,2,1)
 imshow(Y);
 
 [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
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
  hold off;
  suptitle('Case 3 : Normal distribution mean=0.5 standard deviation=1');