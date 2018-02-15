function [exp_lin_return, var_lin_return] = priceToLinear(projectedPrices, lastPrices)
<<<<<<< HEAD
=======
% Author : Giuseppe Mascolo
>>>>>>> master
% priceToLinear
% Input: projectedPrices: projected prices at the horizon
%        lastPrices: vector of last available data (today's prices)
% Output: 
%        exp_lin_return: vector of expected linear returns
%        var_lin_return: covariance matrix of linear returns
%
% from the "distribution" of prices we derive the "distribution" of total
% returns

    exp_prices = mean(projectedPrices);      %mean of all observations from Monte Carlo
    diag_lastPrices = diag(lastPrices);  %diagonal matrix of last prices 
                                            % to calculate the variance of linear returns

    %expected value of linear returns from 6.89 Meucci
    exp_lin_return = exp_prices./lastPrices - 1;
    %expected value and covariance linear return can be also calculated by looking at the linear
    %returns for each MC observation and than calculating the mean
    %    ALTERNATIVE CODE:
    %    lin_return = projectedPrices./lastPrices - 1;
    %    exp_lin_return = mean(lin_return);
    %    var_lin_return = cov(lin_return);

    %variance-covariance matrix of linear returns from 6.90 Meucci 
    var_prices = cov(projectedPrices);
    var_lin_return = diag_lastPrices\var_prices/diag_lastPrices;
    % same as var_lin_return = inv(diag_lastPrices) * var_prices * inv(diag_lastPrices)

    % Another alternative is to make the Portfolio object estimate mean and
    % covariance matrix with the function "estimateAssetMoments"
    % This leads to the same result.
end

