function [Market, Compound, WeeklyCompound, OutstandingShares] = DB_Loader()

%Reads data from database
Market = readtable('DB/Market_Data.csv');
Compound = readtable('DB/Market_Data_CR.csv');
WeeklyCompound = readtable('DB/weeklycompound.csv');
OutstandingShares = readtable('BL_DB/OutstandingShares.csv');
%shortlongcomb = readtable('DB/ShortLong4c.csv');

%cleans data from NaN values
R = height(Market); %gives the number of rows
Compound(R,:) = []; %Last day does not have any return value 
Dcolumns = find( sum(ismissing(Compound)) > 0 ); %Find columns that have NaN values
Compound(:,Dcolumns) = []; %deletes columns with NaN values
Market(:,Dcolumns) = [];   % "                           "
<<<<<<< HEAD
WeeklyCompound(end,:) = [];
=======
>>>>>>> master
