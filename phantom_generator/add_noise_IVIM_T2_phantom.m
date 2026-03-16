function [DataMatrix] = add_noise_IVIM_T2_phantom(NoisePars,dataDir,dataFile, DataMatrix, saveOutput,PhantomPars)
% This function adds rician noise to a 2D IVIM phantom created using the
% generate_IVIM_T2_phantom function
%
%   USAGE:
%       [DataMatrix] = add_noise_IVIM_T2_phantom(NoisePars,dataDir,dataFile, DataMatrix, saveOutput,PhantomPars)
%
%   INPUTS:
%       NoisePars =  struct with noise parameter (see TE_Optimization for example usage)
%       dataDir = path to directory containing the phantom data
%       dataFile = filename of the phantom data
%       DataMatrix = Phantom data matrix
%       saveOutput = flag to save output
%       PhantomPars = struct with phantom parameter settings (see TE_Optimization for example usage)
%       
%
%   OUTPUTS:
%       2D IVIM digital phantom data matrix with added noise
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
%% Get input parameters from struct and prepare output folder
% Prepare
if ~isempty(dataDir)
    outputDir = dataDir;
    load(fullfile(dataDir,dataFile))
end
if nargin <5
  saveOutput = 1;
end

% Parameters from phantom struct and setup of matrix with noise repetitions
PhantomPars.N_rep = NoisePars.N_rep;
DataMatrix = permute(DataMatrix,[2 3 4 5 6 7 8 9 10 1]);
DataMatrix = repmat(DataMatrix,[1 1 1 1 1 1 1 1 1 PhantomPars.N_rep]);
DataMatrix = permute(DataMatrix,[10 1 2 3 4 5 6 7 8 9]);
DataMatrix = permute(DataMatrix,[1 3 4 5 6 7 8 9 10 2]);
PhantomPars.N_noise =  cat(2,0,NoisePars.N_noise);
DataMatrix = repmat(DataMatrix,[1 1 1 1 1 1 1 1 1 length(PhantomPars.N_noise)]);
DataMatrix = permute(DataMatrix,[1 10 2 3 4 5 6 7 8 9]);
noise = zeros(size(DataMatrix));

% Loop over noise repetitions 
for i = 2 : length(PhantomPars.N_noise)
    if PhantomPars.N_noise(i) > 0
        real_im = normrnd(0, PhantomPars.N_noise(i), PhantomPars.N_rep, 1, 1, length(PhantomPars.b_values),...
                    length(PhantomPars.TE),length(PhantomPars.TR),...
                    length(PhantomPars.T1_tissue),length(PhantomPars.T1_blood),...
                    length(PhantomPars.T2_tissue),length(PhantomPars.T2_blood));
        imag_im = normrnd(0, PhantomPars.N_noise(i), PhantomPars.N_rep, 1, 1, length(PhantomPars.b_values),...
                    length(PhantomPars.TE),length(PhantomPars.TR),...
                    length(PhantomPars.T1_tissue),length(PhantomPars.T1_blood),...
                    length(PhantomPars.T2_tissue),length(PhantomPars.T2_blood));
        noise(:,i,:,:,:,:,:,:,:) = sqrt(real_im.^2 + imag_im.^2);
        real_im = real_im + DataMatrix(:,i,:,:,:,:,:,:,:,:);
        DataMatrix(:,i,:,:,:,:,:,:,:) = sqrt(real_im.^2 + imag_im.^2);
    end
end

% Save phantom data matrix as .mat file
if saveOutput
    save(fullfile(outputDir,strrep(dataFile,'.mat','_withNoise.mat')),'DataMatrix','PhantomPars','noise','-v7.3');
end
end