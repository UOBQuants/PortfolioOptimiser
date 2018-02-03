function [p, sharp_ratio, SR_pwgt, pbuy, psell] = Optimisation(InitP, exp_lin_return, var_lin_return, companyNames, NCompanies, plotFront)
% Author : Giuseppe Mascolo
% Optimisation
% Input: InitP: vector with initial portfolio weights
%        exp_lin_return: vector of expected linear returns
%        var_lin_return: covariance matrix of linear returns
%        companyNames: vector of cells with ticker of the companies
%        NCompanies: number of companies
%        plotFront: bool = true if we want to plot the efficient frontier, false otherwise
%        savePortfolio: bool = true if we want to save our optimal portfolio
% Output: 
%        p: Portfolio object with our constraints
%        sharp_ratio: maximum sharp ratio
%        SR_pwgt: optimal portfolio weights
%        pbuy: purchases relative to an initial portfolio
%        psell: sales relative to an initial portfolio
% this function performs:
% 1. set short-long constraints
% 2. Portfolio creation 
% 3. optimisation
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

    %% set short-long constraints
        
    %selecting Nshort securities to short (NCompany-Nshort will be "longed")
    Nshort = 2;
    [~,I] = sort(exp_lin_return);
    A=ones(1,NCompanies);
    A(I(1:Nshort)) = -1*A(I(1:Nshort));
    
    %% Create a Portfolio
    
    p = Portfolio('name', 'Max Sharp Ratio Portfolio');
    p = setAssetMoments(p, exp_lin_return, var_lin_return);
    p = setAssetList (p, companyNames);
    p = addConstraints(p, A);
    if sum(InitP) ~= 0
        p = setInitPort(p, InitP);
    end
    
    %check validity of the portfolio
    %[lowb, upb, isbounded] = estimateBounds(p);

    %% Optimise
    % "estimateMaxSharpeRatio" maximizes the Sharpe ratio among portfolios on
    % the efficient frontier, it uses the "fminbnd" function and all
    % information in the object
    [SR_pwgt, pbuy, psell] = estimateMaxSharpeRatio(p);
    [risk, ret] = estimatePortMoments(p, SR_pwgt);
    sharp_ratio = ret/risk;
    
    % zero out near 0 trade weights
    pbuy(abs(pbuy) < 1.0e-5) = 0;
    psell(abs(psell) < 1.0e-5) = 0;  
    
    if (plotFront == true) 
        figure
        plotFrontier(p,40);
        hold on
        plot(risk, ret, '*r');
        if InitP == 0
            h = legend('Efficient Frontier','Final Portfolio', 'location', 'best');
        else
            h = legend('Initial Portfolio', 'Efficient Frontier', 'Final Portfolio', 'location', 'best');
        end
        set(h, 'Fontsize', 8);
        hold off
    end
    
% A = shortlongcomb{1,1:end};
% p = addConstraints(p, A);
% [maxSR_pwgt, max_pbuy, max_psell] = estimateMaxSharpeRatio(p);
% [risk, ret] = estimatePortMoments(p, maxSR_pwgt);
% max_sharp_ratio = ret/risk;
% 
% for i=2:height(shortlongcomb)
%     A = shortlongcomb{i,1:end};
%     p = addConstraints(p, A);
%     %[lowb, upb, isbounded] = estimateBounds(p)
%     [SR_pwgt, pbuy, psell] = estimateMaxSharpeRatio(p);
%     [risk, ret] = estimatePortMoments(p, SR_pwgt);
%     sharp_ratio_new = ret/risk;
%     if sharp_ratio_new > max_sharp_ratio
%         maxSR_pwgt = SR_pwgt;
%         max_pbuy = pbuy;
%         max_psell = psell;
%         max_sharp_ratio = sharp_ratio_new;
%     end
% end
% 
% display(max_sharp_ratio);
% figure
% plotFrontier(p)
% hold on
% plot(risk, ret, '*r');
% 
% Blotter1 = dataset([{100*[maxSR_pwgt, max_pbuy, max_psell]},{'Weight', 'Purchases', 'Sales'}], 'obsnames', p.AssetList);
% display(Blotter1);
    
end

