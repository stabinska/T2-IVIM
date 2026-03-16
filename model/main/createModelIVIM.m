function [xk,crlbs] = createModelIVIM(data,parameter)
%%  [xk,crlbs] = createModelIVIM(data,ModelFunction,parameter)
%   This is the heart and soul of the optimization. This function takes
%   the data, model function, and parametrization and translates them into
%   appropriate loss and gradient functions
%
%   USAGE:
%       createModelIVIM(data,parameter)
%
%   OUTPUTS:
%       xk     = x outputs.
%       crlbs  = Cramer-Rao-Lower-Bounds for x outputs
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
    %% Setup inputs for optimizers 


    eval(['h = ' parameter.ModelFunction ';'])  % Set model function handle from ModelFunction field (e.g. BiExpFitModelT2RelaxS0)
    
    switch parameter.ModelFunction
        case 'BiExpFitModelT2RelaxS0'
            parameter.parametrization.f_fast.index = 1;
            parameter.parametrization.D_slow.index = 2;
            parameter.parametrization.D_fast.index = 3;
            parameter.parametrization.T2_slow.index = 4;
            parameter.parametrization.T2_fast.index = 5;
            parameter.parametrization.S_0.index = 6;


    end
    
    % Set lossfunction handle
    fcn  = @(x) h.lossFunction(x, ...        % x vector with parameters to optimize
                               data,...      % data 1D or 2D format   
                               parameter);   % parameter struct

    
    
    SpecifyObjectiveGradient = false;         % numeric jacobian is passed
    CheckGrad = false;                       % check gradient with matlab function
    
    % Set jacobian handle
    jac = @(x) h.forwardJacobian(x, ...      % x vector with parameters to optimize
                                 parameter); % parameter struct
    
    % Set fminunc wrappper handle
    fun  = @(x) h.fminunc_wrapper(x, fcn, jac); 
    
     % Set solver options
    opts = optimoptions('lsqnonlin', ...
                        'Algorithm','levenberg-marquardt', ...      % Use LM
                        'SpecifyObjectiveGradient',SpecifyObjectiveGradient,... % Use analytic jacobian
                        'CheckGradients',CheckGrad, ...             % Check gradient
                        'MaxIterations',500, ...                   % Iterations
                        'FunctionTolerance',1e-10,...               % Function Tolerance for lsqnonlin
                        'OptimalityTolerance',1e-10,...             % Optimiality Tolerance for lsqnonlin
                        'StepTolerance',1e-10,...                   % Step Tolerance for lsqnonlin
                        'Display','none');                       % Display no iterations

    
    
    tstart = tic;                                               % Start timer           
    [xk,info.resnorm,info.residual,info.exitflag,info.output,info.lambda,info.jacobian] = lsqnonlin(fun, parameter.x0, parameter.lb, parameter.ub, opts ); % Run solver
    time = toc(tstart);    
    
    %% Calculate CRLB

    jac = h.forwardJacobian(xk, ...             % x vector with final parameters
                            parameter); % parameter struct

    fisher = real(jac'*jac);                            % calculate the fisher matrix
    
    invFisher = pinv(fisher);                           % invert fisher matrix
    crlbs = sqrt(diag(invFisher));                      % get raw CRLBs values

end
