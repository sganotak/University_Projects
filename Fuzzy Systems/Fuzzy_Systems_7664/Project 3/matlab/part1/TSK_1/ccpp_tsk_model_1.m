% Fuzzy Systems 2019 - Group 3 - Ser01
% Stefanos Ganotakis 7664
% Regression with TSK models 

tic
%% CLEAR
clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n',mfilename);

%% READ DATA
load CCPP.dat


%% SPLIT DATASET
fprintf('\n *** Dataset splitting\n');



training_data = CCPP(1 : round(0.6*9568), :); % 60% of the dataset is for training
validation_data = CCPP(round(0.6*9568)+1 : round(0.8 * 9568), :); % 20% is for evaluation
check_data = CCPP(round(0.8*9568)+1 : end, :); % 20% is for testing

%% NORMALIZE DATA
% Normalize each set differently so that they are separated through the
% whole process
training_data=2*mat2gray(training_data)-1;
validation_data=2*mat2gray(validation_data)-1;
check_data=2*mat2gray(check_data)-1;
%% TRAIN TSK MODEL

%% MODEL 1  - 2 MF - SINGLETON OUTPUT
fprintf('\n *** TSK Model 1\n');

% Generate the FIS
fprintf('\n *** Generating the FIS\n');

init_fis = genfis1(training_data, 2, 'gbellmf', 'constant');

% Plot the input membership functions
figure;
[x,mf] = plotmf(init_fis,'input',1);
subplot(2,2,1);

plot(x,mf);
xlabel('input 1 (gbellmf)');

[x,mf] = plotmf(init_fis,'input',2);
subplot(2,2,2);
plot(x,mf);
xlabel('input 2 (gbellmf)');

[x,mf] = plotmf(init_fis,'input',3);
subplot(2,2,3);
plot(x,mf);
xlabel('input 3 (gbellmf)');

[x,mf] = plotmf(init_fis,'input',4);
subplot(2,2,4);
plot(x,mf);
xlabel('input 4 (gbellmf)');

suptitle('TSK model 1 : membership functions before training');
saveas(gcf, 'mf_before_training.png');

% Tune the fis
fprintf('\n *** Tuning the FIS\n');
% Set some options
% The fis structure already exists
% set the validation data to avoid overfitting
% display training progress information
nEpochs = 100;
trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
disOpt = [0, 0, 0, 0];
[trn_fis, trainError, stepSize, chkFIS, chkError] = anfis(training_data, init_fis,  trnOpt, disOpt, validation_data, 1);
% Evaluate the fis
fprintf('\n *** Evaluating the FIS\n');
% No need to specify specific options for this, keep the defaults
output = evalfis(check_data(:,1:4),chkFIS);

%% METRICS
error = output - check_data(:,5);

mse = (1/length(error)) * sum(error.^2);

rmse = sqrt(mse);

SSres = sum( (check_data(:,5) - output).^2 );
SStot = sum( (check_data(:,5) - mean(check_data(:,5))).^2 );
r2 = 1 - SSres / SStot;

nmse = var(error) / var(check_data(:,5));

ndei = sqrt(nmse);

% Plot the metrics
figure;
index = 1 : 1914;
plot([check_data(index,5) output])
title('Output');
legend('Reference Outputs','Model Outputs');
ylabel('Output');
xlabel('Time (sec)');
saveas(gcf,'output.png')

figure;
plot(error);
ylabel('e(t)');
xlabel('Time (sec)');
title('Prediction Errors');
saveas(gcf,'error.png')

figure;
plot(1:length(trainError),trainError,1:length(trainError),chkError);
title('Learning Curve');
ylabel('RMSE');
xlabel('Epochs');
legend('Training Set', 'Check Set');
saveas(gcf,'learningcurves.png')

% Plot the input membership functions after training
figure;
[x,mf] = plotmf(chkFIS,'input',1);
subplot(2,2,1);

plot(x,mf);
xlabel('input 1');

[x,mf] = plotmf(chkFIS,'input',2);
subplot(2,2,2);
plot(x,mf);
xlabel('input 2');

[x,mf] = plotmf(chkFIS,'input',3);
subplot(2,2,3);
plot(x,mf);
xlabel('input 3');

[x,mf] = plotmf(chkFIS,'input',4);
subplot(2,2,4);
plot(x,mf);
xlabel('input 4');

suptitle('TSK model 1 : membership functions after training');
saveas(gcf, 'mf_after_training.png');


fprintf('MSE = %f RMSE = %f R^2 = %f NMSE = %f NDEI = %f\n', mse, rmse, r2, nmse, ndei)

toc

