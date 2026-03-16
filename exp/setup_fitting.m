function [fit, FitResults, gof, output, op] = setup_fitting(Params,res_step,sz)
%setup_fitting(Params 'struct', res_step 'double', sz 'double')
% setup variables for fitted parameters
%
%   Params  : Parameter struct
%   res_step: idx for current step
%   sz      : is the final matrix size

    fit = struct();
    
    % Basic ADC Parameters
    fit.S_0 = zeros(Params.Dims_steps(res_step,1), ...
                    Params.Dims_steps(res_step,2));
    fit.D_slow = zeros(Params.Dims_steps(res_step,1), ...
                     Params.Dims_steps(res_step,2));

    if strcmp(Params.Model,"S0fit")
                fit.T1 = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T1
                fit.T2 = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T2
    end
    % Parameters for Bi and Tri
    if strcmp(Params.Model,"biexp") || strcmp(Params.Model,"biexp_T1corr") ||strcmp(Params.Model,"triexp") || ...
            strcmp(Params.Model,"Biexp") || strcmp(Params.Model,"Biexp_T1corr") || ...
        strcmp(Params.Model,"biexp_T1andT2corr") || strcmp(Params.Model,"Biexp_T1andT2corr") || strcmp(Params.Model,"Triexp") || ...
                    strcmp(Params.Model,"biexp_biT1andT2corr")|| strcmp(Params.Model,"Biexp_biT1andT2corr") || ...
                                strcmp(Params.Model,"biexp_T1corrFixed") || strcmp(Params.Model,"Biexp_T1corrFixed") ||  strcmp(Params.Model,"BiExpFitModelT2Relax")
                        fit.f_fast = zeros(Params.Dims_steps(res_step,1), ...
                                    Params.Dims_steps(res_step,2)); % f_fast
                        fit.D_fast = zeros(Params.Dims_steps(res_step,1), ...
                                    Params.Dims_steps(res_step,2)); % D_fast
    end
     % Parameters for Bi with T1 correction
    if strcmp(Params.Model,"biexp_T1corr") || strcmp(Params.Model,"Biexp_T1corr") || ...
        strcmp(Params.Model,"biexp_T1andT2corr") || strcmp(Params.Model,"Biexp_T1andT2corr")
        fit.T1 = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T1
    end
    
   if strcmp(Params.Model,"biexp_T1andT2corr") || strcmp(Params.Model,"Biexp_T1andT2corr")
        fit.T2 = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T1
    end
    
    if strcmp(Params.Model,"biexp_biT1andT2corr")|| strcmp(Params.Model,"Biexp_biT1andT2corr")
        fit.T1t = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T1t
        fit.T2t = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T2t 
        fit.T1f = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T1f
        fit.T2f = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T2f 
    end
    % Parameters for Tri
    if strcmp(Params.Model,"triexp") || strcmp(Params.Model,"Triexp")
        fit.f_inter = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % f_inter
        fit.D_inter = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % D_inter   
    end  

        if strcmp(Params.Model,"BiExpFitModelT2Relax")
        fit.T2_slow = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T2_slow
        fit.T2_fast = zeros(Params.Dims_steps(res_step,1), ...
                            Params.Dims_steps(res_step,2)); % T2_fast
    end
    
    
    
    FitResults = cell(sz(1), sz(2));
    gof = FitResults;
    output = FitResults;
    
    op = Params.op;
end