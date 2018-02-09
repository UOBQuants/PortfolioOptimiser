%--------------------------------------------------------------------------
% Portfolio Optimiser main script
%--------------------------------------------------------------------------
clear all, close all
%% Libraries
addpath('functions');
addpath('functions/Heuristic_test_sub_functions')

%% Your Q matrix is your own view of the market, I use an estimate of 
% compound returns for each security, I found the 12 month estimated price 
% on Bloomberg (I couldn't find anything shrter than this) then each week 
% I used the last price and this estimated price to calculate compound
% return --> log(estimatedprice/recentprice) * 100

Q = [2.3 10.8 9.4 6.3 5.8 1.1]' ;

%% P and views matrix, 
% your P matrix will be an identity matrix of 1's or -1's,
% depending on whether you expect your returns to increase or
%%decrease, P's are in order or the security no. 

P = [ 1, 1, 1, 1, 1, 1];

%% Data
%Reads data from database
Market = readtable('DB/Market_Data.csv');
Compound = readtable('DB/Market_Data_CR.csv');
Return = readtable('DB/Market_Data_NR.csv');
WeeklyCompound = readtable('functions/weeklycompound.csv');
OutstandingShares = readtable('DB/OutstandingShares.csv');
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

%% Projection
NDaysProjection = 5;
NCompanies = size - 2;
lastPrices = Market{1,3:end};
projectedPrices = Projection(NDaysProjection, NCompanies, Rho, nu, marginals, lastPrices); 

[exp_lin_return, var_lin_return] = priceToLinear(projectedPrices, lastPrices);

[exp_com_returnBL, var_com_returnBL] = priceToCompoundBL(WeeklyCompound, Market, OutstandingShares, NCompanies, Q, P);

[InitHold,Wealth,InitP] = setInitialData(lastPrices,NCompanies);
[InitHoldBL,WealthBL,InitPBL] = setInitialDataBL(lastPrices,NCompanies);

%% Optimisation
%first calculates expected vector and covariance matrix for total returns
%matlab Portfolio object uses Markowitz model for portfolio optimisation
%computations
[p, sharp_ratio, SR_pwgt, pbuy, psell] = Optimisation(InitP, exp_lin_return, var_lin_return, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio MV');
[pBL, sharp_ratioBL, SR_pwgtBL, pbuyBL, psellBL] = Optimisation(InitPBL, exp_com_returnBL, var_com_returnBL, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio BL');

[Blotter, Hold] = createBlotter(p.AssetList, lastPrices, InitHold, InitP, SR_pwgt, Wealth, pbuy, psell);
[BlotterBL, HoldBL] = createBlotter(pBL.AssetList, lastPrices, InitHoldBL, InitPBL, SR_pwgtBL, WealthBL, pbuyBL, psellBL);

display(Blotter);
display(BlotterBL);

export(Blotter)
export(BlotterBL)

if (savePortfolio == true) 
    save currentPortfolio.mat Hold
    save currentPortfolioBL.mat HoldBL
end

% when we create another portfolio we can check if it is feasible in the 
% the other using the function "checkFeasibility"
% checkFeasibility(p, maxSharpRatio_portfolio)
