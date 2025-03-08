

% Define constants and parameters
c1 = 0.005; c2 = 1.53; c3 = 0.5; c4 = 0.18; c5 = 121;
c6 = 27.9; c7 = 198; c8 = 2.36; c9 = 5.74; c10 = 11.35;
c11 = 16.1; c12 = 201;
rho = 1.225; % Air density (kg/m^3)
R = 63; % Rotor radius (m)
J = para_mdl.Jr + para_mdl.ngear^2 * para_mdl.Jg; % Combined inertia

% Wind turbine pitch angles (beta) and wind speeds (v)
beta = [0.0000, 0.0306, 0.0560, 0.0772, 0.0953, 0.1113, 0.1254, 0.1382, ...
        0.1499, 0.1607, 0.1783, 0.2134, 0.2421, 0.2669, 0.2890, 0.3091, ...
        0.3279, 0.3456, 0.3625, 0.3789]';
v = [11.2600, 11.5378, 11.8156, 12.0933, 12.3711, 12.6489, 12.9267, ...
     13.2044, 13.4822, 13.7600, 14.2600, 15.4533, 16.6467, 17.8400, ...
     19.0333, 20.2267, 21.4200, 22.6133, 23.8067, 25.0000]';
omega_r = 1.2671; % Rated rotor speed (rad/s)

% Define auxiliary functions
lambda_i = @(lambda, beta) 1 ./ (lambda + 0.08 * beta) - 0.035 ./ (c11 + c12 * beta.^3);
f1 = @(lambda) c4 ./ lambda;
f2 = @(lambda, beta) c5 * lambda_i(lambda, beta) - c6 * beta - c7 * beta.^c8 - c9;
f3 = @(lambda, beta) exp(-c10 * lambda_i(lambda, beta));

% Define derivatives of lambda_i
dlambda_i_dlambda = @(lambda, beta) -1 ./ (lambda + 0.08 * beta).^2;
dlambda_i_dbeta = @(lambda, beta) -0.08 ./ (lambda + 0.08 * beta).^2 + ...
                                   (3 * 0.035 * c12 * beta.^2) ./ (c11 + c12 * beta.^3).^2;

% Define analytical CQ function and its derivatives
cQ_tilde = @(lambda, beta) c1 * (1 + c2 * (beta + c3).^0.5) + ...
                          f1(lambda) .* f2(lambda, beta) .* f3(lambda, beta);
cQ = @(lambda, beta) cQ_tilde(lambda, beta) .* (1 + sign(cQ_tilde(lambda, beta))) / 2;

dcQ_dlambda = @(lambda, beta) -c4 ./ lambda.^2 .* f2(lambda, beta) .* f3(lambda, beta) + ...
                              f1(lambda) .* (c5 * dlambda_i_dlambda(lambda, beta)) .* f3(lambda, beta) + ...
                              f1(lambda) .* f2(lambda, beta) .* ...
                              (-c10 * exp(-c10 * lambda_i(lambda, beta)) .* dlambda_i_dlambda(lambda, beta));

dcQ_dbeta = @(lambda, beta) f1(lambda) .* (c5 * dlambda_i_dbeta(lambda, beta) - c6 - ...
                  c7 * c8 * beta.^(c8 - 1)) .* f3(lambda, beta) + ...
                  f1(lambda) .* f2(lambda, beta) .* ...
                  (-c10 * exp(-c10 * lambda_i(lambda, beta)) .* dlambda_i_dbeta(lambda, beta)) + ...
                  0.5 * c1 * c2 * (beta + c3).^(-0.5);

% Lambda as a function of wind speed and rotor speed
lambda = @(V, omega_r) omega_r * R ./ V;

% Initialize vectors for results
k_omega = zeros(length(v), 1);
k_beta = zeros(length(v), 1);
k_V = zeros(length(v), 1);

% Compute coefficients for each wind speed
for i = 1:length(v)
    k_omega(i) = 0.5 * rho * v(i)^2 * pi * R^3 * ...
                 (R / v(i) * dcQ_dlambda(lambda(v(i), omega_r), beta(i)));
    k_beta(i) = 0.5 * rho * v(i)^2 * pi * R^3 * ...
                dcQ_dbeta(lambda(v(i), omega_r), beta(i));
    k_V(i) = 0.5 * rho * pi * R^3 * ...
             (2 * v(i) * cQ(lambda(v(i), omega_r), beta(i)) - ...
              omega_r * R * dcQ_dlambda(lambda(v(i), omega_r), beta(i)));
end

% Compute control parameters
tau_ref = 4;
a = -k_omega / J;
b = k_beta / J;
k_P = 5./(b.*tau_ref);
k_I = a./(b.*tau_ref);

% Create a table with results and export to Excel
resultsTable = table(v, k_omega, k_beta, k_V, k_P, k_I, ...
    'VariableNames', {'WindSpeed', 'k_omega', 'k_beta', 'k_V', 'k_P', 'k_I'});
writetable(resultsTable, 'output1.xlsx');
