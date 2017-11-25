%%
% *Heuristic Test Backtesting*

%%
% *Genrating IID and Non-IID variables*
mu = 0;
sigma = 0.7;
n = 365; %Simulating one year data
C = 1; %Coefficient of dependence to the previous day

X = normrnd(mu,sigma,n,1); % n number of IID random number
pX = [0 ; X(1:end-1)].*C; %Pertubation vector
NX = X + pX;     %Creating Non IID X as NX.

%%
addpath('../')
addpath('../Heuristic_test_sub_functions')
Heuristic_Test(X, 'IID invariant', true)
Heuristic_Test(NX, 'Non-IID invariant', true)