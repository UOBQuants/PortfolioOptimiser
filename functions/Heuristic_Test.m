function output = Heuristic_Test(Data, CompanyName, Visual)
% Author : Ashley Robertson
% this function performs simple invariance (i.i.d.) tests on a time series
% 1. it checks that the variables are identically distributed by looking at the 
%    histogram of two subsamples
% 2. it checks that the variables are independent by looking at the 1-lag scatter plot
% under i.i.d. the location-dispersion ellipsoid should be a circle
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci

mean_result = false;
sd_result = false;

% test "identically distributed hypothesis": split observations into two sub-samples and plot histogram
sample_size = (length(Data)/2);
Sample_1=Data(1:round(sample_size));
Sample_2=Data(round(sample_size)+1:end);
% Divide the data into two sample

pd1 = fitdist(Sample_1,'Normal');
pd2 = fitdist(Sample_2,'Normal');
% Fit samples to Normal dist for better comparison


mean1 = pd1.mu; %mean of sample1
sd1 = sqrt(pd1.sigma); %Standard deviation of sample2
Sigma_mean1 = sd1/sqrt(sample_size); %Standard error of the mean

mean2 = pd2.mu; %mean of sample2

Z_95 = 1.96; %Defining 95% confidence interval


Lower_limit = mean1 - Z_95*Sigma_mean1;
Upper_limit = mean1 + Z_95*Sigma_mean1;
if Lower_limit < mean2 && Upper_limit > mean2 %if the mean of sample 2 is 
    %within the range of mean of sample1 +- sd1
    mean_result = true;
end

D = Data(1:end-1);
L = Data(2:end);
%Define the lags

m=mean([D , L]);
S=cov([D , L]);

if Visual == true 
    num_bins_1 = round(5*log(length(Sample_1)));
    num_bins_2 = round(5*log(length(Sample_2)));
    %Define reasonible bin sizes

    range = (max(Data)-min(Data));
    off_set = 0.1*range;
    X_lim=[min(Data)-off_set , max(Data)+off_set];
    %Define range of X in the histograms
    %The X sclae should be identical for a good comparison

    [n1,xout1] = hist(Sample_1,num_bins_1);
    [n2,xout2] = hist(Sample_2,num_bins_2);
    %Obtaining the histograms of the samples

    Hist1_Title = ['Sample 1 Histogram of Company: ', CompanyName];
    Hist2_Title = ['Sample 2 Histogram of Company: ', CompanyName];
    lag_Title = ['lag of Company: ', CompanyName];
    %Title of each figure

    figure

    subplot('Position',[0.03 .52 .44 .42])
    h1=bar(xout1,n1,1);
    set(h1,'FaceColor',[.7 .7 .7],'EdgeColor','k')
    set(gca,'ytick',[],'xlim',X_lim,'ylim',[0 max(max(n1),max(n2))])
    grid off
    %Plotting the first histogram
    title(Hist1_Title)
    xlabel('Price')
    ylabel('Frequncy')
    txt1 = ['Mean = ', num2str(pd1.mu)];
    text(X_lim(2)/2,10,txt1)
    txt2 = ['Sigma^2 = ', num2str(pd1.sigma)];
    text(X_lim(2)/2,8,txt2)
    %Adding information to the plot

    subplot('Position',[.53 .52 .44 .42])
    h2=bar(xout2,n2,1);
    set(h2,'FaceColor',[.7 .7 .7],'EdgeColor','k');
    set(gca,'ytick',[],'xlim',X_lim,'ylim',[0 max(max(n1),max(n2))]);
    grid off
    %Plotting the second histogram
    title(Hist2_Title)
    xlabel('Price')
    ylabel('Frequncy')
    txt1 = ['Mean = ', num2str(pd2.mu)];
    text(X_lim(2)/2,10,txt1)
    txt2 = ['Sigma^2 = ', num2str(pd2.sigma)];
    text(X_lim(2)/2,8,txt2)
    %adding information to the plot

    % test "independently distributed hypothesis": scatter plot of observations at lagged times
    subplot('Position',[.28 .01 .43 .43])
    plot( D , L , '.' );
    TwoDimEllipsoid(m,S,2,0,0);
    %plot the lags
    grid off
    axis equal
    set(gca,'xlim',X_lim,'ylim',X_lim);
end

output = [mean_result, sd_result];
end