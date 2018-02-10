function Saveposition(companies, Weights, Date, Method)


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
        save positionDB positionDB
    else
        load positionDB positionDB
        R = height(positionDB);
        positionDB(R+1,:) = position;
        save positionDB positionDB
    end
elseif Method == 'BL'
    if exist('positionDB_BL.mat', 'file') == 0 
        Vars(2:size+1) = companies;
        Vars(1) = {'Date'};
        
        positionDB_BL = position;
        positionDB_BL.Properties.VariableNames = Vars;
        save positionDB_BL positionDB_BL
    else
        load positionDB_BL positionDB_BL
        R = height(positionDB_BL);
        positionDB_BL(R+1,:) = position;
        save positionDB_BL positionDB_BL
    end
end
