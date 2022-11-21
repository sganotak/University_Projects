% Fuzzy Systems 2019 - Group 1 - T5
% Stefanos Ganotakis 7664
% Linear PI controller

%% CLEAR
clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n',mfilename);

%% INITIALIZE

% Gc(s)
c=0.2;
numc = [1 c];
denc = [1 0];
gc = tf(numc, denc);

% Gp(s)
nump =25;
denp = [1 10.1 1];
gp = tf(nump, denp);

% Open loop system
sys_open_loop = series(gc, gp);

% Create the root locus plot
figure;
rlocus(sys_open_loop)
saveas(gcf, 'rootlocus.png');

% Closed loop system
K = 2;
sys_open_loop = K * sys_open_loop; % We have chosen K
sys_closed_loop = feedback(sys_open_loop, 1, -1);

figure;
step(sys_closed_loop);
saveas(gcf, 'closed_loop_sys.png');
info = stepinfo(sys_closed_loop);
disp(['Rise time (LPI): ' num2str(info.RiseTime) 's']);
disp(['Overshoot (LPI): ' num2str(info.Overshoot) '%']);

if info.RiseTime > 0.6
    fprintf('Rise Time is : %d. Try another value.\n',info.RiseTime);
end
if info.Overshoot > 8
    fprintf('Overshoot is : %d. Try another value.',info.Overshoot);
end

fprintf('\n *** %s has finished ***\n\n',mfilename);