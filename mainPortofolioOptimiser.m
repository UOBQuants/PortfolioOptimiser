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
%shortlongcomb = readtable('DB/ShortLong4c.csv');

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
plotFront = true;

%% ************************   SAVE PORTFOLIO   **************************** 
savePortfolio = true;
% savePortfolio should be true only when we run the program to definitely 
% update our portfolio, so just at the beginning/end of the week in order
% to update for the next week.
% ******** savePortfolio is FALSE during the week *********

%% Market Analysis
[iid, Rho, nu, marginals, GARCHprop] = MarketAnalysis(Compound, plotAutocorr, doHistogramFit, plotFatTails, plotHeuristicTest);

%% Marginal Projection
NDaysProjection = 7;
NCompanies = size - 2;
lastPrices = Market{1,3:end};
projectedPrices = Projection(NDaysProjection, NCompanies, Rho, nu, marginals, lastPrices); 

%% Optimisation
%first calculates expected vector and covariance matrix for total returns
[exp_lin_return, var_lin_return] = priceToLinear(projectedPrices, lastPrices);

[InitHold,Wealth,InitP] = setInitialData(lastPrices,NCompanies);

%matlab Portfolio object uses Markowitz model for portfolio optimisation
%computations
[p, sharp_ratio, SR_pwgt, pbuy, psell] = Optimisation(InitP, exp_lin_return, var_lin_return, Companies(3:end), NCompanies, plotFront);

%% Display

Blotter = dataset({lastPrices','Prices'}, {InitHold,'InitHolding'}, {InitP,'InitPort'}, 'obsnames', p.AssetList);

SR_pwgt(abs(SR_pwgt) < 1.0e-5) = 0;% zero out near 0 trade weights
Blotter.Portfolio = SR_pwgt;
Hold = Wealth * (SR_pwgt ./ lastPrices');% zero out near 0 trade weights
Hold(abs(Hold) < 1.0e-5) = 0;
Blotter.Holding = Hold;
Blotter.BuyShare = Wealth * (pbuy ./ lastPrices');
Blotter.SellShare = Wealth * (psell ./ lastPrices');
display(Blotter);

export(Blotter)

if (savePortfolio == true) 
    save currentPortfolio.mat Hold
end

% when we create another portfolio we can check if it is feasible in the 
% the other using the function "checkFeasibility"
% checkFeasibility(p, maxSharpRatio_portfolio)
