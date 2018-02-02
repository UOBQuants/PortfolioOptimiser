function [BL_ExpVariance] = Black_Litterman_ExpVariance(Var_histReturn, size)
%Author: Georgie
%run the Black-Litterman function to find optimal portfolio weights

%Parameter Definition

tau = 0.05 ;
c = 0.2 ;
P = zeros((size - 2), (size - 2)) ;
P(1,1) = -1 ;
P(2,2) = 1 ;
P(3,3) = 1 ;
P(4,4) = 1 ;

Q = [0.00014 0.00289 0.00028 0.00334]' ;
Omega = ((1/c)-1)*P*Var_histReturn*P' ; 

%% Calculate Expected Returns

BL_ExpVariance = tau*Var_histReturn - tau*Var_histReturn*P'*inv(P*tau*Var_histReturn*P' + Omega)*P*tau*Var_histReturn ;

end
