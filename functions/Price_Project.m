function P = Price_Project(lastPrices, horizonProj, NCompanies)
% Input: lastPrices: the last prices we have (today's prices)
%        horizonProj: invariants projected to the horizon
%        NCompanies: number of companies
% Output: 
%        P: prices at the horizon
% Function takes the invariants for each company and projects prices

%for each company we pass the projection from invariants to prices
for i = 1 : NCompanies
    %the first row of Market represent the last prices
    %the first two columns of Market are date an index.
    P(:,i) = lastPrices(i)*exp(horizonProj(:,i));
end

end

