%This function takes as input compound return, number of companies 
%and their names. It plots the autocorrelation of compound returns, 
%and compound squared returns and computes the Ljung-Box Q-Test 
%for each of them.

function autocorrelation_ACF(Return, CompanyName)

figure
%plot autocorrelazion value with function autocorr
subplot(2,1,1);
autocorr( Return )
title( strcat(CompanyName, ' compound returns') )

subplot(2,1,2);
autocorr( Return.^2 )
title( strcat(CompanyName,' squared compound returns') )

% Now we are doing the Ljung-Box Q-Test for autocorrelation
% (Null hypothesys H0 := no autocorrelation)
% h is the rejection decision (=0 no enough evidence to reject H0)
% pValue is the p-value for the hypothesis test 
[h1,pValue1] = lbqtest( Return, 'lags', 21 );
[h2,pValue2] = lbqtest( Return.^2, 'lags', 21 );

% print the risult of the test
present = " returns present autocorrelation";
not_present = " returns do not present enough evidence to reject NO autocorrelation";
if h1==0
    disp( strcat(CompanyName, not_present) );
else
    disp( strcat(CompanyName, present) );
end

if h2==0
    disp( strcat(CompanyName, " squared", not_present) );
else
    disp( strcat(CompanyName, " squared", present) );
end

end
