function SavePortfolio(companies, Weights, Date)
size = length(companies);
Portfolio(1) = Date;
Portfolio(2:size+1) = Weights;

if exist('PortfolioDB.mat', 'file') == 0 
    Vars(2:size+1) = companies;
    Vars(1) = {'Date'};
    
    PortfolioDB = table;
    PortfolioDB = [PortfolioDB, Portfolio];
    PortfolioDB.Properties.VariableNames = Vars;
    save PortfolioDB
else
    load PortfolioDB
    PortfolioDB = [PortfolioDB; Portfolio];
    save PortfolioDB
end
