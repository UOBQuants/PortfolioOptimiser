
%Positions = {'01/01/0017', 0.1,0.3,0.2,0.1,0.1,0.2;
             %'08/01/0017', 0.1,0.2,0.2,0.1,0.2,0.2;};
         
%Positions = cell2table(Positions);

Method = 'NP'

if Method == 'NP'
    load positionDB positionDB
    Positions = positionDB;
elseif Method == 'BL'
    load positionDB_BL positionDB_BL
    Positions = positionDB_BL;
end

addpath('functions');
addpath('functions/Russell3000')

End_Date = '05/02/2018';

LastPosition = {End_Date, 0,0,0,0,0,0};
Positions = [Positions ; LastPosition];

Positions.Properties.VariableNames = {'Date', 'NI', 'ANF', 'ABBV', 'AHC', 'KMI', 'BCO'};

H = height(Positions);
Initial_Wealth = 1000000;
Wealth = [Initial_Wealth];
Holdings =[];

for i = 1:H-1
    %% Setting Start & Finish Dates
    start_date = table2array(Positions(i,1));
    start_date = start_date{1,1};
    start_date(7) = '2';
    
    Finish_date = table2array(Positions(i+1,1));
    Finish_date = Finish_date{1,1};
    Finish_date(7)= '2';
    
    if start_date == Finish_date
        continue;
    end
    %% Crawler
    dates2csv(start_date, Finish_date) %Sending the start and finish dates to the crawler for data aquisition
    system('python functions/Crawler/Data_Gatherer.py')
    
    %% Loading Market Prices
    [Market, ~, ~, ~] = DB_Loader();
    Purchasing_price = table2array(Market(end,3:end));
    Future = table2array(Market(1:end-1,3:end));
    DeltaP = Future - Purchasing_price;
    
    Weights = table2array(Positions(i,2:end));
    Holding = (Wealth(end)*Weights)./Purchasing_price;
    Holdings = [Holdings, Holding];
    
    P_L = DeltaP*Holding';
    
    temp_Wealth = flip(P_L' + Wealth(end));
    
    Wealth = [Wealth , temp_Wealth];
    
end

start_date = table2array(Positions(1,1));
start_date = start_date{1,1};
start_date(7) = '2';


Russell3000(Wealth,start_date , End_Date) 

