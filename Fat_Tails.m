

function Fat_Tails (Return,size,Companies)

prob_cdf = 0.005:0.01:0.995;
quantile_t_dist = tinv (prob_cdf,3); %return the inverse of the student (=quantile function)

for i = 3:1:size
    simplereturn = Return{:,i};
    
subplot(2,2,i-2)
qqplot (simplereturn,quantile_t_dist);
title( strcat( char(Companies(i)) , 'T Distribution Quantiles (df=3)') ) 


end
end