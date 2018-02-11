function [exp_com_returnBL, var_com_returnBL] = priceToCompoundBL(WeeklyCompound, Market, OutstandingShares, NCompanies, Q, P)
%%Author: Georgie - Black-Litterman function to incorporate your views


%% find market cap weights for each asset

% Calculate historical return covariance matrix from your compound weekly
% returns

hist_comp = WeeklyCompound{:, 3 : end} ;
Var_histReturn = cov(hist_comp) ;

%%Find market captialization weights using an input of outstanding shares
%and share price, then use this to calculate equilib returns
risk_aversion = 3 ;

each_marketcap = Market{1,3:end}.*OutstandingShares{:,1}';
total_marketcap = sum(each_marketcap);
w = each_marketcap'/total_marketcap;

equil_returns = risk_aversion * Var_histReturn * w ;


tau = 1/NCompanies ;
P = diag(P);


% Omega is the uncertainty matrix, how much the views should be trusted.

Omega = (P*(tau*Var_histReturn)*P'); 

%% Calculate Expected Returns

exp_com_returnBL = (equil_returns + tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*(Q - P*equil_returns))/100 ;


%% Calculate Expected Variance

var_com_return = tau*Var_histReturn - tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*P*tau*Var_histReturn ;

var_com_returnBL = var_com_return + Var_histReturn ;

end
