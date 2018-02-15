function h = autocorrelation_ACF(Returns, ReturnName, CompanyName, doPlot)
% autocorrelation_ACF
% Input: Returns: data
%        ReturnName: string with the name ot the returns (simple,compound,ext.)
%        CompanyName: name of the company
%        doPlot: bool = true if we want to plot autocorrelation
% Output: 
%        h: Ljung-Box Q-Test result (=0 no autocorrelation, =1 autocorrelation)

%plot autocorrelazion value with function autocorr
if(doPlot == true)
    figure
    subplot(2,1,1)
    plot(Returns);
    hline = refline([0]);
    hline.Color = 'r';

    subplot(2,1,2)
    autocorr( Returns )
    title( strcat(CompanyName, {', '}, ReturnName) )
end

% Now we are doing the Ljung-Box Q-Test for autocorrelation
% (Null hypothesys H0 := no autocorrelation)
% h is the rejection decision (=0 no enough evidence to reject H0)
% pValue is the p-value for the hypothesis test 
[h,pValue] = lbqtest( Returns, 'lags', 21 );


end
