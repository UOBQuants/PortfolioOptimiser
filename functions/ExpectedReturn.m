function Projected_Compound = ExpectedReturn(Market,expPrices, size)
%Author: Georgie
% Project the compound returns of each security over the projected horizon, using the most recent price data at tnow, and projected price.

for i = 1 : size - 2
    Vec_Price(:,i) = [Market{1, i+2},expPrices(:,i)]
end

for i = 1 : size - 2
    
    Projected_Compound(:,i) = price2ret(Vec_Price(:,i))
    
end

end

