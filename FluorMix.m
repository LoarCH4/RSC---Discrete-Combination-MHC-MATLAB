function [gAverage] = FluorMix(num, channel, window)
%% Construct the filename matrix for reference
    % Generate a preset empty filename matrix to reduce operative memory
    csvNameMat = zeros(num,1);
    % Filling in the filename matrix with maximum number of labels.
    for i = 1:num
        csvNameMat(i,1) = i;
    end
    
%% Read the dataset for each item within the filename matrix
    % Generate preset empty averages and SD matrices to reduce operative memory
    AvgMat = zeros(num,1);
    StdMat = zeros(num,1);
    mixMat = zeros(num,1);
    % Data extraction of each file
    for j = 1:length(csvNameMat)
        % Add the csv. file suffix
        csvNameStr = [num2str(csvNameMat(j,1)),'.csv'];
        % Read the file
        RGBmat = readmatrix(csvNameStr);
        % Retrieve the pixel-axis of the dataset
        PP = RGBmat(:,1);
        P0 = PP(1);
        Pn = PP(length(PP));
        % Retrieve the RGB values of the dataset
        RR = RGBmat(:,2);
        GG = RGBmat(:,3);
        BB = RGBmat(:,4);
        % Compute the moving average of each RGB channel
        MMR = movmean(RR,window);
        MMG = movmean(GG,window);
        MMB = movmean(BB,window);
        % Calculate the mean and SD of each RGB channel
        Rmean = mean(MMR); Rsd = std(MMR);
        Gmean = mean(MMG); Gsd = std(MMG);
        Bmean = mean(MMB); Bsd = std(MMB);
        % Correspond the color channel required by the operator
        if channel == 'R'
            AvgMat(j,1) = Rmean;
            StdMat(j,1) = Rsd;
            mixMat(j,1) = Rsd ./ Rmean;
        elseif channel == 'G'
            AvgMat(j,1) = Gmean;
            StdMat(j,1) = Gsd;
            mixMat(j,1) = Gsd ./ Gmean;
        elseif channel == 'B'
            AvgMat(j,1) = Bmean;
            StdMat(j,1) = Bsd;
            mixMat(j,1) = Bsd ./ Bmean;
        else
            error('Please input the correct R.G.B. channel as an argument.')
        end
    end

%% Outputting setup

% Calculate the global average throughout the mean of moving averages of 
% RGB plots of each beads extracted
gAverage = mean(AvgMat);

% label the elements for output
labels = linspace(1,num,num)';
% Combine the label column and recorded data column
outputMat = [labels AvgMat StdMat mixMat];
% Export the combined dataset into an Excel file
writematrix(outputMat,'analysis.xlsx');

end