## Scripts for Structure Generation and Analysis

This directory contains scripts used to generate and analyze molecular structures. Below is a brief description of each script:

### Alignment and Grid Manipulation
- **[align_grid.py](./align_grid.py)**  
    Aligns the Q0 and Q1 grids by superimposing benzene rings. Additionally, it aligns dipole moment components found in the comments of each structure. This script is essential for analysis.

### Helium Icosahdedron Addition
- **[Add12He.py](./Add12He.py)**  
    Adds a Helium icosahedron with a specified apothem to the structure.

### Energy Scan Input Generation
- **[run_Q0_H2O.sh](./run_Q0_H2O.sh)**  
    Generates input files for energy scans involving additional molecules. It utilizes the following files:
    - **[head.in](./head.in)**: Contains the fixed Q0 geometry.
    - **[template.in](./template.in)**: Defines input file parameters.
    - **[add_H2O.py](./add_H2O.py)**: Creates an H2O `.xyz` file at a specified distance from a point, following a vector and aligning the molecule with that vector. By modifying the molecule, this script can be used to generate scans for other molecules.

---
Each script is designed to streamline the process of structure generation and facilitate computational analysis.

