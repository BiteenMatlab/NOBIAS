# NOBIAS

The NOBIAS algorithm (NOnparametric Bayesian Inference for Anomalous diffusion in Single-molecule tracking) is a two-module algorithm for analysis of multi-diffusive state SPT datasets that predicts the anomalous diffuion type for each state.


Written by Ziyuan Chen at the University of Michigan.

## Installation

Download the entire folder and unzip if you downloaded the .zip folder. Change the working directory in Matlab to this folder and call the functions in the Matlab command window as described in the User Guide.

NOBIAS also require the lightspeed toolbox in matlab which could be found (https://github.com/tminka/lightspeed)

## Usage

A quick start guide now.

A detailed user guide to be finished very soon.

## Credits


Great thanks to the work of Dr. Emily B. Fox inspires my to use her sticky HDP-HMM for SPT datasets.


**_randdirichlet_** and **_randiwishart_** by Emily B. Fox and Erik B. Sudderth.(ebfox[at]alum[dot]mit[dot]edu and sudderth[at]cs[dot]brown[dot]edu)

Copyright (C) 2009, Emily B. Fox and Erik B. Sudderth.

The HDPHMM module majorly adapt the algorithm in the:

  An HDP-HMM for Systems with State Persistence
  E. B. Fox, E. B. Sudderth, M. I. Jordan, and A. S. Willsky
  Proc. Int. Conf. on Machine Learning, July, 2008.

lightspeed toolbox MATLAB, Tom Minka.

Copyright (c) 2017 Tom Minka

The RNN module uses the LSTM arichtecture of RANDI python package and implement in MATLAB.
Argun, A., Volpe, G., and Bo, S. (2021). Classi?cation, inference and segmentation of anomalous di?usion with recurrent neural networks. J. Phys. A: Math. Theor. doi:10.1088/1751-8121/ac070a.
 

## License

                      GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

  See LICENSE.txt
