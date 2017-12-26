function [Portfolio_sd] = EfficientFrontier_sd(Var_Price)
%Author: Georgie
%Use the covariance matrix of expected prices to calculate the overall 
%expected standard deviation of different portfolio's with different possible
%weightings on each security.
 i = 1;

for w1 = 0:0.1:1
    
    for w2 = 0:0.1:1-w1

    for w3 = 0:0.1:1-w2-w1
    w4 = 1 - w3 - w2 - w1
    Portfolio_sd(:,i) = [sqrt(((w1*(Var_Price(1,1)))^2)+((w2)*(Var_Price(2,2)))^2+(((w3)*Var_Price(3,3))^2)+(((w4)*(Var_Price(4,4)))^2)+(2*w1*w2*Var_Price(1,2))+(2*w2*w3*Var_Price(2,3))+(2*w3*w4*Var_Price(3,4))+(2*w1*w4*Var_Price(1,4))+(2*w1*w3*Var_Price(1,3))+(2*w2*w4*Var_Price(2,4)))]
    i = i + 1 ;
    end
    end
end


end

