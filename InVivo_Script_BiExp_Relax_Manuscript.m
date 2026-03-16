% This script is used to analyze the in vivo data for the manuscript.
%   USAGE:
%       InVivo_Script_BiExp_Relax_Manuscript
%
%   OUTPUTS:
%       IVIM parameter maps for different models
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

%% Prepare workspace and clean up
clear all
clc

%% Set up organ and TE set 
organ = 'liver';       % options are kidney and liver
init = 'set_1';         % ini, lb, ub set options are set_1 and set_2 see below
start_TE_set = 1;       % TE set to start with 

for subject = 1 : 4     % Loop over all subjects

    % Pick the right data and masks path for each subject
    % Also pick the correct slice for each subject
    switch subject      
        case 1              % Subject 1               
            % Data path
            files_TE = {'/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/14_DTI_PGSE_TE47_Delta20_delta6_2_71301.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/16_DTI_PGSE_TE52_Delta20_delta6_2_72164.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/18_DTI_PGSE_TE57_Delta20_delta6_2_73027.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/20_DTI_PGSE_TE62_Delta20_delta6_2_73890.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/22_DTI_PGSE_TE67_Delta20_delta6_2_74753.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/24_DTI_PGSE_TE72_Delta20_delta6_2_75616.nii.gz'};
            
            % Load kidney and liver mask
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/mask_liver.mat','Mask_liver_sl2')
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Delta-Niere08_GAPF08553/20200826_1617/Mask_sl1.mat','Mask_sl1')

            % Overwrite mask and slice according to organ choice
            switch organ
                case 'liver'
                    mask = Mask_liver_sl2;  % Pick mask
                    slice = 1;  % Pick slice 
                case 'kidney'
                    mask = Mask_sl1; % Pick mask
                    slice = 1;  % Pick slice 
            end

             % Initialize noise mask with zeros
            mask_noise = zeros(3,176,176);
            mask_noise(slice,10:20,40:80) = 1;  %Set noise mask for subject 1
         
        case 2              %Subject 2
            % Data path
            files_TE = {'/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/6_DTI_PGSE_TE47_Delta20_delta6_2_47172.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/8_DTI_PGSE_TE52_Delta20_delta6_2_48035.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/10_DTI_PGSE_TE57_Delta20_delta6_2_48898.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/12_DTI_PGSE_TE62_Delta20_delta6_2_49761.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/14_DTI_PGSE_TE67_Delta20_delta6_2_50624.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/16_DTI_PGSE_TE72_Delta20_delta6_2_51487.nii.gz'};
                   
            % Load kidney and liver mask
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/Mask_sl1.mat','Mask_sl1')
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_Niere_TE_Test_GAPF02500/20200722_1640/mask_liver.mat','Mask_liver_sl2')

            % Overwrite mask and slice according to organ choice
            switch organ
                case 'liver'
                    slice = 2;  % Pick slice            
                    mask = Mask_liver_sl2; % Pick mask
                case 'kidney'
                    slice = 1;  % Pick slice 
                    mask = Mask_sl1; % Pick mask
            end

            % Initialize noise mask with zeros
            mask_noise = zeros(3,176,176); 
            mask_noise(slice,1:5,90:110) = 1;   %Set noise mask for subject 2
        case 3              %Subject 3
            % Data path           
            files_TE = {'/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/6_DTI_PGSE_TE47_Delta20_delta6_2_49103.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/8_DTI_PGSE_TE52_Delta20_delta6_2_49966.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/10_DTI_PGSE_TE57_Delta20_delta6_2_50829.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/12_DTI_PGSE_TE62_Delta20_delta6_2_51692.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/14_DTI_PGSE_TE67_Delta20_delta6_2_52555.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/16_DTI_PGSE_TE72_Delta20_delta6_2_53418.nii.gz'};
            
            % Load kidney and liver mask
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/Mask_sl2.mat','Mask_sl2')
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE01_GAPF07238/20200819_1655/mask_liver.mat','Mask_liver_sl2');

            % Overwrite mask and slice according to organ choice
            switch organ
                case 'liver'
                    mask = Mask_liver_sl2; % Pick mask
                    slice = 2;% Pick slice
                case 'kidney'
                    mask = Mask_sl2; % Pick mask
                    slice = 2;% Pick slice
            end
    
            % Initialize noise mask with zeros
            mask_noise = zeros(3,176,176);
            mask_noise(slice,1:10,90:120) = 1;  %Set noise mask for subject 3

        case 4      %Subject 4
            % Data path
            files_TE = {'/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/6_DTI_PGSE_TE47_Delta20_delta6_2_71939.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/8_DTI_PGSE_TE52_Delta20_delta6_2_72802.nii.gz'...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/10_DTI_PGSE_TE57_Delta20_delta6_2_73665.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/12_DTI_PGSE_TE62_Delta20_delta6_2_74528.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/14_DTI_PGSE_TE67_Delta20_delta6_2_75391.nii.gz',...
                        '/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/16_DTI_PGSE_TE72_Delta20_delta6_2_76254.nii.gz'};
                        
            % Load kidney and liver mask
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/mask_liver.mat','Mask_liver_sl2') % Liver
            load('/Volumes/Samsung/working/RelaxKidneyIVIM/export_translated_as_nifti/Mrt2-Studie_TE04_GAPF29783/20201126_1524/Mask_sl2.mat','Mask_sl2') % Kidney

            % Overwrite mask and slice according to organ choice
            switch organ
                case 'liver'
                    mask = Mask_liver_sl2; % Pick mask
                    slice = 2;% Pick slice
                case 'kidney'
                    mask = Mask_sl2; % Pick mask
                    slice = 2;% Pick slice
            end
            
            % Initialize noise mask with zeros
            mask_noise = zeros(3,176,176);
            mask_noise(slice,1:10,50:80) = 1;  %Set noise mask for subject 4
    end
    
    
    % Set up data matrix 
    % Data order: slice, x, y, b-values, TE (concatenated)
    temp = double(rot90(niftiread(files_TE{1})));
    dims = size(temp);
    data_nifti = zeros([dims, length(files_TE)]);
    for ii = 1 : length(files_TE)
        data_nifti(:,:,:,:,ii) = double(rot90(niftiread(files_TE{ii}))); 
    end
    dims = size(data_nifti); % Get the dimensions
    
    
    % Generate a figure to look at masks etc
    figure,
    tiledlayout(1,3)
    nexttile
    imagesc(rot90(squeeze(data_nifti(slice,:,:,1,1))))
    nexttile
    imagesc(rot90(squeeze(mask(:,:))))
    nexttile
    imagesc(rot90(squeeze(mask_noise(slice,:,:))))
    
    % Save figure 
    outdir = ['/Users/helge/Documents/MATLAB/IDEALfitting_2D/R1/in_vivo/subject_' num2str(subject) '/' init '/'];
    mkdir(outdir)
    savefig(gcf,[outdir 'Masks_' organ '.fig']);
        
    
    %% In vivo with T2 relaxation with IDEAL
    % This section runs the 2D IVIM model with different optimized TE
    % sets 

    b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750]; % b-values
    TE_values = [47,52,57,62,67,72]; % TE values
    all_data_nifti = data_nifti;     % data matrix
    
    % Optimized TE sets see more in TE_Optimization.m for more info 
    % Orignial Submission
    % TE_values_cell{1} = [47,72];
    % TE_values_cell{2} = [47,57,72];
    % TE_values_cell{3} = [47,52,62,72];
    % TE_values_cell{4} = [47,52,57,67,72];
    % TE_values_cell{5} = [47,52,57,62,67,72];

    % R1 re-optimization
    TE_values_cell{1} = [47,72];
    TE_values_cell{2} = [47,67,72];
    TE_values_cell{3} = [47,52,62,72];
    TE_values_cell{4} = [47,52,62,67,72];
    TE_values_cell{5} = [47,52,57,62,67,72];
    
    % Loop over optiimized TE sets
    for te_sets = start_TE_set : 5

    if ~exist([outdir 'fit_' organ '_te_set_' num2str(te_sets) '.mat']) % Skip if results exist
        
        Params.ModelFunction = 'BiExpFitModelT2RelaxS0';     % Which model
        
        % Pick optimized b-values according to organ except for the all TE
        % and b-value option (5)
        % if te_sets < 5 
        %     switch organ
        %         case 'liver'
        %             Params.b_values = [0, 10, 20, 100, 200, 550]; % Liver
        %         case 'kidney'
        %             Params.b_values = [0, 30, 70, 100, 200, 750]; % Kidney
        %     end           
        % else
            Params.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750]; % All
        % end

        Params.TE_values = TE_values_cell{te_sets}; % Put TE values in struct
        
        
        [~,b_values_ind]=ismember(Params.b_values,b_values);       % Get b-value indices
        [~,te_values_ind]=ismember(Params.TE_values,TE_values);    % Get TE value indices
    
        data_nifti = all_data_nifti;                               % Get all data from storage 
        data_nifti = squeeze(data_nifti(:,:,:,b_values_ind,:));    % Pick b values
        data_nifti = squeeze(data_nifti(:,:,:,:,te_values_ind));   % Pick TE values 
        
        % Set up IDEAL resampling steps
        Params.Dims_steps = [1 1;
                            2 2;
                            4 4;
                            8 8;
                            16 16;
                            32 32;
                            64 64;
                            96 96;
                            128 128;
                            152 152;
                            176 176];

        % Set up IDEAL tolerances 
        Params.Tol = [0.2 0.2 0.2 0.2 0.2 0.5];
        
        % Calculate SD values according to mask
        [NoiseSD]=getNoiseSD(squeeze(data_nifti(:,:,:,1,:)),mask_noise);
        Params.NoiseSD = [];   %No noise sd R1
        % Params.NoiseSD = NoiseSD;   %Put noise in struct
        
        
        for res_step = 1 : size(Params.Dims_steps,1)        % Loop over IDEAL resampling steps
        
             Data_res = zeros(Params.Dims_steps(res_step),Params.Dims_steps(res_step),length(Params.b_values),length(Params.TE_values));
             if res_step == 1
                    % Average in first step
                    Mask_res = ones(1,1);
                    Data_res = zeros(1, 1, numel(Params.b_values),numel(Params.TE_values));
                    for te = 1:numel(Params.TE_values)
                        for b = 1:numel(Params.b_values) 
                             Data_res(:,:,b,te) = nanmean(squeeze(data_nifti(slice,:,:,b,te)),'all');               
                        end
                    end
             else
                 for te = 1 : length(Params.TE_values)
                    [Mask_res, Data_res(:,:,:,te)] = resample_data(squeeze(mask(:,:)),squeeze(data_nifti(slice,:,:,:,te)),[Params.Dims_steps(res_step) Params.Dims_steps(res_step)],Params.b_values);
                end
             end
        
            
            switch init
                case 'set_1'
                    %                 ffast Dslow   Dfast T2slow T2fast S0
                    Params.lb =      [ 0.01  0.001  0.01 10 50 10];  % Biexp
                    Params.x0 =      [ 0.1  0.0015   0.015  60 60 200];
                    Params.ub =      [ 0.7 0.01    0.5  90 320 1000];
                case 'set_2'
                    %                  ffast Dslow   Dfast T2slow T2fast S0
                    Params.lb =      [ 0.01  0.0007  0.01 10 25 10];  % Biexp
                    Params.x0 =      [ 0.1  0.001   0.05  30 45 200];
                    Params.ub =      [ 0.7 0.01    0.9  45 320 1000];
            end
            
            
            % Initialize with zeros
            f_fast = zeros(Params.Dims_steps(res_step,:));
            D_slow = zeros(Params.Dims_steps(res_step,:));
            D_fast = zeros(Params.Dims_steps(res_step,:));
            T2_slow = zeros(Params.Dims_steps(res_step,:));
            T2_fast = zeros(Params.Dims_steps(res_step,:));
            S_0 = zeros(Params.Dims_steps(res_step,:));
           
            f_fast_crlb= zeros(Params.Dims_steps(res_step,:));
            D_slow_crlb= zeros(Params.Dims_steps(res_step,:));
            D_fast_crlb= zeros(Params.Dims_steps(res_step,:));
            T2_slow_crlb= zeros(Params.Dims_steps(res_step,:));
            T2_fast_crlb= zeros(Params.Dims_steps(res_step,:));
            S_0_crlb= zeros(Params.Dims_steps(res_step,:));
                   
            % Initialize waitbar
            f = waitbar(0, ['Starting IDEAL step' num2str(res_step)]);
            i = 1;
            n = size(Data_res,1) * size(Data_res,2);
        
            % Image loop
            for id_x = 1 : size(Data_res,1)
                for id_y = 1 : size(Data_res,2)
                    if Mask_res(id_x,id_y)
                        if res_step ~= 1
                            op=[];
                            op = update_fitting(op, fit_res, Params, id_x, id_y);
                            Params.lb=op.Lower;
                            Params.x0=op.StartPoint;
                            Params.ub=op.Upper;
                        end
        
                        [xk,crlb] = createModelIVIM(squeeze(Data_res(id_x,id_y,:,:)),Params);
                        
                        f_fast(id_x, id_y) = xk(1);
                        D_slow(id_x, id_y) = xk(2);
                        D_fast(id_x, id_y) = xk(3);
                        T2_slow(id_x, id_y) = xk(4);
                        T2_fast(id_x, id_y) = xk(5);
                        S_0(id_x, id_y) = xk(6);
        
                        f_fast_crlb(id_x, id_y) = crlb(1);
                        D_slow_crlb(id_x, id_y) = crlb(2);
                        D_fast_crlb(id_x, id_y) = crlb(3);
                        T2_slow_crlb(id_x, id_y) = crlb(4);
                        T2_fast_crlb(id_x, id_y) = crlb(5);
                        S_0_crlb(id_x, id_y) = crlb(6);      
                    end
                    waitbar(i/n, f, sprintf('Progress IDEAL step %i: %d %%', res_step,floor(i/n*100))); 
                    i = i + 1;
                end
            end % end image loop
            close(f) % close waitbar

            % Store results
            fit.f_fast = f_fast;
            fit.D_slow = D_slow;
            fit.D_fast = D_fast;
            fit.T2_slow = T2_slow;
            fit.T2_fast = T2_fast;
            fit.S_0 = S_0;

            % Plot if you want to
            % plot_fit(fit);

            % Interpolate data
            if res_step < size(Params.Dims_steps,1)
                fit_res = interpolate_fit(fit,Params.Dims_steps,res_step,Params.ModelFunction);
            end

            % Store CRLBs
            fit.f_fast_crlb = f_fast_crlb;
            fit.D_slow_crlb = D_slow_crlb;
            fit.D_fast_crlb = D_fast_crlb;
            fit.T2_slow_crlb = T2_slow_crlb;
            fit.T2_fast_crlb = T2_fast_crlb;
            fit.S_0_crlb = S_0_crlb;
        
        end
        % Save output
        save([outdir 'fit_' organ '_te_set_' num2str(te_sets) '.mat'],'fit');
    end
    end
end


%% In vivo IDEAL each TE separately
% This was done manually but could be added in loop
Params.ModelFunction = 'BiExpFitModelS0'; % Which model
Params.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
Params.TE_values = [47,52,57,62,67,72];
Params.TE_id = 3; % which TE
% Set up IDEAL resampling steps
Params.Dims_steps = [1 1;
                    2 2;
                    4 4;
                    8 8;
                   16 16;
                    32 32;
                    64 64;
                    96 96;
                    128 128;
                    152 152;
                    176 176];

% Set up IDEAL tolerances
Params.Tol = [0.2 0.2 0.5];
[NoiseSD]=getNoiseSD(squeeze(data_nifti(:,:,:,1,Params.TE_id)),mask_noise);
Params.NoiseSD = NoiseSD;


for res_step = 1 : size(Params.Dims_steps,1)

     Data_res = zeros(Params.Dims_steps(res_step),Params.Dims_steps(res_step),length(Params.b_values),length(Params.TE_id));
     if res_step == 1
            % Average in first step
            Mask_res = ones(1,1);
            Data_res = zeros(1, 1, numel(Params.b_values),numel(Params.TE_id));
            for te = Params.TE_id
                for b = 1:numel(Params.b_values) 
                     Data_res(:,:,b) = nanmean(squeeze(data_nifti(slice,:,:,b,te)),'all');               
                end
            end
     else
         for te = Params.TE_id         
             [Mask_res, Data_res(:,:,:,1)] = resample_data(squeeze(mask(:,:)),squeeze(data_nifti(slice,:,:,:,te)),[Params.Dims_steps(res_step) Params.Dims_steps(res_step)],Params.b_values);
        end
     end

    
    
    %         ffast Dslow   Dfast S0
    Params.lb =      [ 0.01  0.001  0.01     10];  % Biexp
    Params.x0 =      [ 0.1   0.0015 0.015   200];
    Params.ub =      [ 0.7   0.01    0.5   1000];
    
    f_fast = zeros(Params.Dims_steps(res_step,:));
    D_slow = zeros(Params.Dims_steps(res_step,:));
    D_fast = zeros(Params.Dims_steps(res_step,:));
    S_0 = zeros(Params.Dims_steps(res_step,:));
    
    f = waitbar(0, ['Starting IDEAL step' num2str(res_step)]);
    i = 1;
    n = size(Data_res,1) * size(Data_res,2);

    for id_x = 1 : size(Data_res,1)
        for id_y = 1 : size(Data_res,2)
            if Mask_res(id_x,id_y)
                if res_step ~= 1
                    op=[];
                    op = update_fitting(op, fit_res, Params, id_x, id_y);
                    Params.lb=op.Lower;
                    Params.x0=op.StartPoint;
                    Params.ub=op.Upper;
                end

                [xk,crlb] = createModelIVIM(squeeze(Data_res(id_x,id_y,:)), Params);
                
                f_fast(id_x, id_y) = xk(1);
                D_slow(id_x, id_y) = xk(2);
                D_fast(id_x, id_y) = xk(3);
                S_0(id_x, id_y) = xk(4);

                f_fast_crlb(id_x, id_y) = crlb(1);
                D_slow_crlb(id_x, id_y) = crlb(2);
                D_fast_crlb(id_x, id_y) = crlb(3);
                S_0_crlb(id_x, id_y) = crlb(4);
            end
            waitbar(i/n, f, sprintf('Progress IDEAL step %i: %d %%', res_step,floor(i/n*100)));
            i = i + 1;
        end
    end
    close(f)
    fit.f_fast = f_fast;
    fit.D_slow = D_slow;
    fit.D_fast = D_fast;
    fit.S_0 = S_0;
    if res_step < size(Params.Dims_steps,1)
        fit_res = interpolate_fit(fit,Params.Dims_steps,res_step,Params.ModelFunction);
    end
    fit.f_fast_crlb = f_fast_crlb;
    fit.D_slow_crlb = D_slow_crlb;
    fit.D_fast_crlb = D_fast_crlb;
    fit.S_0_crlb = S_0_crlb;
end


%% In vivo with T2 relaxation and segmented fit
% This was done manually but could be added in loop
Params.ModelFunction = 'BiExpFitModelT2RelaxS0'; % Which model
Params.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
Params.TE_values = [47,52,57,62,67,72];
Params.Dims_steps = [176 176];
Params.Tol = [0.2 0.2 0.2 0.2 0.2 0.5];
ParamsStep1 = Params;
ParamsStep1.ModelFunction = 'BiExpFitModelT2RelaxSegmented';
ParamsStep1.b_values =  ParamsStep1.b_values(9:end);  
for res_step = 1 : size(Params.Dims_steps,1)

   Mask_res = squeeze(mask(:,:));
   Data_res = squeeze(data_nifti(slice,:,:,:,:));

    
    
        S_0 = zeros(Params.Dims_steps(res_step,:));    
        f_fast = zeros(Params.Dims_steps(res_step,:));
        D_slow = zeros(Params.Dims_steps(res_step,:));
        D_fast = zeros(Params.Dims_steps(res_step,:));
        T2_slow = zeros(Params.Dims_steps(res_step,:));
        T2_fast = zeros(Params.Dims_steps(res_step,:));
    
    f = waitbar(0, ['Starting IDEAL step' num2str(res_step)]);
    i = 1;
    n = size(Data_res,1) * size(Data_res,2);

    for id_x = 1 : size(Data_res,1)
        for id_y = 1 : size(Data_res,2)
            if Mask_res(id_x,id_y)
                
              SD_est = squeeze(Data_res(id_x,id_y,9,:));
              D_est = (log(max(squeeze(Data_res(id_x,id_y,9:end,:))) - log(min(squeeze(Data_res(id_x,id_y,9:end,:))))))/(ParamsStep1.b_values(end)-ParamsStep1.b_values(1));

                 %              S0 Dslow  T2slow  
                ParamsStep1.lb =      [ 10     0.001 10];  % Biexp
                ParamsStep1.x0 =      [ mean(SD_est) mean(D_est) 60];
                ParamsStep1.ub =      [ 1000   0.01 90];

                [xk_seg1,xk_seg1_crlb] = createModelIVIM(squeeze(Data_res(id_x,id_y,9:end,:)), ParamsStep1);
                
                S_0(id_x, id_y) = xk_seg1(1);
                D_slow(id_x, id_y) = xk_seg1(2);
                T2_slow(id_x, id_y) = xk_seg1(3);  
                
                b0_mean(id_x,id_y) = mean(squeeze(Data_res(id_x,id_y,1,:)));
                fmap(id_x,id_y) = (b0_mean(id_x,id_y) - S_0(id_x,id_y))./b0_mean(id_x,id_y);


                %               ffast Dslow   Dfast T2slow T2fast S0
                Params.lb =      [ 0.01  0.001  0.01 10 50 10];  % Biexp
                Params.x0 =      [ 0.1  0.0015   0.015  60 60 200];
                Params.ub =      [ 0.7 0.01    0.5  90 320 2000];
                
                
                SDs_est(id_x, id_y) = fmap(id_x,id_y)*b0_mean(id_x, id_y);
                Ds_est(id_x, id_y) = 10*D_slow(id_x, id_y);

               % lb_seg2(2) =      Ds_est(id_x, id_y)*0.5;
                Params.x0(2) =      Ds_est(id_x, id_y);
               % ub_seg2(2) =      Ds_est(id_x, id_y)*1.5;

                %lb_seg2(4) =      T2_slow(id_x, id_y)*0.5;
                Params.x0(4) =      T2_slow(id_x, id_y);
               % ub_seg2(4) =      T2_slow(id_x, id_y)*1.5;

               % lb_seg2(6) =      SDs_est(id_x, id_y)*0.5;
                Params.x0(6) =      SDs_est(id_x, id_y);
               % ub_seg2(6) =      SDs_est(id_x, id_y)*1.5;

                [xk_seg2,xk_seg2_crlb] = createModelIVIM(squeeze(Data_res(id_x,id_y,:,:)), Params);
                f_fast(id_x, id_y) = xk_seg2(1);
                D_slow(id_x, id_y) = xk_seg2(2);
                D_fast(id_x, id_y) = xk_seg2(3);
                T2_slow(id_x, id_y) = xk_seg2(4); 
                T2_fast(id_x, id_y) = xk_seg2(5);
                S_0(id_x, id_y) = xk_seg2(6);

                f_fast_crlb(id_x, id_y) = xk_seg2_crlb(1);
                D_slow_crlb(id_x, id_y) = xk_seg2_crlb(2);
                D_fast_crlb(id_x, id_y) = xk_seg2_crlb(3);
                T2_slow_crlb(id_x, id_y) = xk_seg2_crlb(4); 
                T2_fast_crlb(id_x, id_y) = xk_seg2_crlb(5);
                S_0_crlb(id_x, id_y) = xk_seg2_crlb(6);

            end
            waitbar(i/n, f, sprintf('Progress IDEAL step %i: %d %%', res_step,floor(i/n*100)));
            i = i + 1;
        end
    end
    close(f)
    fit.f_fast = f_fast;
    fit.D_slow = D_slow;
    fit.D_fast = D_fast;
    fit.T2_slow = T2_slow;
    fit.T2_fast = T2_fast;
    fit.S_0 = S_0;

    fit.f_fast_crlb = f_fast_crlb;
    fit.D_slow_crlb = D_slow_crlb;
    fit.D_fast_crlb = D_fast_crlb;
    fit.T2_slow_crlb = T2_slow_crlb;
    fit.T2_fast_crlb = T2_fast_crlb;
    fit.S_0_crlb = S_0_crlb;
end
