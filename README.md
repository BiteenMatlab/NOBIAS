# NOBIAS

The NOBIAS algorithm (NOnparametric Bayesian Inference for Anomalous diffusion in Single-molecule tracking) is a two-module algorithm for analysis of multi-diffusive state SPT datasets that predicts the anomalous diffuion type for each state.


Written by Ziyuan Chen at the University of Michigan.

## Installation

Download the entire folder and unzip if you downloaded the .zip folder. Change the working directory in Matlab to this folder and call the functions in the Matlab command window as described in the User Guide.

NOBIAS also requires the lightspeed toolbox in Matlab which can be found at https://github.com/tminka/lightspeed

Running the RNN module needs the MATLAB Deep Learning toolbox: https://www.mathworks.com/products/deep-learning.html

## Usage

Use the quick start guide for now: https://github.com/BiteenMatlab/NOBIAS/blob/main/NOBIAS%20Quick%20Start%20Guide.pdf

A detailed user guide will be finished very soon.

## Credits


Great thanks to the work of Dr. Emily B. Fox who inspired me to use her sticky HDP-HMM for SPT datasets.


**_randdirichlet_** and **_randiwishart_** by Emily B. Fox and Erik B. Sudderth.(ebfox[at]alum[dot]mit[dot]edu and sudderth[at]cs[dot]brown[dot]edu)

Copyright (C) 2009, Emily B. Fox and Erik B. Sudderth.

The HDPHMM module majorly adapts the algorithm in:

  An HDP-HMM for Systems with State Persistence
  E. B. Fox, E. B. Sudderth, M. I. Jordan, and A. S. Willsky
  Proc. Int. Conf. on Machine Learning, July, 2008.

lightspeed toolbox MATLAB, Tom Minka.

Copyright (c) 2017 Tom Minka

The RNN module uses the LSTM arichtecture of the RANDI python package and implement in MATLAB.
Argun, A., Volpe, G., and Bo, S. (2021). Classification, inference and segmentation of anomalous diffusion with recurrent neural networks. J. Phys. A: Math. Theor. doi:10.1088/1751-8121/ac070a.
 

## License

                      GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

  See LICENSE.txt
