<<<<<<< HEAD
%--------------------------------------------------------------------------
% Portfolio Optimiser main script
% Instruction: the first time the main is run check that there are not
% these two files: "positionDB.mat" and "positionDB_BL.mat" otherwise delete
% them (just the first run).
% Check the existance of the file "companylist.csv" with correct tickers.
% Once these preliminaries have been made it is possible to run the main.
% 1. Set the date for the Crawler
% 2. Change the Q and P matrix with the experts views
% 3. Run
% 4. Run "PerformanceAnalysis.m" setting the correct End_Date
%--------------------------------------------------------------------------
clear all, close all

%% Libraries
addpath('functions');
addpath('functions/Heuristic_test_sub_functions')

%% Crawler
dates2csv('29/01/2016', '29/01/2018') %Sending the start and finish dates to the crawler for data aquisition
system('python functions/Crawler/Data_Gatherer.py')

%% Your Q matrix is your own view of the market, 
% An estimate of compound returns for each security is used, 
% namely each week the 12 month estimated price on Bloomberg has been taken
% as estimation
% return --> log(estimatedprice/recentprice) * 100

% Q = [8.215 22.69 16.66 6.85 9.23 4.5 ]' ; %week 1
% Q = [7.25  20.47 13.11 3.23 7.24 3.43]' ; %week 2
% Q = [4.90  18.29 14.90 4.15 5.20 2.43]' ; %week 3
% Q = [5.33  20.75 15.68 5.48 5.05 3.54]' ; %week 4
 Q = [6.02  21.54 20.69 7.86 7.04 4.65]' ; %week 5

%% P and views matrix, 
% your P matrix will be an identity matrix of 1's or -1's,
% depending on whether you expect your returns to increase or
% decrease, P's are in order or the security no. 

P = [ 1, 1, 1, 1, 1, -1];

%% Data
[Market, Compound, WeeklyCompound, OutstandingShares] = DB_Loader();

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

%Black-Litterman
[exp_com_returnBL, var_com_returnBL] = priceToCompoundBL(WeeklyCompound, Market, OutstandingShares, NCompanies, Q, P);

%% Optimisation

[sharp_ratio, SR_pwgt] = Optimisation(exp_lin_return, var_lin_return, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio MV');
[sharp_ratioBL, SR_pwgtBL] = Optimisation(exp_com_returnBL, var_com_returnBL, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio BL');

if (savePortfolio == true) 
    date = {datestr(table2array(Market(1,1)), 'dd/mm/yyyy')};
    SavePortfolio(Companies(3:end),num2cell(SR_pwgt), date, 'NP', sharp_ratio);
    SavePortfolio(Companies(3:end),num2cell(SR_pwgtBL'), date, 'BL', sharp_ratioBL);
end

%Once you run "PerformanceAnalysis" should be run
=======
%--------------------------------------------------------------------------
% Portfolio Optimiser main script
%--------------------------------------------------------------------------
clear all, close all

%% Libraries
addpath('functions');
addpath('functions/Heuristic_test_sub_functions')

%% Crawler
dates2csv('05/02/2016', '05/02/2018') %Sending the start and finish dates to the crawler for data aquisition
system('python functions/Crawler/Data_Gatherer.py')

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
[Market, Compound, WeeklyCompound, OutstandingShares] = DB_Loader();

%https://uk.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%to learn how to access data 
Companies = Compound.Properties.VariableNames; %creates a vector of cells with companies tickers
size = length(Companies); %counts the number of columns (it includes date and index columns)

%we decide now what we want to plot
plotAutocorr = false;
doHistogramFit = false;
plotFatTails = false;
plotHeuristicTest = false;
plotFront = false;

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

%% Optimisation
%first calculates expected vector and covariance matrix for total returns
%matlab Portfolio object uses Markowitz model for portfolio optimisation
%computations
[sharp_ratio, SR_pwgt] = Optimisation(exp_lin_return, var_lin_return, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio MV');
[sharp_ratioBL, SR_pwgtBL] = Optimisation(exp_com_returnBL, var_com_returnBL, Companies(3:end), NCompanies, plotFront, 'Max Sharp Ratio Portfolio BL');

if (savePortfolio == true) 
    date = {datestr(table2array(Market(1,1)), 'dd/mm/yyyy')};
    SavePortfolio(Companies(3:end),num2cell(SR_pwgt), date, 'NP', sharp_ratio);
    SavePortfolio(Companies(3:end),num2cell(SR_pwgtBL'), date, 'BL', sharp_ratioBL);
end

%Once you run "PerformanceAnalysis" should be run
>>>>>>> master
