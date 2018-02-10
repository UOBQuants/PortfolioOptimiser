function SavePortfolio(companies, Weights, Date, Method, sharp_ratio)
%this function takes the optimise portfolio (weights and sharpe ration) 
%from the optimiser and saves it in local drive for the performance analysis

size = length(companies);
position(1) = Date;
position(2:size+1) = Weights;
position = cell2table(position);

if Method == 'NP'
    if exist('positionDB.mat', 'file') == 0 
        Vars(2:size+1) = companies;
        Vars(1) = {'Date'};

        positionDB = position;
        positionDB.Properties.VariableNames = Vars;
        sharp_ratioDB = sharp_ratio;
        save positionDB positionDB sharp_ratioDB
    else
        load positionDB positionDB sharp_ratioDB
        R = height(positionDB);
        positionDB(R+1,:) = position;
        sharp_ratioDB = [sharp_ratioDB; sharp_ratio];
        save positionDB positionDB sharp_ratioDB
    end
elseif Method == 'BL'
    if exist('positionDB_BL.mat', 'file') == 0 
        Vars(2:size+1) = companies;
        Vars(1) = {'Date'};
        
        positionDB_BL = position;
        positionDB_BL.Properties.VariableNames = Vars;
        sharp_ratioDB_BL = sharp_ratio;
        save positionDB_BL positionDB_BL sharp_ratioDB_BL
    else
        load positionDB_BL positionDB_BL sharp_ratioDB_BL
        R = height(positionDB_BL);
        positionDB_BL(R+1,:) = position;
        sharp_ratioDB_BL = [sharp_ratioDB_BL; sharp_ratio];
        save positionDB_BL positionDB_BL sharp_ratioDB_BL
    end
end
