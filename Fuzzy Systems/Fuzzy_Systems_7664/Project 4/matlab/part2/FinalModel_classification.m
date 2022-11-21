% Fuzzy Systems 2019 - Group 4 - Ser07
% Stefanos Ganotakis 7664
% Classification with TSK models
% Isolet  dataset from UCI repository
% Training of final TSK Model

tic
%% CLEAR
%clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n', mfilename);

%% READ DATA
load isolet.dat;
data = isolet;
f=6;
r=6;
outputs=cell(1,26);

training_data=[];
validation_data=[];
check_data=[];

first_split=zeros(26,1);
second_split=zeros(26,1);

%create cell array with outputs
for i=1:26
    outputs{i}=data(data(:, 618) == i, :);
end

%Split Dataset with even distribution
for i=1:26
% Flags for the index of separating between the sets
first_split(i) = round(0.6 * size(outputs{i},1));
second_split(i) = round(0.8 * size(outputs{i},1));
end

for i=1:26
training_data=[training_data; outputs{i}(1:first_split(i),:)];
validation_data=[validation_data; outputs{i}(first_split(i) + 1:second_split(i), :)];
check_data=[check_data; outputs{i}(second_split(i) + 1:end, :)];
end

% Shuffle the data
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


[ranks, weights] = relieff(data(:, 1:end-1), data(:, end), 10);

training_data_x = training_data(:, ranks(1:f));
training_data_y = training_data(:, end);

validation_data_x = validation_data(:, ranks(1:f));
validation_data_y = validation_data(:, end);

check_data_x = check_data(:, ranks(1:f));
check_data_y = check_data(:, end);


    fprintf('\n *** Train TSK Model %d \n', r);
     fprintf('\n *** Generating the FIS\n');
     init_fis = genfis3(training_data_x,training_data_y,'sugeno',r);
    
    for m = 1 : length(init_fis.output.mf)
        init_fis.output.mf(m).type = 'constant';
      init_fis.output.mf(m).params = rand(); % range [-5, 5]
    end

% plot input mf
    figure;
    for i = 1 : f
        [x, mf] = plotmf(init_fis, 'input', i);
        plot(x, mf);
        hold on;
    end
title(['TSK model ',num2str(f),' features ', num2str(r),' rules: Input MF before training']);
    xlabel('x');
    ylabel('Degree of membership');
    saveas(gcf, 'mfbefore.png');
    
   % Tune the fis
    fprintf('\n *** Tuning the FIS\n');
    nEpochs = 100;
    trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
    disOpt = [0, 0, 0, 0];
    [trn_fis, trainError, stepSize, chkFIS, chkError] = anfis([training_data_x training_data_y], init_fis,  trnOpt, disOpt, [validation_data_x validation_data_y], 1);  
    
    output = evalfis(check_data_x, chkFIS);
 
    output = round(output); % Round to the nearest integer to create a constant output for classifying
    
   
    output(output < 1) = 1;
    output(output > 26) = 26;
 
    %% METRICS
    N = length(check_data); %total number of classified values compared to truth values

    % Error matrix
    error_matrix = confusionmat(check_data_y, output)
    % Columns are truth, rows are predicted values

    % Overall accuracy
    overall_acc = 0;
    for i = 1 : 26
    overall_acc = overall_acc + error_matrix(i, i);
    end
    overall_acc = overall_acc / N;

    
    % Producer's and user's accuracy
    % probability that a value in a given class was classified correctly
    pa = zeros(1, 26);
    % probability that a value predicted to be in a certain class really is that class
    ua = zeros(1, 26);
 
    for i = 1 : 26
        pa(i) = error_matrix(i, i) / sum(error_matrix(:, i));
        ua(i) = error_matrix(i, i) / sum(error_matrix(i, :));
    end
    
    
    pe=0;
    for i = 1:26
    pe = pe+ sum(error_matrix(i, :)) * sum(error_matrix(:, i)) / N ^ 2;
    end 
    k = (overall_acc - pe) / (1 - pe);
    
    % Plot the input membership functions after training
    figure;
    for i = 1 : f
        [x, mf] = plotmf(chkFIS, 'input', i);
        plot(x, mf);
        hold on;
    end
    title(['TSK model ',num2str(f),' features ', num2str(r),' rules: Input MF after training']);
    xlabel('x');
    ylabel('Degree of membership');
    saveas(gcf, 'mfafter.png');
    
    figure;
    plot(1:length(trainError), trainError, 1:length(trainError), chkError);
    title(['TSK model ',num2str(f),' features ', num2str(r),' rules : Learning Curve']);
    xlabel('iterations');
    ylabel('Error');
    legend('Training Set', 'Check Set');
    saveas(gcf, 'learning_curve.png');


    