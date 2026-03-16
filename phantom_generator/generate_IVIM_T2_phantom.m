function [DataMatrix] = generate_IVIM_T2_phantom(PhantomPars,outputDir,outputFile,saveOutput)
% This function creates a 2D IVIM phantom dataset using the input
% parameters in the phantom struct. Only a single repetition is created for
% efficiency
%
%   USAGE:
%       [DataMatrix] = generate_IVIM_T2_phantom(PhantomPars,outputDir,outputFile,saveOutput)
%
%   INPUTS: 
%       PhantomPars = struct with phantom parameter settings (see TE_Optimization for example usage)
%       dataDir = path to output directory
%       dataFile = filename of the phantom data
%       saveOutput = flag to save output
%       
%   OUTPUTS:
%       2D IVIM digital phantom data matrix
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
%% Preparations 
if nargin < 4
    saveOutput = 1;
end
%Genrate a single noise free PhantomPars
PhantomPars.N_noise = 0;
PhantomPars.N_rep = 1;

% Matrix dimension definitons:
% 1 - representations
% 2 - noise
% 3 - pixel singelton
% 4 - b values
% 5 - TE
% 6 - TR
% 7 - T1 tissue
% 8 - T1 blood
% 9 - T2 tissue
% 10 - T2 blood

DataMatrix = zeros(1,length(PhantomPars.N_noise),1,length(PhantomPars.b_values),...
                length(PhantomPars.TE),length(PhantomPars.TR),...
                length(PhantomPars.T1_tissue),length(PhantomPars.T1_blood),...
                length(PhantomPars.T2_tissue),length(PhantomPars.T2_blood));

% Create data matrix 
f = waitbar(0, 'Starting');
i = 1;
n = PhantomPars.N_rep * length(PhantomPars.TE) * length(PhantomPars.TR)* length(PhantomPars.T1_tissue) * length(PhantomPars.T1_blood) * length(PhantomPars.T2_tissue) *length(PhantomPars.T2_blood);
for id_rep = 1 : PhantomPars.N_rep
    for id_te = 1: length(PhantomPars.TE)
        for id_tr = 1: length(PhantomPars.TR)
            for id_t1t = 1: length(PhantomPars.T1_tissue)
                for id_t1b = 1: length(PhantomPars.T1_blood)
                    for id_t2t = 1: length(PhantomPars.T2_tissue)
                        for id_t2b = 1: length(PhantomPars.T2_blood)
                            PhantomTemp = PhantomPars;
                            PhantomTemp.T1_tissue = PhantomPars.T1_tissue(id_t1t); 
                            PhantomTemp.T1_blood = PhantomPars.T1_blood(id_t1b); 
                            PhantomTemp.T2_tissue = PhantomPars.T2_tissue(id_t2t); 
                            PhantomTemp.T2_blood = PhantomPars.T2_blood(id_t2b); 
    
                            [S_m_noise]= Phantom_Simulation_BiExp_Relax_Pixel(PhantomTemp,PhantomPars.N_noise,PhantomPars.b_values,PhantomPars.TE(id_te),PhantomPars.TR(id_tr),'relax_norm');
                            DataMatrix(1,:,1,:,id_te,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = S_m_noise;
    
                            waitbar(i/n, f, sprintf('Progress: %d %%', floor(i/n*100)));
                            i = i + 1;
                        end
                    end
                end
            end
        end
    end
    
end

% Save phantom data matrix as .mat file
if saveOutput
    save(fullfile(outputDir,outputFile),'DataMatrix','PhantomPars');
end

end