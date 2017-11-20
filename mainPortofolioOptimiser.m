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
date = Compound{:,1};

for i = 3:1:size
    price = Market{:,i};
    simple = Return{:,i};
    compound = Compound{:,i};
    name = char(Companies(i));
    
    %% Autocorrelation
    %Plots autocorrelation of compound returns and compound squared returns 
    %and computes the Ljung-Box Q-Test
    autocorrelation_ACF( compound, name );

    %% Histogram fit
    %Plots histograms of simple and compound returns fitted with Normal and 
    %tStudent distribution
    histogram_distribution_fit( simple, compound, name );

    %% Identification of fat tails
    %Plots t distribution againts data
    Fat_Tails( simple, name );
    
    %%GARCH Test
    %%plots returns over time and conditional volatility
    volGarch(date, price, compound);
end



