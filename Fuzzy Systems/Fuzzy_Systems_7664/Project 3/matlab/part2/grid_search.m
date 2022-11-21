% Fuzzy Systems 2018 - Group 3 - Ser01
% Stefanos Ganotakis 7664

%% CLEAR
clear all;
close all;
tic
%% BEGIN
fprintf('\n *** begin %s ***\n\n', mfilename);
 
%% READ DATA
load superconduct.csv

NF = [5 10 12 15]; % number of features
% number of rules
NR=[5 8 10 12 14 ];

error_grid = zeros(length(NF), length(NR));


%% SPLIT DATASET
fprintf('\n *** Dataset splitting\n');

training_data = superconduct(1 : round(0.6 * 21263), :); % 60% of the dataset is for training
validation_data = superconduct(round(0.6 * 21263) + 1 : round(0.8 * 21263), :); % 20% is for evaluation
check_data = superconduct(round(0.8 * 21263) + 1 : end, :); % 20% is for testing



%% GRID SEARCH & 5-fold cross validation
fprintf('\n *** Cross validation \n');

% Keep only the number of features we want and not all of them
% Specify their order and later use the ranks array
[ranks, weights] = relieff(superconduct(:, 1:end - 1), superconduct(:, end), 10);

% Check every case for every parameter possible
% For every different case we will save the result in the array parameters
for f = 1 : length(NF)
 
    for r = 1 : length(NR)
        fprintf('\n *** Number of features: %d', NF(f));
        fprintf('\n *** Number of Rules: %d \n', NR(r));
     
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
         
            init_fis = genfis3(training_data_x, training_data_y,'sugeno', NR(r));
            % Tune the fis
            fprintf('\n *** Tuning the FIS\n');
         
            
            nEpochs = 5;
            trnOpt = [nEpochs, NaN, NaN, NaN, NaN];
            disOpt = [0, 0, 0, 0];
            [trn_fis, trainError, stepSize, init_fis, chkError] = anfis([training_data_x training_data_y], init_fis,  trnOpt, disOpt, [validation_data_x validation_data_y], 1);

         
            % Evaluate the fis
            fprintf('\n *** Evaluating the FIS\n');
         
            output = evalfis(check_data(:, ranks(1:NF(f))), init_fis);

            % Calculate the error
            error(i) = sum((output - check_data(:, end)) .^ 2);
            
        end
     
        cvErr = sum(error) / c.NumTestSets;
        error_grid(f, r) = sqrt(cvErr/ length(output)) 
 
    end
end


%% PLOT THE ERROR
fprintf('The error for diffent values of F and R is:');
error_grid

%% PLOT

fprintf('Plotting and calculating optimal feature-rule combination...');

figure;
suptitle('Error for different number of features and rules');

subplot(2,2,1);
bar(error_grid(1,:))
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'5 ','8','10 ','12','15'}])
legend('5 features')

subplot(2,2,2);
bar(error_grid(2,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'5  ','8','10 ','12','15'}])
legend('10 features')

subplot(2,2,3);
bar(error_grid(3,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'5  ','8','10  ','12','15'}])
legend('12 features')

subplot(2,2,4);
bar(error_grid(4,:));
xlabel('Number of Rules');
ylabel('Mean Square Error');
set(gca,'XTickLabel',[{'5  ','8','10  ','12','15'}])
legend('15 features')
saveas(gcf, 'error_grid_wrg_f_r.png');

[minval,idx]=min(error_grid(:));
[row,col]=ind2sub(size(error_grid),idx);
fprintf('\n *** Minimum MSE value: %d for %d features and %d rules', minval,NF(row),NR(col));

toc