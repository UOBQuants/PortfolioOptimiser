function port = addConstraints(port, A)
<<<<<<< HEAD
=======
% Author : Giuseppe Mascolo
>>>>>>> master
% addConstraints
% Input: port: portfolio object
%        A: vector of 1 and -1 to indicate short and long
% Output: 
%        port: portfolio object
%
% this function sets contraints for the portfolio object
    
    b=1;    %RHS of the equalities
    
    %set boundary condition for the weights
    lb = -(A < 0);  %lower boundary (0 for long, -1 for short)
    ub = +(A > 0);  %upper boundary (1 for long, 0 for short)
    
    %imposing additional condition that 1% of our wealth should be invested
    %on each asset (in order to meet the requirement of 3 short - 3 long at
    %every time
    lb(lb == 0) = 0.01; 
    ub(ub == 0) = -0.01;
    
    %update the Portfolio object with these constraints
    port = Portfolio(port, 'lowerbound', lb, 'upperbound', ub);
    port = setEquality(port, A, b);

end

