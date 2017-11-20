function [ DATA ] = volGarch( pricedata )

DATA = readtable(pricedata);   %%Extract data from excel file
DATATABLE = DATA.PX_Last;      %%Define Variable DATATABLE as data from price column labeled PX_LAST
x=price2ret(DATATABLE);        %%Convert prices to simple returns and label x  
Obsv=length(x);   %%Number of observations in data


%%plot the returns over period of observations x, change title label to
%%whatever returns you are looking at
figure; 
plot (x)
xlim([0,Obsv])
title('Returns')

%% WITHOUT GARCH PARAMETERS
%%Use the garch function to set  garch parameters and assign to variable Mdl
Mdl = garch('GARCHLags',1,'ARCHLags',1,'Offset',NaN);
rng default; %for reproducibility
%% Fit the Garch parameters to your data using the estimate function
EstMdl = estimate(Mdl,DATATABLE);

%%Assign a variable to account for a table of dates for your sample
DATES = DATA.Date;

%%plot your returns against the dates in your data
figure;
plot(DATES,DATATABLE);

%%Make your Garch volatility forecast
numperiods = 100; %% Number of periods you want to evaluate over
vF=forecast(EstMdl,numperiods, 'Y0', DATATABLE);  %% Forecast identified model output (model you are forecasting, number of periods you want to evaluate over, 
v=infer(EstMdl,DATATABLE);

figure;
plot(DATES,v,'k:','LineWidth',2);
hold on;
plot(DATES(end):DATES(end) + 100,[v(end);vF],'r','LineWidth',2);
title('Forecasted Conditional Variances of Nominal Returns');
ylabel('Conditional variances');
xlabel('Year');
legend({'Estimation sample cond. var.','Forecasted cond. var.'},...
    'Location','Best');

%%WITH KNOWN GARCH PARAMETERS at garch(1,1) (set Mdl to garch('Constant',x,'GARCH',y,'ARCH',z);

% [v,y] = simulate(EstMdl,Obsv);
% 
% vF1=forecast(EstMdl,30, 'Y0', y);
% vF2=forecast(EstMdl,30);
% 
% u=v(100:520);
% 
% figure
% plot(u,'Color',[.7,.7,.7])
% hold on
% plot(521:550,vF1,'r','LineWidth',2);
% plot(521:550,vF2,':','LineWidth',2);
% title('Forecasted Conditional Variances')
% legend('Observed','Forecasts with Presamples',...
% 		'Forecasts without Presamples','Location','NorthEast')
% hold off





end

