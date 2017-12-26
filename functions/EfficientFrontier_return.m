function [Exp_Portfolio] = EfficientFrontier_return(Projected_Compound)
%Author: Georgie
%Use the expected compound return to calculate the overall expected compound 
%return of different portfolio's with different possible
%weightings on each security.

i = 1;

for w1 = 0:0.1:1
    
    for w2 = 0:0.1:1-w1

    for w3 = 0:0.1:1-w2-w1
    w4 = 1 - w3 - w2 - w1
    Exp_Portfolio(:,i) = [w1*Projected_Compound(:,1)+w2*Projected_Compound(:,2)+w3*Projected_Compound(:,3)+w4*Projected_Compound(:,4)]
   
    i = i + 1 ;
    end
    end
end

end

