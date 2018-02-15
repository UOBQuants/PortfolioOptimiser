function histogram_distribution_fit(Returns, CompanyName)
% histogram_distribution_fit
% Input: Returns: data
%        CompanyName: name of the company
% Output: 
%        plot of the histogram of our data with inside a fitted t
%        distribution

%histfit plots the histograms with Normal and tStudent fit. 
figure
subplot(2,1,1)
histfit(Returns,100,'tlocationscale')
title( strcat( CompanyName , ' - Student t') )
  
subplot(2,1,2)
histfit(Returns,100,'Normal')
title( strcat( CompanyName , ' - Normal') )
    
end
