function V = tStudentFitGrades(Returns, V)
% Author : Giuseppe Mascolo
% tStudentFit
% Input: Returns: data
%        V: existing matrix containing the grades (F(X)) look "Meucci"
% Output: 
%        V: updated matrix containing the grades (F(X)) look "Meucci"
% this function performs the tStudent fit or empirical fit and the valuation of the cdf in
% our data points, obtaining the grades for the future copula fit.

% create a tStudent distribution from our data
pd = fitdist(Returns,'tLocationScale');
%test the goodness of our the t fit
%namely chi2gof tests if compound comes from the pd distribution with mean
%and variance estimated from compound
%The result h is 1 if the data doesn't pass the test (compound not trom t
%Student distribution 
h = chi2gof(Returns,'CDF',pd);

%if the test fail (h=1) we estimate the cdf, otherwise we consider the cdf
%of the tStudent distribution with the function cdf.
if h == 1
    v = ksdensity(Returns,Returns,'function','cdf');
else
    v = cdf(pd,Returns);
end

%we now append our result to the previous
V = [V,v];

end

