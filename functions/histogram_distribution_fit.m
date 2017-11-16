%This function takes as input simple and compound return, 
%number of companies and their names. 
%It plots the histograms with Normal and tStudent fit. 

function histogram_distribution_fit(simple, compound, number, names)

for i = 3:1:number
    simplereturn = simple{:,i};
    compundreturn = compound{:,i};
    company_name = char(names(i));
    
    %histfit plots the histograms with Normal and tStudent fit. 
    figure
    subplot(2,2,1)
    histfit(simplereturn,100,'tlocationscale')
    title( strcat( company_name , ' - simple - Student t') )
    
    subplot(2,2,2)
    histfit(compundreturn,100,'tlocationscale')
    title( strcat( company_name , ' - compound - Student t') )
    
    subplot(2,2,3)
    histfit(simplereturn,100,'Normal')
    title( strcat( company_name , ' - simple - Normal') )
    
    subplot(2,2,4)
    histfit(compundreturn,100,'Normal')
    title( strcat( company_name , ' - compound - Normal') )
    
end

end
