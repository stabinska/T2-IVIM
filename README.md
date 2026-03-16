# T2-IVIM

To quantitatively assess the bias in the intravoxel incoherent motions (IVIM)-derived pseudo-diffusion volume fraction (f) caused by the differences in relaxation times between the tissue and fluid compartments, and to develop a two-dimensional (b-value-TE) fitting approach for simultaneous T2 and IVIM parameter estimation, along with an optimal acquisition protocol for the relaxation-compensated T2-IVIM imaging in the liver.

This repository contains the MATLAB scripts used for the analysis described in the following manuscript:

Stabinska J, Thiel TA, Wittsack HJ, Ljimani A, Zöllner HJ. Toward Optimized Intravoxel Incoherent Motion (IVIM) and Compartmental T2 Mapping in Abdominal Organs. Magn Reson Med. 2026 Feb 1:10.1002/mrm.70278. doi: 10.1002/mrm.70278. Epub ahead of print. PMID: 41622737; PMCID: PMC12922574.

The TE_Optimization.m script can be used to run the echo time optimization for the 2D IVIM model. It uses a Genetic Algorithm and requires the Global Optimization Toolbox in MATLAB. 

The Phantom_Script_BiExp_Relax.m script can be used to create the distribution figures shown in the manuscript.

The InVivo_Script_BiExp_Relax_Manuscript.m example script describes how to run the analysis for in vivo data. Unfortunately, no example data could be provided due to privacy issues.

If you make any use of the materials provided in this repository, please cite the above-mentioned manuscript.

