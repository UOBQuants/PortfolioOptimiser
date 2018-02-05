function [InitHold,Wealth,InitP] = setInitialDataKNN(lastPrices,NCompanies)
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

    if exist('currentPortfolioKNN.mat', 'file') ~= 0
        load currentPortfolioKNN.mat HoldKNN
        InitHold = HoldKNN;
        Wealth = sum(lastPrices' .* abs(InitHold));
        InitP= (1/Wealth)*(lastPrices' .* InitHold);
    else
        InitHold = zeros(NCompanies, 1);
        Wealth = 1000000;
        InitP = InitHold;
    end
    
end

