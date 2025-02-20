function [Pg_star] = PMP(pl, t, T, N, del, eta, alpha, Emax, b, x0_guess)
% pl - consumption profile over timehorizon Time
% t - time vector over time horizon [0,T]
% T - time horizon, e.g. 24 hrs
% N - number of sample, e.g 48
% alpha - % grid parameter R/V_g^2
% eta - dissipation function 
% Emax - capacity of the storage
% b - constant for quadratic cost function f(x) = b*x^2
% x0_guess - it is the initial condition of the state [perform binary search iteratively until convergence]

model_name = 'pow_version_1_sim.slx';

[user,sys] = memory;%place in the begging of your program
tic


% problem parameters - internal use
alpha = 0; 
Pbar = inf; 
cm = 0; 
% the cost of power generation: cg(z) = g*z^2 
% the cost of ramping: cd(z) = d*z^2
g = b;
d = 0;

% simulation parameters
sim_step = dt/1000; % simulation step time
rel_tol = 1e-6; % simulation relative tolerance
x0=x0_guess;
lambda0 = 0; % lambda initial condition

pl_data.time=t';
pl_data.signals.values = pl';

% run simulation
open_system(model_name);
out = sim(model_name); % most basic way to simulate with command script.
fprintf('simulation done.');

toc

[user2,sys2] = memory;%place in the end of your program
memory_used_in_bytes=user2.MemAvailableAllArrays-user.MemAvailableAllArrays;

% process simulation results
ts = out.ts;
x_star = out.x_star;
lambda_star = out.lambda_star;
Pg_star = x_star;


