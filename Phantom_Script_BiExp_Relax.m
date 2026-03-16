% This script is used to generate the phantom data to plot the distribution
% figures in the manuscript. The analysis is run as a Monte Carlo Simulation
% with a single signal representation overlayed with different noise reps
%
%   USAGE:
%       Phantom_Script_BiExp_Relax
%
%   OUTPUTS:
%       Distributions from Monte Carlo Sim across different noise representations 
%
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
% If you make any use of the material please cite:
%
% Stabinska J, Thiel TA, Wittsack HJ, Ljimani A, Zöllner HJ. 
% Toward Optimized Intravoxel Incoherent Motion (IVIM) and Compartmental T2 Mapping in Abdominal Organs. 
% Magn Reson Med. 2026 Feb 1:10.1002/mrm.70278. doi: 10.1002/mrm.70278.

%% Generate noise free phantoms with in vivo TE sets
% Prepare
clear all
outputDir =pwd;

% Set up phantom parameters 
% General parameters used for kidney and liver 
% TE parameters match the in vivo data
PhantomPars.N_noise = [0];
PhantomPars.N_rep = 1;
PhantomPars.TR = 4000;
PhantomPars.TE = [47,52,57,62,67,72];

% Parameters specific to kidney 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 1200; 
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 67;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:15:150]; % delta T2 max
PhantomPars.b_values = [0, 30, 70, 100, 200, 750]; 
PhantomPars.ffast = 15/100; % 0.095
PhantomPars.Dslow = 1/1000; % 0.001
PhantomPars.Dfast = 12/1000; % 0.012

% Create data matrix
[PhantomKidney] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250612_Kidney.mat');

% Parameters specific to liver 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:5:60]; % delta T2
PhantomPars.b_values = [0, 10, 20, 100, 200, 550]; % Consensus for Liver  % Consensus for Kidney  [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
PhantomPars.ffast = 9.5/100; % 0.095
PhantomPars.Dslow = 1/1000; % 0.001
PhantomPars.Dfast = 67/1000; % 0.067

% Create data matrix
[PhantomLiver] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250612_Liver.mat');

%% Add noise to data matrix
% Set up noise parameters
NoisePars.N_rep = 2500;         
NoisePars.N_noise = [0.025];

% Add noise to both phantoms
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250612_Kidney.mat');
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250612_Liver.mat');


%% Run Bi-exponential with optimized TE set for kidney phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalOpt function for details. Use LoadOptimData
% to combine data
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1,100,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',101,200,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',201,300,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',301,400,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',401,500,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',501,600,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',601,700,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',701,800,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',801,900,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',901,1000,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1001,1100,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1101,1200,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1201,1300,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1301,1400,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1401,1500,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1501,1600,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1601,1700,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1701,1800,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1801,1900,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',1901,2000,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',2001,2100,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',2101,2200,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',2201,2300,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',2301,2400,3,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Kidney_withNoise.mat'',2401,2500,3,1); "';
system(command);
%% Run Bi-exponential with optimized TE set for liver phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalOpt function for details. Use LoadOptimData
% to combine data
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1,100,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',101,200,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',201,300,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',301,400,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',401,500,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',501,600,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',601,700,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',701,800,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',801,900,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',901,1000,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1001,1100,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1101,1200,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1201,1300,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1301,1400,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1401,1500,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1501,1600,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1601,1700,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1701,1800,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1801,1900,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',1901,2000,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',2001,2100,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',2101,2200,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',2201,2300,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',2301,2400,4,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250612_Liver_withNoise.mat'',2401,2500,4,2); "';
system(command);

%% Generate noise free phantoms with for a larger range of TE sets
% Prepare
clear all
outputDir =pwd;

% General parameters used for kidney and liver 
% TE parameters over a larger range in 5 ms steps
PhantomPars.TE = [50:5:100];
PhantomPars.TR = 4000;
PhantomPars.N_noise = [0];
PhantomPars.N_rep = 1;

% Parameters specific to kidney 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 1200;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 67;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:15:150]; % delta T2 max
PhantomPars.b_values = [0, 30, 70, 100, 200, 750]; % Consensus for Kidney 
PhantomPars.ffast = 15/100; % 0.095
PhantomPars.Dslow = 1/1000; % 0.001
PhantomPars.Dfast = 12/1000; % 0.012

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250614_Kidney.mat');

% Parameters specific to liver 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:5:60]; % delta T2
PhantomPars.b_values = [0, 10, 20, 100, 200, 550]; % Consensus for Liver  
PhantomPars.ffast = 9.5/100; % 0.095
PhantomPars.Dslow = 1/1000; % 0.001
PhantomPars.Dfast = 67/1000; % 0.067

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250614_Liver.mat');

%% Add noise to data matrix
% Set up noise parameters
NoisePars.N_rep = 2500;
NoisePars.N_noise = [0.025];

% Add noise to both phantoms
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250614_Kidney.mat');
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250614_Liver.mat');
%% Run Bi-exponential with optimized TE set for kidney phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalOpt function for details. Use LoadOptimData
% to combine data
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1,100,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',101,200,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',201,300,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',301,400,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',401,500,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',501,600,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',601,700,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',701,800,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',801,900,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',901,1000,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1001,1100,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1101,1200,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1201,1300,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1301,1400,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1401,1500,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1501,1600,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1601,1700,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1701,1800,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1801,1900,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',1901,2000,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',2001,2100,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',2101,2200,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',2201,2300,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',2301,2400,5,1); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Kidney_withNoise.mat'',2401,2500,5,1); "';
system(command);

%% Run Bi-exponential with optimized TE set for liver phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalOpt function for details. Use LoadOptimData
% to combine data
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1,100,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',101,200,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',201,300,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',301,400,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',401,500,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',501,600,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',601,700,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',701,800,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',801,900,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',901,1000,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1001,1100,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1101,1200,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1201,1300,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1301,1400,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1401,1500,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1501,1600,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1601,1700,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1701,1800,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1801,1900,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',1901,2000,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',2001,2100,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',2101,2200,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',2201,2300,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',2301,2400,7,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250614_Liver_withNoise.mat'',2401,2500,7,2); "';
system(command);

%% Generate noise free phantoms for surface plot distributions
%Prepare
clear all
outputDir =pwd;

% Set up phantom parameters 
% General parameters used for kidney
% TE parameters match the in vivo data
PhantomPars.TE = [47,52,57,62,67,72,77,82,87,92];
PhantomPars.TR = [4000];
PhantomPars.N_noise = [0];
PhantomPars.N_rep = 1;

% Parameters specific to liver 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue + [0:300:600]; % delta T1
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [0:15:30]; % delta T2
PhantomPars.b_values = [0, 10, 100, 200, 500, 800];
PhantomPars.ffast = 23/100; % 0.095
PhantomPars.Dslow = 1.09/1000; % 0.001
PhantomPars.Dfast = 70/1000; % 0.012

% Create data matrix
[PhantomKidney] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250701_Liver_General.mat');
%% Add noise to data matrix
% Set up noise parameters
NoisePars.N_rep = 2500;
NoisePars.N_noise = [0.025];

% Add noise to phantom
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250701_Liver_General.mat');
%% Run Bi-exponential without T2 correction for general liver phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalSeparate function for details. Use LoadOptimData
% to combine data.
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1,100,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',101,200,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',201,300,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',301,400,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',401,500,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',501,600,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',601,700,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',701,800,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',801,900,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',901,1000,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1001,1100,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1101,1200,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1201,1300,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1301,1400,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1401,1500,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1501,1600,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1601,1700,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1701,1800,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1801,1900,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1901,2000,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2001,2100,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2101,2200,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2201,2300,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2301,2400,5); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalSeparate(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2401,2500,5); "';
system(command);
%% Run Bi-exponential with optimized TE set for general liver phantom
% We start matlab processes of data packages of 100 each for parallel
% processing of all data. b value and TE value settings are controlled with
% the input parameters at the end. You can also run those functions in
% Matlab directly. See TerminalOpt function for details. Use LoadOptimData
% to combine data
% TerminalOpt(outputdir,pathToDataMatrix,index_1,index_2, optim_method, organ)

command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1,100,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',101,200,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',201,300,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',301,400,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',401,500,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',501,600,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',601,700,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',701,800,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',801,900,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',901,1000,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1001,1100,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1101,1200,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1201,1300,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1301,1400,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1401,1500,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1501,1600,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1601,1700,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1701,1800,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1801,1900,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',1901,2000,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2001,2100,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2101,2200,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2201,2300,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2301,2400,8,2); "';
system(command);
command = 'start matlab -nodisplay -wait -nosplash -batch "addpath(genpath(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'')); TerminalOpt(''C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D'',''20250701_Liver_General_withNoise.mat'',2401,2500,8,2); "';
system(command);

%% Generate noise free phantoms for surface plot
% Prepare
clear all
outputDir =pwd;

% Set up phantom parameters 
% General parameters used for  liver 
% TE parameters match the in vivo data
PhantomPars.b_values = [0, 10, 100, 200, 500, 800];
PhantomPars.TE =  [47,52,57,62,67,72,77,82,87,92];
PhantomPars.TR = [2000, 2500, 3000, 3500, 4000];

% Parameters specific to liver 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue + [0:50:600]; % delta T1
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [0:5:60]; % delta T2
PhantomPars.ffast = 23/100; % 0.095
PhantomPars.Dslow = 1.09/1000; % 0.001
PhantomPars.Dfast = 70/1000; % 0.012

% Create data matrix
[PhantomKidney] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250701_Liver_General_Surface.mat');
%% Add noise to data matrix
% Set up noise parameters
NoisePars.N_rep = 1;
NoisePars.N_noise = [0];

% Add NO noise to phantom
[~] = add_noise_IVIM_T2_phantom(NoisePars,outputDir,'20250701_Liver_General_Surface.mat');

%% Run Bi-exponential with optimized TE set
% Call TerminalOpt directly as we have only 1 dataset per condition
TerminalOpt('C:\Users\Superuser\Documents\MATLAB\IDEALfitting_2D','20250701_Liver_General_Surface_withNoise.mat',1,1,8,2)