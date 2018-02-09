function projectedPrices = Projection(NDaysProjection, NCompanies, Rho, nu, marginals, lastPrices)
%Author : Giuseppe Mascolo
%Projection
% Input: NDaysProjection: number of days we want to use
%        NCompanies: number of companies
%        Rho: an estimate of the matrix of linear correlation parameters for a t copula
%        nu: an estimate of the degrees of freedom
%        marginals: a vector of probability distribution object created
%        lastPrices: the last prices we have (today's prices)
% Output: 
%        projectedPrices: projected prices at horizon

%number of random observation
NObservations = 1000;
%inzialization of the horizon compound
horizonProj = zeros(NObservations, NCompanies);

for i = 1 : NDaysProjection
    % Use Monte Carlo to project a vector of marginals for each company, using
    % the copula distribution fitted (this for each day)
    dayProj = marginal_projection(NCompanies, NObservations, Rho, nu, marginals);
    %we now sum our daily independent daily projection
    horizonProj = horizonProj + dayProj;
    %Each day's compound return is additive
end 

%from invariants to market prices
projectedPrices = Price_Project(lastPrices, horizonProj, NCompanies) ;   
end

