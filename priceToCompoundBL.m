function [exp_com_returnBL, var_com_returnBL] = priceToCompoundBL(WeeklyCompound, Market, OutstandingShares, size)
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



%% P and views matrix, your P matrix will be an identity matrix of 1's or
%%-1's, depending on whether you expect your returns to increase or
%%decrease, P's are in order or the security no. (P(1,1) is security 1)
%%tau is the error in mean estimation, we use 1/n securities

tau = 1/6 ;
P = zeros((size - 2), (size - 2)) ;
P(1,1) = 1 ;
P(2,2) = 1 ;
P(3,3) = 1 ;
P(4,4) = 1 ;
P(5,5) = 1 ;
P(6,6) = 1 ;

%% Your Q matrix is your own view of the market, I use an estimate of 
% compound returns for each security, I found the 12 month estimated price 
% on Bloomberg (I couldn't find anything shrter than this) then each week 
% I used the last price and this estimated price to calculate compound
% return --> log(estimatedprice/recentprice) * 100

Q = [2.3 10.8 9.4 6.3 5.8 1.1]' ;

% Omega is the uncertainty matrix, how much the views should be trusted.

Omega = (P*(tau*Var_histReturn)*P'); 

%% Calculate Expected Returns

exp_com_returnBL = equil_returns + tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*(Q - P*equil_returns) ;


%% Calculate Expected Variance

var_com_returnBL = tau*Var_histReturn - tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*P*tau*Var_histReturn ;



end
