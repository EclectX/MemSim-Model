% This MATLAB script plots a histogram of the output data of FELIX-OR logic exported from LTspice in .txt format.

clc;            % Clear the command window
clear all;      % Clear all variables from the workspace
close all;      % Close all figure windows

% Specify the input data file from LTspice
filename = ['up_Felix_11_0.66.txt']; % SDC: FELIX gate output data representing the state of the memristor (out)

%%%%%%%%%%% File Reading and Storing Data in Numeric Format %%%%%%%%%%%

% Open the file
fileID = fopen(filename, 'r');  % Open the file in read mode

% Initialize variables
simulation_runs = {};  % Cell array to store data for each simulation run
current_run_data = [];  % Array to store data for the current run
run_index = 1;  % Index to track different simulation runs

% Read the file line by line
while ~feof(fileID)  % Continue reading until the end of the file
    line = fgetl(fileID);  % Read a line from the file

    % Detect the start of a new simulation run
    if startsWith(line, 'Step Information')  
        % Save the current run data before starting a new run
        if ~isempty(current_run_data)
            simulation_runs{run_index} = current_run_data;  % Store data
            run_index = run_index + 1;  % Move to the next run
            current_run_data = [];  % Reset data storage for the new run
        end
    elseif ~isempty(line)
        % Convert the line text into numerical values
        numerical_values = sscanf(line, '%f');  
        current_run_data = [current_run_data; numerical_values'];  % Append to current run data
    end
end

% Store the last run's data if available
if ~isempty(current_run_data)
    simulation_runs{run_index} = current_run_data;
end

% Close the file
fclose(fileID);  % Ensure the file is properly closed after reading

%%%%%%%%%%% Data Processing %%%%%%%%%%%

num_simulation_runs = length(simulation_runs);  % Count the total simulation runs
state_means = [];  % Initialize an array to store the mean state values per run

% Process each simulation run
for i = 1:num_simulation_runs
    % Extract time and output voltage values
    time_values = simulation_runs{i}(:, 1);  % First column: Time
    output_values = simulation_runs{i}(:, 2);  % Second column: Output values

    % Apply a time threshold to filter valid data points
    valid_indices = time_values > 0.6e-3;  % Consider data beyond 0.6ms (for SDC_FELIX case)

    % Extract output values that meet the time condition
    filtered_output_values = output_values(valid_indices);

    % Compute the mean of the selected output values
    state_means(i, 1) = mean(filtered_output_values);
end

%%%%%%%%%%% Histogram Plot %%%%%%%%%%%

figure;
histogram(state_means, 26);  % Plot histogram with 26 bins
xlim([0, 1]);  % Set x-axis limits between 0 and 1
xlabel('State', 'FontSize', 22);  % X-axis label
ylabel('Occurrence', 'FontSize', 22);  % Y-axis label
title('Inputs 10, V_{cond.}=0.85V, R_{G}=70kΩ', 'FontSize', 18);  % Histogram title
xticks(0.1:0.1:1);  % Set x-axis tick marks
set(gca, 'FontSize', 18);  % Adjust axis label font size
box on;  % Display a box around the plot

%%%%%%%%%%% Logical State Classification %%%%%%%%%%%

% Logical Mapping I: Low (0 < s < 0.5), High (0.5 < s < 1)
LM1_high = sum(state_means > 0.5);  % Count values greater than 0.5
LM1_low = length(state_means) - LM1_high;  % Compute the remaining count

% Logical Mapping II: More Strict Boundaries (Low: 0 < s < 0.45, High: 0.55 < s < 1)
LM2_low = sum(state_means < 0.45);  % Count values less than 0.45
LM2_high = sum(state_means > 0.55);  % Count values greater than 0.55

% Logical Mapping III: Medium Boundaries (Low: 0 < s < 0.33, High: 0.67 < s < 1)
LM3_low = sum(state_means < 0.33);  % Count values less than 0.33
LM3_high = sum(state_means > 0.67);  % Count values greater than 0.67

% Logical Mapping IV: Extreme Boundaries (Low: 0 < s < 0.3, High: 0.7 < s < 1)
LM4_low = sum(state_means < 0.3);  % Count values less than 0.3
LM4_high = sum(state_means > 0.7);  % Count values greater than 0.7
