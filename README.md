# kFSA: kernel-based feature space approximation

This repository contains a Matlab implementation of kFSA as introduced in [1]. In the context of kernel-based supervised learning, kFSA can be used to extract relevant samples from the training set whose corresponding feature vectors can be used as a basis of the (implicitly given) feature space. The goal is to reduce the training-data size, resulting in increased performance in terms of storage consumption and computational complexity. Furthermore, the method acts as a regularization procedure. Different examples for the application of kFSA from the field of supervised learning are included.

## Installation

Download or clone the repository and add the main folder to the Matlab path.

## Main files

The main directory contains the files `kFSA.m` and `regression.m`. Given a training data set as well as a kernel function and a threshold value, `kFSA` can be used to reduce the training set. The corresponding kernel-based minimization problems for regression and classification can be solved by the function `regression`. See [1] and the descriptions in the m-files for details on how to apply the functions.

```
kFSA ..................... kernel-based feature space approximation
regression ............... methods for computing minimum-norm solutions of least-square problems
```

## Examples

Numerical experiments from different application areas can be found in the directory `examples`. The included results in the directory `results` (or recalculations of these) can be plotted by the functions `CalCOFI_plot`, `FPU_plot`, `MNIST_plot`.

```
CalCOFI .................. oceanographic time series analysis on CalCOFI data set, see [2]
FPU ...................... system identification on Fermi-Pasta-Ulam-Tsingou model, see [3]
MNIST .................... image classification on MNIST data set, see [4]
```

## Kernels

A small selection of kernel functions used for the supervised-learning tasks in the examples. 

```
gaussian_kernel .......... Gaussian kernel / RBF kernel
mnist_kernel ............. trigonometric kernel for MNIST data set
polynomial_kernel ........ polynomial kernel
```

## References

[1] P. Gelß, S. Klus, I. Schuster, and C. Schütte, "Feature space approximation for kernel-based supervised learning", arXiv, 2020

[2] California Cooperative Oceanic Fisheries Investigations, CalCOFI hydrographic database, 2020

[3] E. Fermi, J. Pasta, and S. Ulam, "Studies of nonlinear problems", Technical Report LA-1940, 1955

[4] Y. Lecun, L. Bottou, Y. Bengio, and P. Haffner, "Gradient-based learning applied to document recognition", Proceedings of the IEEE, 1998







