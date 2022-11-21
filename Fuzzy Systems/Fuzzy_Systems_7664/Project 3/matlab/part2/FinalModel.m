 % Fuzzy Systems 2019 - Group 3 - Ser01
 % Stefanos Ganotakis 7664
 %training of final TSK Model
 
tic
%% CLEAR
clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n', mfilename);

%% READ DATA
load superconduct.csv



%% FINAL TSK MODEL
fprintf('\n *** TSK Model with 10 features and 12 rules- Fuzzy C-Means \n');

f = 10;
rules = 12;

%% SPLIT DATASET
fprintf('\n *** Dataset splitting\n');

training_data = superconduct(1 : round(0.6 * 21263), :); % 60% of the dataset is for training
validation_data = superconduct(round(0.6 * 21263) + 1 : round(0.8 * 21263), :); % 20% is for evaluation
check_data = superconduct(round(0.8 * 21263) + 1 : end, :); % 20% is for testing

%% NORMALIZE DATA
%training_data=2*mat2gray(training_data)-1;
%validation_data=2*mat2gray(validation_data)-1;
%check_data=2*mat2gray(check_data)-1;


[ranks, weights] = relieff(superconduct(:, 1:81), superconduct(:, end), 10);

training_data_x = training_data(:,ranks(1:f));
training_data_y = training_data(:,end);

validation_data_x = validation_data(:,ranks(1:f));
validation_data_y = validation_data(:,end);

check_data_x = check_data(:,ranks(1:f));
check_data_y = check_data(:,end);



%% MODEL WITH 10 FEATURES AND 12 RULES

% Generate the FIS
fprintf('\n *** Generating the FIS\n');


init_fis = genfis3(training_data_x, training_data_y,'sugeno', rules);

% Plot some input membership functions
figure;
for i = 1 : f
    [x, mf] = plotmf(init_fis, 'input', i);
    plot(x,mf);
    hold on;
end
title('Membership functions before training');
xlabel('x');
ylabel('Degree of membership');
saveas(gcf, 'mf_before_training.png');

figure;
[x, mf] = plotmf(init_fis, 'input', 1);
subplot(2,2,1);
plot(x,mf);
xlabel('input 1');

[x, mf] = plotmf(init_fis, 'input', 2);
subplot(2,2,2);
plot(x,mf);
xlabel('input 2');

[x, mf] = plotmf(init_fis, 'input', 3);
subplot(2,2,3);
plot(x,mf);
xlabel('input 3');

[x, mf] = plotmf(init_fis, 'input', 4);
subplot(2,2,4);
plot(x,mf);
xlabel('input 4');

suptitle('Final TSK model : some membership functions before training');
saveas(gcf, 'some_mf_before_training.png');

% Tune the fis
fprintf('\n *** Tuning the FIS\n');


nEpochs = 5;
trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
disOpt = [0, 0, 0, 0];

[trn_fis, trainError, stepSize, chkFIS, chkError] = anfis([training_data_x training_data_y], init_fis,  trnOpt, disOpt, [validation_data_x validation_data_y], 1);

% Evaluate the fis
fprintf('\n *** Evaluating the FIS\n');

output = evalfis(check_data_x, chkFIS);

%% METRICS
error = output - check_data_y;

mse = (1 / length(error)) * sum(error .^ 2);

rmse = sqrt(mse);

SSres = sum((check_data_y - output) .^ 2);
SStot = sum((check_data_y - mean(check_data_y)) .^ 2);
r2 = 1 - SSres / SStot;

nmse = var(error) / var(check_data_y);

ndei = sqrt(nmse);

% Plot the metrics
figure;
index = 1 : 4253;
plot([check_data_y(index) output])
title('Output');
legend('Reference Outputs','Model Outputs');
ylabel('Output');
xlabel('Time (sec)');
saveas(gcf,'output.png')

figure;
plot(error);
title('Prediction Errors');
saveas(gcf, 'Final_TSK_modelerror.png')

figure;
plot(1:length(trainError), trainError, 1:length(chkError), chkError);
title('Learning Curve');
legend('Traning Set', 'Check Set');
saveas(gcf, 'Final_TSK_modellearningcurves.png')

% Plot the input membership functions after training
figure;
for i = 1 : f
    [x, mf] = plotmf(chkFIS, 'input', i);
    plot(x,mf);
    hold on;
end
title('Membership functions after training');
xlabel('x');
ylabel('Degree of membership');
saveas(gcf, 'Final_TSK_modelmf_after_training.png');

figure;
[x, mf] = plotmf(chkFIS, 'input', 1);
subplot(2,2,1);
plot(x,mf);
xlabel('input 1');

[x, mf] = plotmf(chkFIS, 'input', 2);
subplot(2,2,2);
plot(x,mf);
xlabel('input 2');

[x, mf] = plotmf(chkFIS, 'input', 3);
subplot(2,2,3);
plot(x,mf);
xlabel('input 3');

[x, mf] = plotmf(chkFIS, 'input', 4);
subplot(2,2,4);
plot(x,mf);
xlabel('input 4');

suptitle('Final TSK model : some membership functions after training');
saveas(gcf, 'Final_TSK_modelafter.png');

fprintf('MSE = %f RMSE = %f R^2 = %f NMSE = %f NDEI = %f\n', mse, rmse, r2, nmse, ndei)

toc
