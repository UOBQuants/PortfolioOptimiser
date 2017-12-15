function [iid, Rho, nu, marginals, GARCHprop] = MarketAnalysis(comp, plotAutocorr, doHistogramFit, plotFatTails, plotHeuristicTest)
% Author : Giuseppe Mascolo
% MarketAnalysis
% Input: comp: any kind of returns in a table format
%        plotAutocorr: bool = true if we want to plot autocorrelation, false otherwise
%        doHistogramFit: bool = true if we want to do histogram fit, false otherwise
%        plotFatTails: bool = true if we want to plot fat tails analysis, false otherwise
%        plotHeuristicTest: bool = true if we want to plot the heuristic test, false otherwise
% Output: 
%        iid: number of IID marginals
%        Rho: an estimate of the matrix of linear correlation parameters for a t copula
%        nu: an estimate of the degrees of freedom
%        marginals: a vector of probability distribution object created
%                   by fitting the distribution specified in our returns
%        GARCHprop: number of marginals which present GARCH properties
% this function performs:
% 1. autocorrelation test
% 2. histogram distribution fit 
% 3. Identification of fat tails
% 4. Heuristic Test
% 5. Copula Fit
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

%https://uk.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%to learn how to access data 
Companies = comp.Properties.VariableNames; %creates a vector of cells with companies tickers
size = length(Companies); %counts the number of columns left

%grades will contain the fitted distrigution of the companies
grades = [];
%marginals will contain a vector of probability distribution object created
%by fitting the distribution specified in our returns
marginals = [];
%iid will count the number of IID marginals
iid = 0;
%GARCHprop will count the number of marginals which present GARCH properties
GARCHprop = 0;

for i = 3:1:size
    compound = comp{:,i};
    name = char(Companies(i));
    
    %% Autocorrelation
    %Plots autocorrelation of compound returns and compound squared returns 
    %and computes the Ljung-Box Q-Test
    %(=0 no autocorrelation, =1 autocorrelation)
    autocorr = autocorrelation_ACF( compound, 'compound', name , plotAutocorr);
    autocorr_abs = autocorrelation_ACF( abs(compound), 'abs compound', name , plotAutocorr);
   
    %if we want to check the squared value of the compuond return:
    %autocorr3 = autocorrelation_ACF( compound.^2, 'squared compound', name );

    %% Histogram fit
    %Plots histograms of simple and compound returns fitted with Normal and 
    %tStudent distribution
    if (doHistogramFit == true) 
        histogram_distribution_fit( compound, name );
    end

    %% Identification of fat tails
    %Plots t distribution againts data
    if (doHistogramFit == true) 
        Fat_Tails( compound, name );
    end
    
    %% Heuristic Test
    % performs simple invariance (i.i.d.) tests on a time series
    heuristicResult = Heuristic_Test(compound, name, plotHeuristicTest);
    
    %% Distribution Fit
    %performs tStudent fit or emirical fit and
    %the valuation of the cdf in our data points, obtaining the grades for the future copula fit.
    [singleGrade, singleMarginal] = fitGrades(compound);
    grades = [grades, singleGrade];
    %remember that marginals will contain a vector of probability distribution object
    marginals = [marginals, singleMarginal];
    
    %% Results analysis
    
    if(autocorr_abs == 0)
        GARCHprop = GARCHprop + 0;
        %to print which firm presents GARCH properties
%         strcat(name, " does't present GARCH properties")
        
    else
        GARCHprop = GARCHprop + 1;
        %to print which firm doesn't present GARCH properties
%         strcat(name, ' presents GARCH properties')
    end
        
    if((sum(heuristicResult) > 1) && (autocorr == 0))
        iid = iid + 1;
    else
        iid = iid + 0;
    end
    
    %to print which firm result IID from heuristic test
%     if(sum(heuristicResult) < 2)
%         strcat(name, ' no IID')
%     else
%         strcat(name, ' IID')
%     end
    
    %to print which firm result autocorrelated
%     if(autocorr == 0)
%         strcat(name, ' no autocorrelated')
%     else
%         strcat(name, ' autocorrelated')
%     end
    
    
end

%% Copula fit
%we now fit a tStudent copula considering our grades from the tStudent fit
%or empirical fit
[Rho,nu] = copulafit('t',grades,'Method','ApproximateML');

%if we want the joing pdf distribution
% X = ndgrid(0.05:0.001:0.95)*ones(1,size-2);  %creates a multidimentional grid
% copulapdf = mvtpdf(X,Rho,nu);

%if we want to generate random numbers
% cases = 100;
% R = mvtrnd(Rho,nu,cases);

end

