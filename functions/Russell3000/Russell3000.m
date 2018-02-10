PortfolioWealth = readtable('portfolioWealth.csv');
%% Seeting dates for the crawler

Start = datestr(table2array(PortfolioWealth(1,1)), 'dd/mm/yyyy');
Finish = datestr(table2array(PortfolioWealth(end,1)), 'dd/mm/yyyy');
dates2csv(Start, Finish)
initial_wealth = 100;

system('python Russell_Data_Gatherer.py')
%% Russell3000 correlation comparison

WealthRussell3000 = initial_wealth ;
Market = readtable('Russell3000R.csv');
Returns = table2array(Market(:,3));
[Rows , C] = size(Returns);
WealthRussell3000_History = [];
for i = Rows:-1:1 
    WealthRussell3000 = WealthRussell3000*(Returns(i)+1);
    WealthRussell3000_History = [WealthRussell3000_History , WealthRussell3000];
end

figure
plot(WealthRussell3000_History)
hold on
plot(table2array(PortfolioWealth(:,2)))

%% Portfolio Analysis 
