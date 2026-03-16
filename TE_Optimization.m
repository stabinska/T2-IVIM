% This script uses phantom 2D IVIM data to run a optimization to find the
% optimal TE combinations for the 2D IVIM model using a genetic algorithm.
% The optimization function uses CRLBs, as proxy vor variance estimator and
% the bias calcualted from the ground truth to minimize bias and variance
% for the f_fast estimates.
% You can also run larger distributions to estimate the variance but this
% will take longer than the CRLB approach. Set PhantomPars.crlb = 0 to use
% distribution based estimates instead, you have to increase
% NoisePars.N_rep though
%
%   USAGE:
%       TE_Optimization
%
%   OUTPUTS:
%       Optimal TE set combinations
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

% Parameters specific to kidney 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 1200;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 67;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:15:150]; % delta T2 max
PhantomPars.TE = [47,52,57,62,67,72];
PhantomPars.TR = 4000;
PhantomPars.b_values = [0, 30, 70, 100, 200, 750]; 
PhantomPars.ffast = 15/100;
PhantomPars.Dslow = 1.55/1000;
PhantomPars.Dfast = 6.7/1000;

% Create data matrix
[DataMatrix] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250612_Kidney.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;
PhantomPars.Organ = 'Kidney_invivo';

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);
    
    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];
    
    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_Kidney.mat','TE_opt');
end


%% Liver 3T
% Parameters specific to liver 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:5:60]; % delta T2
PhantomPars.b_values = [0, 10, 20, 100, 200, 550]; % Consensus for Liver  % Consensus for Kidney  [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
PhantomPars.ffast = 9.5/100;
PhantomPars.Dslow = 1/1000;
PhantomPars.Dfast = 67/1000;

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250605_Liver.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;
PhantomPars.Organ = 'Liver_invivo';

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);

    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];

    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_Liver.mat','TE_opt');
end

%% Here we use a larger TE range
% Prepare
clear all
outputDir =pwd;

% Parameters specific to kidney 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 1200;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 67;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:15:150]; % delta T2 max
PhantomPars.TE = [50:5:100];
PhantomPars.TR = 4000;
PhantomPars.b_values = [0, 30, 70, 100, 200, 750]; 
PhantomPars.ffast = 15/100;
PhantomPars.Dslow = 1.55/1000;
PhantomPars.Dfast = 6.7/1000;

% Create data matrix
[DataMatrix] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250612_Kidney.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;
PhantomPars.Organ = 'Kidney_invivo';

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);
    
    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];
    
    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_Kidney_Free.mat','TE_opt');
end

%% Liver 3T
% Parameters specific to kidney 3T phantom
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 27;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [15:5:60]; % delta T2
PhantomPars.b_values = [0, 10, 20, 100, 200, 550]; % Consensus for Liver  % Consensus for Kidney  [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
PhantomPars.ffast = 9.5/100;
PhantomPars.Dslow = 1/1000;
PhantomPars.Dfast = 67/1000;

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250605_Liver.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;
PhantomPars.Organ = 'Liver_invivo';

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);

    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];

    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_Liver_Free.mat','TE_opt');
end

%% Here we do all b values that we had in vivo 
% Prepare
clear all
outputDir =pwd;

% Parameters specific to kidney cortex 3T phantom
PhantomPars.S0 = 184; % Not used becuase we do 1/relax
PhantomPars.T1_tissue = 800;
PhantomPars.T1_blood = PhantomPars.T1_tissue ; % delta T1 max = 1000 ms
PhantomPars.T2_tissue = 40;
PhantomPars.T2_blood = PhantomPars.T2_tissue + [0:5:50]; % delta T2 max = 100 ms
PhantomPars.TE = [47,52,57,62,67,72];
PhantomPars.TR = 4000;
PhantomPars.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
PhantomPars.ffast = 20.1/100;
PhantomPars.Dslow = 1.919/1000;
PhantomPars.Dfast = 24.964/1000;

% Create data matrix
[DataMatrix] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250428_Kidney_Cortex.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);

    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];

    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_cortex_all_b.mat','TE_opt');
end

% Parameters specific to kidney medulla 3T phantom
PhantomPars.ffast = 18/100;
PhantomPars.Dslow = 1.796/1000;
PhantomPars.Dfast = 29.02/1000;

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250428_Kidney_Medulla.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);

    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];

    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_medulla_all_b.mat','TE_opt');
end

% Parameters specific to liver 3T phantom
PhantomPars.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750]; 
PhantomPars.ffast = 23.05/100;
PhantomPars.Dslow = 1.09/1000;
PhantomPars.Dfast = 70.02/1000;

% Create data matrix
[~] = generate_IVIM_T2_phantom(PhantomPars,outputDir,'20250413_Liver.mat');

% Setup noise pars and CRLB flag
PhantomPars.N_noise = 1;
PhantomPars.N_rep = [0.025];
PhantomPars.crlb = 1;

% Setup genetic algorithm with parallel computing
options = optimoptions('ga', ...
    'FunctionTolerance', 1e-3,'ConstraintTolerance', 1e-16,'Display', 'iter',...
    'UseParallel', true,'PopulationSize',10000,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotbestindiv},'MaxGenerations',100,... 
    'CreationFcn', @myCreationFcn);

% Loop over TE set with different length
TE_opt = cell(1,4);
for opt = 1 : 4

    intcon = 1:opt+1;
    n = length(intcon);

    A = [];
    b =[];
    Aeq = [];
    beq = [];
    lb = 1:opt+1;
    ub = length(PhantomPars.TE)-length(intcon)+1:1: length(PhantomPars.TE);
    nonlcon = [];

    TE_opt{opt} = ga(@(intcon) optim_TE_2D_IVIM(intcon,DataMatrix,PhantomPars), length(ub), A, b, Aeq, beq, lb, ub,@myNonlinearConstraints,intcon, options);
    save('OptimTE_Liver_all_b.mat','TE_opt');
end