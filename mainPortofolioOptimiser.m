%--------------------------------------------------------------------------
% Portfolio Optimiser main script
%--------------------------------------------------------------------------

%% Libraries
addpath('functions');

%% Data
%Reads data from database
Market = readtable('DB/Market_Data.csv');
Compound = readtable('DB/Market_Data_CR.csv');
Return = readtable('DB/Market_Data_NR.csv');

%cleans data from NaN values
R = height(Market); %gives the number of rows
Compound(R,:) = []; %Last day does not have any return value 
Return(R,:)   = []; %and therefore deleted
Dcolumns = find( sum(ismissing(Compound)) > 0 ); %Find columns that have NaN values
Compound(:,Dcolumns) = []; %deletes columns with NaN values
Market(:,Dcolumns) = [];   % "                           "
Return(:,Dcolumns) = [];   % "                           "

%https://uk.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%to learn how to access data 

Companies = Market.Properties.VariableNames; %creates a vector of cells with companies tickers
size = length(Companies); %counts the number of columns left

%% Autocorrelation
%Plots autocorrelation of compound returns and compound squared returns 
%and computes the Ljung-Box Q-Test
autocorrelation_ACF( Compound, size, Companies );

%% Histogram fit
%Plots histograms of simple and compound returns fitted with Normal and 
%tStudent distribution
histogram_distribution_fit( Return, Compound, size, Companies );

%% Identification of fat tails
%Plots t distribution againts data for each company
Fat_Tails( Return, size, Companies );




