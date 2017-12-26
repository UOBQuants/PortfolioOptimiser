function [Sharpe_Ratio] = Sharpe_R(Exp_Portfolio,Portfolio_sd)
%Author: Georgie
%Using the expected return rates and standard deviations of each portfolio,
%Calculate the Sharpe ratio for each portfolio.

for i = 1:length(Exp_Portfolio)
    Sharpe_Ratio(:,i) = Exp_Portfolio(:,i)/Portfolio_sd(:,i)
end


end

