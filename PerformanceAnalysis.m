%we here se the which portfolio we are analysing
<<<<<<< HEAD
Method = 'BL';  % NP for copula projection
=======
Method = 'NP';  % NP for copula projection
>>>>>>> master
               % BL for Black Litterman

if Method == 'NP'
    load positionDB positionDB  %loads all the portfolios history until now
    Positions = positionDB;
elseif Method == 'BL'
    load positionDB_BL positionDB_BL %loads all the portfolios history until now
    Positions = positionDB_BL;
end

addpath('functions');
addpath('functions/Russell3000')

End_Date = '05/02/2018';

LastPosition = {End_Date, 0,0,0,0,0,0}; %in our last portfolio we are going to sell all our holding
Positions = [Positions ; LastPosition];

%set intial wealth
Initial_Wealth = 1000000;
Wealth = [Initial_Wealth];
Holdings =[];
<<<<<<< HEAD
CompanyPL =[];
=======
P_Ls = [];
>>>>>>> master

H = height(Positions);  %number of taken portfolios
for i = 1:H-1 %loop for each portfolio
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
    Holdings = [Holdings; Holding];
<<<<<<< HEAD
    CompanyPL = [CompanyPL; DeltaP(1,:).*Holding];
    
    P_L = DeltaP*Holding';
=======
    
    P_L = DeltaP*Holding';
    P_Ls = [P_Ls, flip(P_L')];
>>>>>>> master
    
    temp_Wealth = flip(P_L' + Wealth(end));
    
    Wealth = [Wealth , temp_Wealth];
    
end

<<<<<<< HEAD
newPL = Wealth - Initial_Wealth;
=======
>>>>>>> master
start_date = table2array(Positions(1,1));
start_date = start_date{1,1};
start_date(7) = '2';

<<<<<<< HEAD
Russell3000(Wealth,start_date , End_Date, Method) 
display(Holdings);
display(newPL);
=======
Russell3000(Wealth,start_date , End_Date) 
display(Holdings);
display(P_Ls);
>>>>>>> master
display(Wealth);

