function [InitHold,Wealth,InitP] = setInitialData(lastPrices,NCompanies)
% Author : Giuseppe Mascolo
% setInitialData
% Input: lastPrices: vector of last available data (today's prices)
%        NCompanies: number of companies
% Output: 
%        InitHold: initial holdings
%        Wealth: today's wealth
%        InitP: initial portfolio
%
% thi function checks if there's a file with last holding calculated and
% set Wealth and initial portfolio

    %if the file exist  
    if exist('currentPortfolio.mat', 'file') ~= 0
        %load the initial holdings
        load currentPortfolio.mat Hold
        InitHold = Hold;
        %calculate the actual wealth
        Wealth = sum(lastPrices' .* abs(InitHold));
        %and the initial protfolio weights
        InitP= (1/Wealth)*(lastPrices' .* InitHold);
    else
        %otherwise set it as zeros
        InitHold = zeros(NCompanies, 1);
        InitP = InitHold;
        %the first time we run the program we set out initial wealth
        Wealth = 1000000;
    end
    
end

