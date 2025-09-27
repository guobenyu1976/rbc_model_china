// -----------------------------------------------------------------------------
// REAL BUSINESS CYCLE (RBC) MODEL WITH GROWTH - CALIBRATED FOR THE CHINESE ECONOMY
//
// Description: This is a standard neoclassical growth model, recalibrated to match
//              key stylized facts of the Chinese economy, such as high growth,
//              high investment rate, and a high capital-to-output ratio.
//              The model has been stationarized (detrended).
// -----------------------------------------------------------------------------

// -------------------------------
// 1. VARIABLE AND PARAMETER DECLARATION
// -------------------------------

// Endogenous Variables (all variables are stationarized/detrended)
var y   (long_name='Output')
    c   (long_name='Consumption')
    k   (long_name='Capital')
    i   (long_name='Investment')
    L   (long_name='Labor')
    w   (long_name='Real Wage')
    r   (long_name='Rental Rate of Capital')
    z   (long_name='Technology Shock (in log form)');

// Exogenous Shocks
varexo e_z (long_name='Technology shock');

// Parameters
parameters beta   (long_name='Discount factor')
           alpha  (long_name='Capital share')
           delta  (long_name='Capital depreciation rate')
           psi    (long_name='Weight on labor in utility')
           phi    (long_name='Inverse Frisch elasticity of labor supply')
           g      (long_name='Technological growth rate')
           rho_z  (long_name='Autocorrelation of technology shock')
           sigma_z (long_name='Standard deviation of technology shock');

// -------------------------------
// 2. PARAMETER CALIBRATION (TARGETING CHINESE ECONOMY)
// -------------------------------
// Calibration is based on quarterly frequency, targeting long-run features of China.

// Key Annual Targets:
// 1. TFP Growth: ~3%
// 2. Investment-to-GDP Ratio: ~42%
// 3. Capital-to-Output Ratio: ~3.46
// 4. Capital Share: ~45%

g       = (1+0.03)^(1/4) - 1; // Quarterly TFP growth rate matching 3% annually.
alpha   = 0.45;               // Capital's share in output, higher than developed economies.
delta   = 0.023;              // Quarterly depreciation rate. Calibrated to match a ~42% annual
                              // investment rate given K/Y and g.
                              // Derivation: delta_ann = (I/Y)/(K/Y) - g_ann = 0.42/3.46 - 0.03 = 0.091
                              // delta_q = 1-(1-0.091)^(1/4) = 0.023

beta    = 0.999;              // Discount factor. Calibrated to be consistent with the steady-state
                              // real interest rate implied by K/Y and alpha. A high beta
                              // reflects high savings (patience).
                              // Derivation: r_ann = alpha/(K/Y) = 0.45/3.46 = 0.13.
                              // r_q = (1+0.13)^(1/4)-1 = 0.031.
                              // beta = (1+g)/(r_q+1-delta) = (1+0.0074)/(0.031+1-0.023) = 0.999

phi     = 1.0;                // Inverse of the Frisch elasticity, standard value.
rho_z   = 0.96;               // Persistence of the technology shock, slightly higher persistence.
sigma_z = 0.008;              // Volatility of the technology shock, slightly higher volatility.
psi = 0.0;

// psi will be endogenously determined in the steady state block to ensure
// steady-state labor supply L_ss = 1/3.

// -------------------------------
// 3. MODEL EQUATIONS (Unchanged)
// -------------------------------
model;
y = exp(z) * k(-1)^alpha * L^(1-alpha);
r = alpha * y / k(-1);
w = (1-alpha) * y / L;
1/c = beta * (1+g)^(-1) * (1/c(+1)) * (1+r(+1)-delta);
psi * L^phi * c = w;
y = c + i;
(1+g)*k = (1-delta)*k(-1) + i;
z = rho_z * z(-1) + e_z;
end;

// -------------------------------
// 4. STEADY STATE CALCULATION (Unchanged logic, will use new parameters)
// -------------------------------
steady_state_model;
    z = 0;
    r = (1+g)/beta - (1-delta);
    y_k_ratio = r / alpha;
    k_L_ratio = y_k_ratio^(1/(alpha-1));
    L = 1/3;
    k = k_L_ratio * L;
    y = y_k_ratio * k;
    i = (g+delta)*k;
    c = y - i;
    w = (1-alpha)*y/L;
    psi = w / (c*L^phi);
end;

// Check if the steady state is correctly computed
check;

// -------------------------------
// 5. SHOCKS AND SIMULATION
// -------------------------------
shocks;
    var e_z; stderr sigma_z;
end;

steady;
check;
stoch_simul(order=1, irf=40) y c i k L w r;

// -------------------------------
// 6. VERIFY CALIBRATION TARGETS
// -------------------------------
// Retrieve steady-state values from the results structure 'oo_'
y_pos = strmatch('y', M_.endo_names, 'exact');
c_pos = strmatch('c', M_.endo_names, 'exact');
k_pos = strmatch('k', M_.endo_names, 'exact');
i_pos = strmatch('i', M_.endo_names, 'exact');
r_pos = strmatch('r', M_.endo_names, 'exact');
y_ss = oo_.steady_state(y_pos);
c_ss = oo_.steady_state(c_pos);
k_ss = oo_.steady_state(k_pos);
i_ss = oo_.steady_state(i_pos);
r_ss = oo_.steady_state(r_pos);

// Display key steady-state ratios (annualized) to verify calibration
disp('--- Steady-State Ratios (Annualized) ---');
disp(['Capital-to-Output Ratio (K/Y):   ', num2str(k_ss/(4*y_ss))]);
disp(['Investment-to-Output Ratio (I/Y):', num2str(i_ss/y_ss)]);
disp(['Consumption-to-Output Ratio (C/Y):', num2str(c_ss/y_ss)]);
disp(['Real Interest Rate (annualized): ', num2str( ((1 + r_ss)^4 - 1) * 100), '%' ]);
