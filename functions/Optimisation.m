function [sharp_ratio, SR_pwgt] = Optimisation(exp_lin_return, var_lin_return, companyNames, NCompanies, plotFront, title)
% Author : Giuseppe Mascolo
% Optimisation
% Input: exp_lin_return: vector of expected linear returns
%        var_lin_return: covariance matrix of linear returns
%        companyNames: vector of cells with ticker of the companies
%        NCompanies: number of companies
%        plotFront: bool = true if we want to plot the efficient frontier, false otherwise
%        savePortfolio: bool = true if we want to save our optimal portfolio
% Output:sharp_ratio: maximum sharp ratio
%        SR_pwgt: optimal portfolio weights
% this function performs:
% 1. set short-long constraints
% 2. Portfolio creation 
% 3. optimisation
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

    %% set short-long constraints
        
    %selecting Nshort securities to short (NCompany-Nshort will be "longed")
    Nshort = 3;
    [~,I] = sort(exp_lin_return);
    A=ones(1,NCompanies);
    A(I(1:Nshort)) = -1*A(I(1:Nshort));
    
    %% Create a Portfolio
    
    p = Portfolio('name', title);
    p = setAssetMoments(p, exp_lin_return, var_lin_return);
    p = setAssetList (p, companyNames);
    p = addConstraints(p, A);
    
    %check validity of the portfolio
    %[lowb, upb, isbounded] = estimateBounds(p);

    %% Optimise
    % "estimateMaxSharpeRatio" maximizes the Sharpe ratio among portfolios on
    % the efficient frontier, it uses the "fminbnd" function and all
    % information in the object
    SR_pwgt = estimateMaxSharpeRatio(p);
    [risk, ret] = estimatePortMoments(p, SR_pwgt);
    sharp_ratio = ret/risk; 
    
    if (plotFront == true) 
        figure
        plotFrontier(p,40);
        hold on
        plot(risk, ret, '*r');
        h = legend('Efficient Frontier','Portfolio', 'location', 'best');
        set(h, 'Fontsize', 8);
        hold off
    end
   
end

