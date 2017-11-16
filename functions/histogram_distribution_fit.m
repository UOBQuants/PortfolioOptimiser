%This function takes as input simple and compound return, 
%number of companies and their names. 
%It plots the histograms with Normal and tStudent fit. 

function histogram_distribution_fit(simpleR, compoundR, CompanyName)

%histfit plots the histograms with Normal and tStudent fit. 
figure
subplot(2,2,1)
histfit(simpleR,100,'tlocationscale') %100 is the number of
title( strcat( CompanyName , ' - simple - Student t') )
   
subplot(2,2,2)
histfit(compoundR,100,'tlocationscale')
title( strcat( CompanyName , ' - compound - Student t') )

subplot(2,2,3)
histfit(simpleR,100,'Normal')
title( strcat( CompanyName , ' - simple - Normal') )
  
subplot(2,2,4)
histfit(compoundR,100,'Normal')
title( strcat( CompanyName , ' - compound - Normal') )
    
end
