%This function takes as input compound return, number of companies 
%and their names. It plots the autocorrelation of compound returns, 
%and compound squared returns and computes the Ljung-Box Q-Test 
%for each of them.

function autocorrelation_ACF(compound, number, names)

for i = 3:1:number
    company_comp = compound{:,i};
    company_name = char(names(i));
    
    figure
    %plot autocorrelazion value with function autocorr
    subplot(2,1,1);
    autocorr( company_comp )
    title( strcat(company_name, ' compound returns') )

    subplot(2,1,2);
    autocorr( company_comp.^2 )
    title( strcat(company_name,' squared compound returns') )

    % Now we are doing the Ljung-Box Q-Test for autocorrelation
    % (Null hypothesys H0 := no autocorrelation)
    % h is the rejection decision (=0 no enough evidence to reject H0)
    % pValue is the p-value for the hypothesis test 
    [h1,pValue1] = lbqtest( company_comp, 'lags', 21 );
    [h2,pValue2] = lbqtest( company_comp.^2, 'lags', 21 );
end

end
