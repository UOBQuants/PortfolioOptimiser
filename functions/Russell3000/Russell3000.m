
%% Seeting dates for the crawler

Start = '1/1/2018';
Finish = '6/2/2018';
initial_wealth = 100;
SDashes = strfind(Start,'/');
FDashesh = strfind(Finish,'/');
Title = 'Day,Month,Year\n';
StartDate = [str2num(Start(1:SDashes(1)-1)),str2num(Start(SDashes(1)+1:SDashes(2)-1)),str2num(Start(SDashes(2)+1:end))];
FinishDate = [str2num(Finish(1:FDashesh(1)-1)), str2num(Finish(FDashesh(1)+1:FDashesh(2)-1)), str2num(Finish(FDashesh(2)+1:end))];

fid = fopen('dates.csv', 'w') ;
fprintf(fid, Title) ;
fprintf(fid, '%d,%d,%d\n', StartDate) ;
fprintf(fid, '%d,%d,%d\n', FinishDate) ;
fclose(fid) ;

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