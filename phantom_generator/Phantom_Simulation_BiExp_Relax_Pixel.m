function [S_m_noise]= Phantom_Simulation_BiExp_Relax_Pixel(Phantom,N,b_values,TE,TR)
% This function creates a 2D IVIM phantom dataset using the input
% parameters in the phantom struct and input parametrs
%
%   USAGE:
%       [S_m_noise]= Phantom_Simulation_BiExp_Relax_Pixel(Phantom,N,b_values,TE,TR)
%
%   INPUTS: 
%       Phantom = struct with phantom parameter settings (see TE_Optimization for example usage)
%       N = number of repetitions for each parameter combinations for MC
%       b_values = b-value settings to simualte
%       TE = echo times
%       TR = repetition times
%       
%   OUTPUTS:
%       Digital phantom containing 2D IVIM data
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
%% Set phantom
fslow =  Phantom.fslow;

finter = Phantom.finter;

ffast = Phantom.ffast;


Dslow = Phantom.Dslow;

Dinter = Phantom.Dinter;


Dfast = Phantom.Dfast;


S0 = Phantom.S0;


T1_tissue = Phantom.T1_tissue;
T1_blood = Phantom.T1_blood;

T2_tissue = Phantom.T2_tissue;
T2_blood = Phantom.T2_blood;

%% Create phantom
%'f*((1-a)*exp(-b*x)  + a*exp(-c*x))'

S_m = zeros(1,length(b_values));
Gfslow = zeros(1,1);
Gffast = zeros(1,1);

for i = 1 :length(b_values)
    S= S_m(:,i);

    fslow = 1-ffast;
    % ffast = 1-fslow;
    Gfslow = fslow;
    Gffast = ffast;
    
    GS0 = S0;
    S = ((fslow * exp(-Dslow*b_values(i))*(1-exp(-TR/T1_tissue))*exp(-TE/T2_tissue))+(ffast * exp(-Dfast*b_values(i))*(1-exp(-TR/T1_blood))*exp(-TE/T2_blood)))...
        /((fslow *(1-exp(-TR/T1_tissue))*exp(-TE/T2_tissue))+(ffast *(1-exp(-TR/T1_blood))*exp(-TE/T2_blood)));
   
    S_m(:,i)=S;
end


%% Add noise to image

S_m_noise = zeros(numel(N), 1, length(b_values));
noise = zeros(numel(N), 1);
for i = 1:numel(N)   
    for j = 1:length(b_values)
        real_im = normrnd(0, N(i), 1);
        imag_im = normrnd(0, N(i), 1);
        if j == 1
            noise(i,:) = sqrt(real_im.^2 + imag_im.^2);
        end
        real_im = real_im + S_m(:, j);
        S_m_noise( i,:, j) = sqrt(real_im.^2 + imag_im.^2);
        
    end
end

end