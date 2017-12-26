function expPrices = ExpectedValues(size,P)

% Author : Georgie
%Calculate a vector of expected Future Prices for each security

for i = 1 : size - 2
    
expPrices(:,i) = mean(P(:,i));

end

end

