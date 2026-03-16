%%  TriExpFitModelS0.m
%   This function contains a triexponential diffusion model
%
%   lossFunction    - calculates loss function for optimizer
%   forwardJacobian - calculates the forward jacobian for optimizer
%   forwardModel    - converts parameter struct into model prediction
%   x2pars          - converts x vector to parameter struct
%   pars2x          - converts parameter struct to x vector
%   fminunc_wrapper - wrapper for MATLAB's fminunc
%
%
%
%   USAGE:
%       Specify this in the module.ModelFunction
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Handle set up for optimizer
function fh = TriExpFitModelS0
    fh.lossFunction     = @lossFunction;
    fh.forwardGradient  = @forwardGradient;
    fh.forwardJacobian  = @forwardJacobian;
    fh.forwardModel     = @forwardModel;
    fh.x2pars           = @x2pars;
    fh.pars2x           = @pars2x;
    fh.fminunc_wrapper  = @fminunc_wrapper;
end

%% Define lossfunction, forward gradient, forward jacobian, forward model, f_fastpars, pars2x, fminunc_wrapper

function sse = lossFunction(x, data, parameter)
% This function generates the output for the solver according to the
% loss function. 
%
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Calculate lossfunction
    % Run forward model to get prediction and regularizer output
    b_values = parameter.b_values;

    [prediction]  = forwardModel(x,parameter);             % parameter struct

    residual     = data' - prediction;            % Calculate residual   

    if isfield(parameter, 'NoiseSD') && ~isempty(parameter.NoiseSD)
        NoiseSD = parameter.NoiseSD;
        if size(NoiseSD,1) ~= parameter.TE_values % Not the right dimensions
            NoiseSD = NoiseSD';
        end
        NoiseSD = repmat(NoiseSD,[1 length(parameter.b_values)]);
        residual = residual ./ NoiseSD;
    end

    residual = reshape(residual,[],1);            % Reshape the multidimenisonal case
    sse = residual;                              % Return residual
    % figure(99), plot(residual)
end



function jac = forwardJacobian(x,parameter)
% This function generates the jacobian
%
%   USAGE:
%       jac = forwardJacobian(x, parameter)
%
%   INPUTS:
%       x                = x vector with parameters to optimize
%       parameter        = parameter struct
%
%   OUTPUTS:
%       jac              = return for jacobian matrix
%
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Calculate forward jacobian matrix
    b_values = parameter.b_values;                                          % Get b values

    parStruct = x2pars(x,parameter);                                        % Convert x to readable parameters
    f_inter = parStruct.f_inter;                                            % Get f inter parameter
    f_fast = parStruct.f_fast;                                              % Get f inter parameter
    D_slow = parStruct.D_slow;                                              % Get D slow parameter
    D_inter = parStruct.D_inter;                                              % Get D slow parameter
    D_fast = parStruct.D_fast;                                              % Get D fast parameter
    S_0 = parStruct.S_0;                                                    % Get S0 parameter



    % Partial derivatives to allow loop across
    dYdfinter          = [];                                                  % Initialize partial derivative wrt finter
    dYdffast          = [];                                                  % Initialize partial derivative wrt ffast
    dYdDslow          = [];                                                   % Initialize partial derivative wrt Dslow
    dYdDinter          = [];                                                   % Initialize partial derivative wrt Dslow
    dYdDfast          = [];                                                   % Initialize partial derivative wrt Dfast
    dYdS0         = [];                                                       % Initialize partial derivative wrt S0

    % Construct the Jacobian matrix of partial derivatives.

    % Partial derivative with respect to finter
    dYdfinter(:,1) = S_0 * (-exp(-D_slow * b_values) + ...
                             exp(-D_inter * b_values));

    % Partial derivative with respect to ffast
    dYdffast(:,1) = S_0 * (-exp(-D_slow * b_values) + ...
                             exp(-D_fast * b_values));
    
    % Partial derivative with respect to Dslow
    dYdDslow(:,1) = S_0 * (-(1 - f_inter - f_fast) * b_values .* exp(-D_slow * b_values));
    
    % Partial derivative with respect to Dinter
    dYdDinter(:,1) = S_0 * (-f_inter * b_values .* exp(-D_inter * b_values));

    % Partial derivative with respect to Dfast
    dYdDfast(:,1) = S_0 * (-f_fast * b_values .* exp(-D_fast * b_values));
    
    % Partial derivative with respect to S0
    dYdS0(:,1) = (1 - f_inter - f_fast) * exp(-D_slow * b_values) + ...
                              f_inter * exp(-D_inter * b_values) + ...
                              f_fast * exp(-D_fast * b_values);


    
    if isfield(parameter, 'NoiseSD') && ~isempty(parameter.NoiseSD)
        NoiseSD = parameter.NoiseSD;
        if size(NoiseSD,1) ~= 1 % Not the right dimensions
            NoiseSD = NoiseSD';
        end
        NoiseSD = repmat(NoiseSD,[1 length(parameter.b_values)]);
        NoiseSD = NoiseSD';
    else
        NoiseSD = 1;
    end

    dYdfinter = reshape((dYdffast./NoiseSD)',[],1);
    dYdffast = reshape((dYdffast./NoiseSD)',[],1);
    dYdDslow = reshape((dYdDslow./NoiseSD)',[],1);
    dYdDinter = reshape((dYdDslow./NoiseSD)',[],1);
    dYdDfast = reshape((dYdDfast./NoiseSD)',[],1);
    dYdS0     = reshape((dYdS0./NoiseSD)',[],1);

    jac = cat(2, dYdfinter, dYdffast, dYdDslow, dYdDinter, dYdDfast, dYdS0);   % Create final jacobian

    jac = (-1) * jac;                                                       % Needed to match numerical jacobian



end


function [Y] = forwardModel(x,parameter)
% This function generates forward model
%
%   USAGE:
%       Y = forwardModel(x, parameter)
%
%   INPUTS:
%       x                = x vector with parameters to optimize
%       parameter        = parameter struct
%
%   OUTPUTS:
%       Y                = return for model functiom
%
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Calculate forward model

    b_values = parameter.b_values;                                          % Get b values

    parStruct = x2pars(x,parameter);                                        % Convert x to readable parameters
    f_inter = parStruct.f_inter;                                            % Get f inter parameter
    f_fast = parStruct.f_fast;                                              % Get f inter parameter
    D_slow = parStruct.D_slow;                                              % Get D slow parameter
    D_inter = parStruct.D_inter;                                              % Get D slow parameter
    D_fast = parStruct.D_fast;                                              % Get D fast parameter
    S_0 = parStruct.S_0;                                                    % Get S0 parameter

    % Generate output
    Y = S_0*((1-f_inter-f_fast)*exp(-D_slow.*b_values) + f_inter*exp(-D_inter.*b_values) + f_fast*exp(-D_fast.*b_values));

end

function paramStruct = x2pars(x, parametrizations)      
    pars = fields(parametrizations);        
    % Converts a 1-D x vector into a parameter struct
    for ff = 1 : length(pars)
        % Start with a parameter struct according to the 
        paramStruct.(pars{ff}) = x(parametrizations.(pars{ff}).index);  
    end
end

function [x,indexStruct] = pars2x(paramStruct)
    % Converts a parameter struct into a 1-D x vector that can be
    % passed on to solvers. It also defines start and end indices for
    % easier identification
    pars = fields(paramStruct);
    x = [];
    for ff = 1 : length(pars)         
        x = cat(2,x,reshape(paramStruct.(pars{ff}),1,[]));
    end 
end

function [f,g,h] = fminunc_wrapper(x,F,GJ,H)
% This function sets up the fminunc_wrapper for MATLAB
%%
    % [f,g,h] = fminunc_wrapper( x, F, GJ, H )
    % for use with Matlab's "fminunc"
    f = F(x);
    if nargin > 2 && nargout > 1
        g = GJ(x);
    end
    if nargin > 3 && nargout > 2
        h = H(x);
    end
end

