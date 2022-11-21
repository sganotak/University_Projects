% Fuzzy Systems 2019 - Group 4 - Ser07 part 1
% Stefanos Ganotakis 7664

tic
%% CLEAR
clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n', mfilename);

%% READ DATA
load avila.txt
data = avila;
%sort dataset by output 
[~,idx] = sort(data(:,11));
data = data(idx,:);
RADII = [0.2 0.21 0.218 0.22 0.28];
%% SPLIT DATASET
fprintf('\n *** Dataset splitting\n');

training_data = zeros(12521, 11); % 60% of the dataset is for training
validation_data = zeros(4173, 11); % 20% is for evaluation
check_data = zeros(4173, 11); % 20% is for testing

% Split Dataset with even distribution
    k=1;
    l=1;
    m=1;
   for i = 1:size(data,1)
       if (mod(i-1,5)<=2)
           training_data(k,:) = data(i,:);
           k=k+1;
       end
       if (mod(i-1,5) == 3)
           validation_data(l,:) = data(i,:);
           l=l+1;
       end 
       if (mod(i-1,5) == 4)
           check_data(m,:) = data(i,:);
           m=m+1;
       end 
   end
   
   %% NORMALIZE DATA
% Normalize each set differently so that they are separated through the
% whole process
for i = 1 : size(training_data,2)-1
    training_data_min = min(training_data(:,i));
    training_data_max = max(training_data(:,i));
    training_data(:,i) = (training_data(:,i) - training_data_min) / (training_data_max - training_data_min); % Scaled to [0, 1]
    training_data(:,i) = training_data(:,i) * 2 - 1; % Scaled to [-1, 1]

    validation_data(:,i) = (validation_data(:,i) - training_data_min) / (training_data_max - training_data_min); % Scaled to [0, 1]
    validation_data(:,i) = validation_data(:,i) * 2 - 1; % Scaled to [-1, 1]

    check_data(:,i) = (check_data(:,i) - training_data_min) / (training_data_max - training_data_min); % Scaled to [0, 1]
    check_data(:,i) = check_data(:,i) * 2 - 1; % Scaled to [-1, 1]
end

%% SHUFFLE DATA
shuffled_data = zeros(size(training_data));
rand_pos = randperm(length(training_data));
for k = 1 : length(training_data)
    shuffled_data(k, :) = training_data(rand_pos(k), :);
end
training_data = shuffled_data;

shuffled_data = zeros(size(validation_data));
rand_pos = randperm(length(validation_data));
% new array
for k = 1 : length(validation_data)
    shuffled_data(k, :) = validation_data(rand_pos(k), :);
end
validation_data = shuffled_data;

shuffled_data = zeros(size(check_data));
rand_pos = randperm(length(check_data));
% new array
for k = 1 : length(check_data)
    shuffled_data(k, :) = check_data(rand_pos(k), :);
end
check_data = shuffled_data;


 

   %% INITIALIZATIONS
% These arrays will be used for keeping the metrics for the different
% models
error_matrices = cell(1, length(RADII)); % Contains 5 10x10 arrays
overall_acc = zeros(1, length(RADII));
producers_acc = cell(1, length(RADII));
users_acc = cell(1, length(RADII));
k = zeros(1, length(RADII));

for r = 1:length(RADII)
    fprintf('\n *** Train TSK Model %d \n', r);
     fprintf('\n *** Generating the FIS\n');
     init_fis = genfis2(training_data(:, 1:10), training_data(:, 11),RADII(r));
     rules = length(init_fis.rule)
    
   
% plot input mf
    figure;
    for i = 1 : 10
        [x, mf] = plotmf(init_fis, 'input', i);
        plot(x, mf);
        hold on;
    end
title(['TSK model ', num2str(r), ': Input MF before training']);
    xlabel('x');
    ylabel('Degree of membership');
    name=['mfbefore',num2str(r),'.png'];
    saveas(gcf, name);
    
   % Tune the fis
    fprintf('\n *** Tuning the FIS\n');
    nEpochs = 100;
    trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
    disOpt = [0, 0, 0, 0];
    [trn_fis, trainError, stepSize, chkFIS, chkError] = anfis(training_data, init_fis,  trnOpt, disOpt, validation_data, 1);  
    
    output = evalfis(check_data(:, 1:10), chkFIS);
 
    output = round(output); % Round to the nearest integer to create a constant output for classifying
    
    output(output < 1) = 1;
    output(output > 12) = 12;
 
    %% METRICS
    N = length(check_data); %total number of classified values compared to truth values
 
    % Error matrix
    error_matrices{r} = confusionmat(check_data(:, 11), output);
    % Columns are truth, rows are predicted values
 % Overall accuracy
    error_matrix = error_matrices{r};
    for i = 1 : 12
        overall_acc(r) = overall_acc(r) + error_matrix(i, i);
    end
    overall_acc(r) = overall_acc(r) / N;
    
    
    % Producer's and user's accuracy
    % probability that a value in a given class was classified correctly
    pa = zeros(1, 12);
    % probability that a value predicted to be in a certain class really is that class
    ua = zeros(1, 12);
 
    for i = 1 : 12
        pa(i) = error_matrix(i, i) / sum(error_matrix(:, i));
        ua(i) = error_matrix(i, i) / sum(error_matrix(i, :));
    end
    producers_acc{r} = pa;
    users_acc{r} = ua;
    
    pe=0;
    for i = 1:12
    pe = pe+ sum(error_matrix(i, :)) * sum(error_matrix(:, i)) / N ^ 2;
    end 
    k(r) = (overall_acc(r) - pe) / (1 - pe);
    
    % Plot the input membership functions after training
    figure;
    for i = 1 : 10
        [x, mf] = plotmf(chkFIS, 'input', i);
        plot(x, mf); 
        xlim([-1 1])
        hold on;
    end
    title(['TSK model ', num2str(r), ': Input MF after training']);
    xlabel('x');
    ylabel('Degree of membership');
    name=['mfafter',num2str(r),'.png'];
    saveas(gcf, name);
    
    figure;
    plot(1:length(trainError), trainError, 1:length(trainError), chkError);
    title(['TSK model ', num2str(r), ': Learning Curve']);
    xlabel('iterations');
    ylabel('Error');
    legend('Training Set', 'Check Set');
    name=['learningcurve',num2str(r),'.png'];
    saveas(gcf, name);
end

    