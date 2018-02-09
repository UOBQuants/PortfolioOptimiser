function port = addConstraints(port, A)
% Author : Giuseppe Mascolo
% addConstraints
% Input: port: portfolio object
%        A: vector of 1 and -1 to indicate short and long
% Output: 
%        port: portfolio object
%
% this function sets contraints for the portfolio object
    
    b=1;    %RHS of the equalities
    lb = -(A < 0);
    ub = +(A > 0);
    lb(lb == 0) = 0.01;
    ub(ub == 0) = -0.01;
    port = Portfolio(port, 'lowerbound', lb, 'upperbound', ub);
    port = setEquality(port, A, b);

end

