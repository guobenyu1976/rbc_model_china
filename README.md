# Real Business Cycle Model (China Calibration)

## Overview
This project implements a **Real Business Cycle (RBC)** model with long-term growth, explicitly calibrated to match key macroeconomic features of the **Chinese economy**.  
The model is written in **Dynare** and follows a standard neoclassical growth structure, but incorporates data-based modifications to reflect China's high growth rate, high investment share, and capital-output ratio.

## Key Features
- **DSGE framework**: Standard RBC dynamics with labor-leisure choice, capital accumulation, technology shocks, and endogenous consumption/investment.
- **Chinese economy calibration**: Parameters are chosen to reproduce stylized facts based on Chinese macroeconomic data, such as:
  - Annual TFP growth ≈ 3%
  - Investment-to-GDP ratio ≈ 42%
  - Capital-to-Output ratio ≈ 3.46
- **Stationarized variables**: The model is detrended to remove long-run growth effects and allow steady-state analysis.
- **Shock simulation**: Technology shocks with high persistence and volatility are tested, generating impulse response functions (IRFs) over 40 quarters.

## Model Structure
1. **Variables & Parameters**  
   - Endogenous: Output, Consumption, Capital, Investment, Labor, Wage, Rental Rate of Capital, Technology.
   - Exogenous: Technology shocks.
   - Parameters: Discount factor, capital share, depreciation rate, labor preference weight, growth rate, shock persistence, and volatility.

2. **Calibration Process**  
   - Based on quarterly frequency.
   - Uses macro ratios and growth targets to back out implied parameters via steady-state relationships.

3. **Equations**
   - Production function: Cobb–Douglas form with technology factor.
   - Euler equation: Intertemporal optimization with growth adjustment.
   - Labor supply: Derived from utility maximization.
   - Capital accumulation: Includes depreciation and investment.

4. **Simulation & Steady State**
   - Computes steady states from analytical relationships.
   - Runs stochastic simulations with technology shocks.
   - Verifies calibration targets by computing steady-state ratios and interest rates.

<img width="920" height="455" alt="9c12c85a-1c77-4872-a791-f53b291421c0" src="https://github.com/user-attachments/assets/e77a427b-9103-4837-9069-94a1521dbb3f" />


## Files
- `RBC_growth_china.mod` — Dynare model file containing the entire calibration, model definition, and simulation.

## Requirements
- **Dynare** (version ≥ 4.6)
- **MATLAB** or **GNU Octave**

## How to Run
1. Install Dynare and ensure it is added to your MATLAB/Octave path.
2. Clone this repository:
   ```bash

   git clone https://github.com/guobenyu1976/rbc_model_china
