%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Identification Fat tail %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To find out the fat tails, we compare the data with a fat tailed
% distribution (here the student t)
% Df (degree of freedom) indicate how fat the tails are

function Fat_Tails (Return,size,Companies)

prob_cdf = 0.005:0.01:0.995; % confidence interval
quantile_t_dist = tinv (prob_cdf, 3); 
%return the inverse of the student (=quantile function)
%3 are the degree of freedom of the tStudent distribution considered
%we choose 3 after having tried some, it can be changed.

figure
% Plot T distribution VS Outcome company 
for i = 3:1:size
    simplereturn = Return{ : , i};
    name = char(Companies(i));
    
    subplot( 2, 2, i-2 )
    qqplot( simplereturn, quantile_t_dist );
    title( strcat(name, ' - T Distribution Quantiles (df=3)') );
end

end