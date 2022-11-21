% Fuzzy Systems 2019 - Group 4 - Ser07
% Stefanos Ganotakis 7664
% Classification with TSK models
% Isolet  dataset from UCI repository
tic
%% CLEAR
%clear all;
close all;

%% BEGIN
fprintf('\n *** begin %s ***\n\n', mfilename);

%% READ DATA
load isolet.dat;
data = isolet;
%sort dataset by output 
NF = [4 6 8 10]; % number of features
NR = [4 6 8 10 12]; % number of rules

error_grid = zeros(length(NF), length(NR));
rule_grid = zeros(length(NF), length(NR));

%% SPLIT DATASET
fprintf('\n *** Dataset splitting\n');
outputs=cell(1,26);

training_data=[];
validation_data=[];
check_data=[];

%create cell matrix with output
for i=1:26
    outputs{i}=data(data(:, 618) == i, :);
end


%split  data with even distribution
for i=1:26
    chunk=outputs{i};
training_data = [training_data ; chunk(1 : round(0.6 * size(chunk,1)), :)]; % 60% of the dataset is for training
validation_data = [validation_data ; chunk(round(0.6 * size(chunk,1)) + 1 : round(0.8 * size(chunk,1)), :)]; % 20% is for evaluation
check_data = [check_data ; chunk(round(0.8 * (size(chunk,1))) + 1 : end, :)]; % 20% is for testing
end

%% INITIALIZATIONS
% These arrays will be used for keeping the metrics for the different
% models
error_matrices = cell(1, length(NR)); % Contains 4 7x7 arrays
overall_acc = zeros(1, length(NR));
producers_acc = cell(1, length(NR));
users_acc = cell(1, length(NR));
k = zeros(1, length(NR));

% Keep only the number of features we want and not all of them
% Specify their order and later use the ranks array
[ranks, weights] = relieff(data(:, 1:end-1), data(:, end), 10);

% Check every case for every parameter possible
% For every different case we will save the result in the array parameters
for f = 1 : length(NF)

    for r = 1 : length(NR)
        fprintf('\n *** Number of features: %d', NF(f));
        fprintf('\n *** Radii value: %d \n', NR(r));


        % Split the data to make folds and create an array to save the
        % error in each fold
        c = cvpartition(training_data(:, end), 'KFold', 5);
        error = zeros(c.NumTestSets, 1);

        % Generate the FIS
        fprintf('\n *** Generating the FIS\n');

        % 5-fold cross validation
        for i = 1 : c.NumTestSets
            fprintf('\n *** Fold #%d\n', i);

            train_id = c.training(i);
            test_id = c.test(i);

            % Keep separate
            training_data_x = training_data(train_id, ranks(1:NF(f)));
            training_data_y = training_data(train_id, end);

            validation_data_x = training_data(test_id, ranks(1:NF(f)));
            validation_data_y = training_data(test_id, end);
            
            init_fis = genfis3(training_data_x,training_data_y,'sugeno',NR(r)) ;
            % Tune the fis
            fprintf('\n *** Tuning the FIS\n');
            
             nEpochs = 100;
            trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
            disOpt = [0, 0, 0, 0];
            [trn_fis, trainError, stepSize, init_fis, chkError] = anfis([training_data_x training_data_y], init_fis,  trnOpt, disOpt, [validation_data_x validation_data_y], 1);

            % Evaluate the fis
            fprintf('\n *** Evaluating the FIS\n');
            output = evalfis(validation_data(:, ranks(1:NF(f))), init_fis);

            % Calculate the error
            error(i) = sum((output - validation_data(:, end)) .^ 2);
           

        end

        cvErr = sum(error) / c.NumTestSets; % 5-fold mean error
        error_grid(f, r) =  error_grid(f,r) + min(chkError)/c.NumTestSets
        error_grid(f,r)
    end
end

fprintf('Plotting and calculating optimal feature-rule combination...');

%% PLOT THE ERROR

figure;
suptitle('Error for different number of features and rules');

subplot(2,2,1);
bar(error_grid(1,:))
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'4','6','8','10','12'}])
legend('4 features')

subplot(2,2,2);
bar(error_grid(2,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'4','6','8','10','12'}])
legend('6 features')

subplot(2,2,3);
bar(error_grid(3,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'4','6','8','10','12'}])
legend('8 features')

subplot(2,2,4);
bar(error_grid(4,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'4','6','8','10','12'}])
legend('10 features')
saveas(gcf, 'error_grid_wrg_f_r.png');

%find optimal feature-rule combination
[minval,idx]=min(error_grid(:));
[row,col]=ind2sub(size(error_grid),idx);
fprintf('\n *** Minimum MSE value: %d for %d features and %d rules', minval,NF(row),NR(col));
