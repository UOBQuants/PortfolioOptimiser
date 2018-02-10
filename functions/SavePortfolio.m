function SavePortfolio(companies, Weights, Date, Method)


size = length(companies);
Portfolio(1) = Date;
Portfolio(2:size+1) = Weights;

if Method == 'NP'
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
elseif Method == 'BL'
    if exist('PortfolioDB_BL.mat', 'file') == 0 
        Vars(2:size+1) = companies;
        Vars(1) = {'Date'};

        PortfolioDB_BL = table;
        PortfolioDB_BL = [PortfolioDB_BL, Portfolio];
        PortfolioDB_BL.Properties.VariableNames = Vars;
        save PortfolioDB_BL
    else
        load PortfolioDB_BL
        PortfolioDB_BL = [PortfolioDB_BL; Portfolio];
        save PortfolioDB_BL
    end
end
