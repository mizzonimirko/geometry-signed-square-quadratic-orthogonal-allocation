# Geometry of Signed-Quadratic Orthogonal Allocation

This repository contains the MATLAB/Simulink implementation used for the numerical validation of the orthogonal allocation framework for signed-quadratic actuation systems.

The code accompanies the paper:

**Global Geometry of Orthogonal Foliations in the Control Allocation of Signed-Quadratic Systems**

The implementation focuses on the application of the proposed allocation method to a collinear hexarotor with `n = 6` actuators and a `m = 4` dimensional wrench task.

# Main files

* Main.mlx
    Main script used to initialize parameters, run the Simulink model, and generate the figures.
* controller.slx
    Simulink model containing the geometric controller, the orthogonal allocation block, and the hexarotor dynamics.
* Init Files/
    Initialization scripts for the hexarotor parameters, allocation matrix, augmented matrix, controller gains, and simulation settings.
* Utilities/
    MATLAB helper functions for allocation, plotting, benchmarking, and signal processing.
* Figures/
    Folder where generated figures are saved.


# Getting Started

Requirements

The code was tested with:

* MATLAB R2024b
* Simulink
* macOS
* Apple M3 Pro system-on-chip, 11-core CPU, 18 GB unified memory

Other recent MATLAB/Simulink versions should also work, but have not been explicitly tested.

# Citation

If you use this code, please cite the corresponding paper:

```bibtex
@article{franchi_mizzoni_signed_quadratic_orthogonal_allocation,
  title   = {Global Geometry of Orthogonal Foliations in the Control Allocation of Signed-Quadratic Systems},
  author  = {Franchi, Antonio and Mizzoni, Mirko},
  journal = {Preprint},
  year    = {2026}
}
```
