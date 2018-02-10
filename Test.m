
Positions = {'01/01/0017', 0.1,0.3,0.2,0.1,0.1,0.2;
             '08/01/0017', 0.1,0.2,0.2,0.1,0.2,0.2;};
         
Positions = cell2table(Positions);

Positions.Properties.VariableNames = {'Date', 'NI', 'ANF', 'ABBV', 'AHC', 'KMI', 'BCO'};

H = height(Positions);

start_date = table2array(Positions(1,1));
start_date = 

