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
size = length(Companies); %counts the number of columns (it includes date and index columns)

%we decide now what we want to plot
plotAutocorr = false;
doHistogramFit = false;
plotFatTails = false;
plotHeuristicTest = false;

%% Market Analysis
[iid, Rho, nu, marginals, GARCHprop] = MarketAnalysis(Compound, plotAutocorr, doHistogramFit, plotFatTails, plotHeuristicTest);

%% Marginal Projection
NDaysProjection = 7;
NCompanies = size - 2;
lastPrices = Market{1,3:end};
projectedPrices = Projection(NDaysProjection, NCompanies, Rho, nu, marginals, lastPrices); 

%% Optimisation
exp_prices = mean(projectedPrices);      %mean of all observations from Monte Carlo
inv_diag_lastPrices = inv(diag(lastPrices));  %inverse diagonal matrix of last prices 
                                        % to calculate the variance of linear returns
                                        
%expected value of linear returns from 6.89 Meucci
exp_lin_return = exp_prices./lastPrices - 1;

%variance-covariance matrix of linear returns from 6.90 Meucci 
var_prices = cov(projectedPrices);
var_lin_return = inv_diag_lastPrices * var_prices * inv_diag_lastPrices;
std_devs = sqrt(diag(var_lin_return));

%selecting N short and N long
Nshort = 2;
[B,I] = sort(exp_lin_return);
%exp_lin_return(I(1:Nshort)) = -1*exp_lin_return(I(1:Nshort))
A=ones(1,NCompanies);
A(I(1:Nshort)) = -1*A(I(1:Nshort));
%A(2,:) = -A(1,:)
b=1;

lb = -(A < 0);
ub = +(A > 0);
%lb = -(A(1,:) < 0)
%ub = +(A(2,:) < 0)


%efficient frontier
p = Portfolio('assetmean', exp_lin_return, 'assetcovar', var_lin_return);
p = Portfolio(p, 'lowerbound', lb, 'upperbound', ub);
if exist('currentPortfolio.mat') ~= 0
    load('currentPortfolio.mat');
    p = setInitPort(p, maxSharpRatio_portfolio);
end
%load('current_portfolio', old_portfolio)
p = setEquality(p, A, b);
%p = setInequality(p, A, b)
maxSharpRatio_portfolio = estimateMaxSharpeRatio(p)
%save currentPortfolio.mat maxSharpRatio_portfolio