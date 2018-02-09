function [BL_ExpReturns] = Black_Litterman_Exp(equil_returns, Var_histReturn, size)
%Author: Georgie
%run the Black-Litterman function to find optimal portfolio weights

tau = 1/6 ;
P = zeros((size - 2), (size - 2)) ;
P(1,1) = 1 ;
P(2,2) = 1 ;
P(3,3) = 1 ;
P(4,4) = 1 ;
P(5,5) = 1 ;
P(6,6) = 1 ;

Q = [2.3 10.8 9.4 6.3 5.8 1.1]' ;

Omega = (P*(tau*Var_histReturn)*P'); 

%% Calculate Expected Returns

BL_ExpReturns = equil_returns + tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*(Q - P*equil_returns) ;


%% Calculate Expected Variance

BL_ExpVariance = tau*Var_histReturn - tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*P*tau*Var_histReturn ;

end

