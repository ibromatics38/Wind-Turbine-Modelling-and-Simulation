# Wind-Turbine-Modelling-and-Simulation

# Wind Turbine Simulation: Aerodynamic, Mechanical, and Control Modeling 🌬️⚙️

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023b%2B-blue.svg)](https://mathworks.com)
[![Simulink](https://img.shields.io/badge/Simulink-Required-orange.svg)](https://mathworks.com/products/simulink.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.123456789.svg)](https://doi.org/10.5281/zenodo.123456789) <!-- Optional -->

A comprehensive MATLAB/Simulink model of a wind turbine, simulating aerodynamic forces, drivetrain dynamics, tower/blade structural responses, and region-specific control strategies. Developed as part of the AUTORESYS project under Prof. Horst Schulte.

![Wind Turbine Simulation Demo](images/simulation_demo.gif) <!-- Add your screenshot/GIF -->

## Table of Contents
- [Key Features](#key-features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Report](#report)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Key Features ✨
- **Aerodynamic Modeling**: Torque and thrust calculations using CQ/CT curves (Eqs. 6-7).
- **4-DOF Mechanical System**: Simulates drivetrain, tower, and blade dynamics (Section 3).
- **Multi-Region Control**: 
  - **Region 1-2.5**: Power optimization via linear control laws (Fig. 16-17).
  - **Region 3**: PI pitch control for power limiting (Fig. 21-22).
- **Simulink Modules**: 
  - Aerodynamic subsystem (Fig. 7-8)
  - Drivetrain dynamics (Fig. 4-5)
  - Control decision algorithm (Fig. 15)

## Installation 💻
1. **Prerequisites**:
   - MATLAB R2023b or later
   - Simulink, Control System Toolbox, Symbolic Math Toolbox
2. Clone the repository:
   ```bash
   git clone https://github.com/your-username/wind-turbine-sim.git
   cd wind-turbine-sim
