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
[iid, Rho, nu, GARCHprop] = MarketAnalysis(Compound, plotAutocorr, doHystogramFit, plotFatTails, plotHeuristicTest);
