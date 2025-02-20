function [Pg_star] = DP(pl, t, T, N, eta, alpha, Emax, M, b)

% pl - consumption profile over timehorizon Time
% t - time vector over time horizon [0,T]
% T - time horizon, e.g. 24 hrs
% N - number of sample, e.g 48
% alpha - % grid parameter R/V_g^2
% eta - dissipation function 
% Emax - capacity of the storage
% M - number of energy levels, e.g. 1000
% b - constant for quadratic cost function f(x) = b*x^2

[user,sys] = memory; % calculate memory consumption

tic % calculate running time

% solution with dynamic programming for optimal storage control with
% transmission line losses and lossy storage


% problem parameters
del = T/N;
dE = Emax/(M-1); % energy resolution -> e = dE*(m-1), with m=1,...,M

% forward recursion 
% initialize V
V = zeros(M,N)*NaN;

% for the case k=1:
for m = 1:M
    E1 = dE*(m-1);
    P1 = E1/(del*eta);
    Ptmp = P1+pl(1);
    x = Ptmp + alpha * Ptmp^2;
    V(m,1) = del*(b*x^2);
end


for k = 2:N % index of time
    for m = 1:M % index of Ek
        Ek = dE*(m-1);        
        A = zeros(1,M);
        for w = 1:M % index of E(k-1)
            Eprev = dE*(w-1);
            P = (Ek-Eprev)/(del*eta);
            Ptmp = P+pl(k);
            x = Ptmp + alpha * Ptmp^2; 
            A(w) = V(w,k-1) + del*(b*x^2);
        end
        V(m,k) = min(A);
    end
end

% backward recursion
Estar = zeros(1,N);

% for the case k=N
[~,I] = min(V(:,N));
I = I(1);
Estar(N) = (I-1)*dE;

for k=N:-1:2
    Ek = Estar(k);
    A = zeros(1,M);
    for w = 1:M % index of E(k-1)
        Eprev = dE*(w-1);
        P = (Ek-Eprev)/(del*eta);
        Ptmp = P+pl(k);
        x = Ptmp + alpha * Ptmp^2; 
        A(w) = V(w,k-1) + del*(b*x^2);
    end
    [~,I] = min(A);
    I = I(1);
    Estar(k-1) = (I-1)*dE;
end

% optimal power calculation
Pstar = zeros(1,N);
Pstar(1) = Estar(1)/(del*eta);

for k = 2:N
    Pstar(k) = (Estar(k)-Estar(k-1))/(del*eta);
end

Pg_star = pl' + Pstar + alpha*(pl' + Pstar).^2;
Eg_star = del*cumsum(Pg_star);

El = del*cumsum(pl);

toc

[user2,sys2] = memory;%place in the end of your program
memory_used_in_bytes=user2.MemAvailableAllArrays-user.MemAvailableAllArrays;

% plot signals
figure(1)
subplot(3,1,1);
plot(t, pl, 'b-');
hold on;
plot(t, Pg_star, 'r-');
hold off;
xlim([0,T]);
ylabel('powers');

subplot(3,1,2);
plot(t, Estar, 'b-');
hold on;
plot(t, Emax*t.^0, 'k--');
hold off;
xlim([0,T]);
ylabel('Estar');

subplot(3,1,3);
plot(t, Eg_star, 'b-');
hold on;
plot(t, El, 'k--');
plot(t, El+Emax, 'k--');
hold off;
xlim([0,T]);
ylabel('Eg, El');

xlabel('Time [h]');

end


