function Russell3000(Wealth, Start , Finish)
%% Seeting dates for the crawler

Russeelldates2csv(Start, Finish)
initial_wealth = Wealth(1);

system('python functions/Russell3000/Russell_Data_Gatherer.py')
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

datetoPlot = table2array(Market(:,2))
RusWealthCorrelation = corr(WealthRussell3000_History',Wealth')
figure
plot(flip(datetoPlot), WealthRussell3000_History, 'DatetimeTickFormat', 'dd/MM/yy')
hold on
plot(flip(datetoPlot), Wealth)
%datetick('x',1, 'keeplimits')
title('Russell 300 Benchmark Analysis')
h = legend('Russel 3000','Portfolio', 'location', 'best');
set(h, 'Fontsize', 8);
txt1 = ['Correlation = ', num2str(RusWealthCorrelation)];
text(datetoPlot(end-1),max(Wealth),txt1)
hold off

end