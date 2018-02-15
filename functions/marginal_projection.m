function dayProj = marginal_projection(NCompanies, NObservations, Rho, nu, marginals)
%marginal_projection
% Input: NCompanies: number of companies
%        NObservations: number of random vector to throw for Monte Carlo
%        Rho: an estimate of the matrix of linear correlation parameters for a t copula
%        nu: an estimate of the degrees of freedom
%        marginals: a vector of probability distribution object created
% Output: 
%        dayProj: one day projected returns
% Use Monte Carlo to project a vector of marginals for each company, using
% the copula distribution fitted

%throwing Nobservation random vectors from our fitted copula (this is going
%to be part of our daily projection)
u = copularnd('t',Rho,nu,NObservations);

%we now calculate the one day projected return (going back from our copula
%to marginals with inverse cdf)
for i = 1:NCompanies
    dayProj(:,i) = icdf(marginals(i),u(:,i));
end