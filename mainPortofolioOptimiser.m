%--------------------------------------------------------------------------
% Portfolio Optimiser main script
%--------------------------------------------------------------------------
clear all, close all
%% Libraries
addpath('functions');
addpath('functions/Heuristic_test_sub_functions')

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
Companies = Compound.Properties.VariableNames; %creates a vector of cells with companies tickers
size = length(Companies); %counts the number of columns left (number of companies)

%we decide now what we want to plot
plotAutocorr = false;
doHystogramFit = false;
plotFatTails = false;
plotHeuristicTest = false;

%% Market Analysis
[iid, Rho, nu, marginals, GARCHprop] = MarketAnalysis(Compound, plotAutocorr, doHystogramFit, plotFatTails, plotHeuristicTest);

%% Marginal Projection

%%day 

g = zeros(1000, 4)
for i = 1 : 7
day = marginal_projection(Rho, nu, size, marginals)
g = g + day
end 

P = Price_Project(Market, g,size) ;    

%% Mean-Variance

%Calculate expected Future Prices 
expPrices = ExpectedValues(size, P) ;
 
% %Use expected prices and last price to calculate expected return.
Projected_Compound = ExpectedReturn(Market,expPrices, size) ;
% 
% %Calculate horizon price covariance matrix
Var_Price = cov(P);
% 
% %Find standard deviations from covariance matrix
std_devs = sqrt(diag(Var_Price)) ;
% 
Exp_Portfolio = EfficientFrontier_return(Projected_Compound);
Portfolio_sd = EfficientFrontier_sd(Var_Price);
Sharpe_Ratio = Sharpe_R(Exp_Portfolio,Portfolio_sd);

% Find the maximum Sharpe ratio value out of the data and find y values to
% plot on the efficient frontier
M = max(Sharpe_Ratio);
x = 0:0.1:1
y = M*x

% Plot the max Sharpe ratio against the efficient frontier
plot(Portfolio_sd,Exp_Portfolio,'*'); hold on ;
ylabel('Rate of Return')
xlabel('Risk')
plot(x,y, 'color', 'b');
% 
