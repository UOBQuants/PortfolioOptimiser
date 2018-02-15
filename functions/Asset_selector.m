function Companies = Asset_selector()
%This function selects 6 assets from the sectorial data. It takes the mean
%compound return of each asset and select the best three and the worst
%three. 

[Market, Compound] = DB_Loader();

C_array = table2array(Compound(:, 3:end));
C_Mean = mean(C_array);
C_Cov = diag(cov(C_array))';
SR = C_Mean./sqrt(C_Cov);
Ranks = floor(tiedrank(SR));
short_index = find(Ranks < 4);
long_index = find(Ranks > (max(Ranks)-3) );
all_assets = [short_index , long_index] + 2;

Compound.Properties.VariableNames{all_assets}

