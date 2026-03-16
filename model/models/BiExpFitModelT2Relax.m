%%  BiExpFitModelT2Relax.m
%   This function contains a T2 corrected biexponential diffusion model
%   modelled as a 2D problem.
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
function fh = BiExpFitModelT2Relax
    fh.lossFunction     = @lossFunction;
    fh.forwardGradient  = @forwardGradient;
    fh.forwardJacobian  = @forwardJacobian;
    fh.forwardModel     = @forwardModel;
    fh.x2pars           = @x2pars;
    fh.pars2x           = @pars2x;
    fh.fminunc_wrapper  = @fminunc_wrapper;
end

%% Define lossfunction, forward gradient, forward jacobian, forward model, x2pars, pars2x, fminunc_wrapper

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
    % Run forward model to get prediction
    b_values = parameter.b_values;
    TE_values = parameter.TE_values;

    [prediction]  = forwardModel(x,b_values,TE_values);             % parameter struct
    data = data';

    residual     = data - prediction;            % Calculate residual 

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
%% Calculate forward jacobian matrix
    b_values = parameter.b_values;                                          % Get b values
    TE_values = parameter.TE_values;                                        % Get TE values
    secDim = length(TE_values);                                             % Secondary dimension length

    parStruct = x2pars(x,parameter);                                        % Convert x to readable parameters
    f_fast = parStruct.f_fast;                                              % Get f fast parameter
    D_slow = parStruct.D_slow;                                              % Get D slow parameter
    D_fast = parStruct.D_fast;                                              % Get D fast parameter
    T2_slow = parStruct.T2_slow;                                            % Get T2 slow parameter
    T2_fast = parStruct.T2_fast;                                            % Get T2 fast parameter

    % Partial derivatives to allow loop across
    dYdffast          = [];                                                   % Initialize partial derivative wrt ffast
    dYdDslow          = [];                                                   % Initialize partial derivative wrt Dslow
    dYdDfast          = [];                                                   % Initialize partial derivative wrt Dfast
    dYdT2slow         = [];                                                   % Initialize partial derivative wrt T2slow
    dYdT2fast         = [];                                                   % Initialize partial derivative wrt T2fast

    

    
    
    % Construct the Jacobian matrix of partial derivatives. This is done in
    % a block-wise fashion for 2-D data.
    for SD = 1 : secDim                                                     % Loop over indirect dimension

        % Partial derivative with respect to ffast
        dYdffast(:,SD) = S_0 * (-exp(-f_fast * b_values) * exp(-(1 / T2_slow) * TE_values(SD)) + ...
                       exp(-D_slow * b_values) * exp(-(1 / T2_fast) * TE_values(SD)));
        
        % Partial derivative with respect to Dslow
        dYdDslow(:,SD) = S_0 * (-(1 - f_fast) * b_values .* exp(-f_fast * b_values) * exp(-(1 / T2_slow) * TE_values(SD)));
        
        % Partial derivative with respect to Dfast
        dYdDfast(:,SD) = S_0 * (-f_fast * b_values .* exp(-D_slow * b_values) * exp(-(1 / T2_fast) * TE_values(SD)));
        
        % Partial derivative with respect to T2slow
        dYdT2slow(:,SD) = S_0 * ((1 - f_fast) * exp(-f_fast * b_values) .* (TE_values(SD) / T2_slow^2) .* ...
                       exp(-(1 / T2_slow) * TE_values(SD)));
        
        % Partial derivative with respect to T2fast
        dYdT2fast(:,SD) = S_0 * (f_fast * exp(-D_slow * b_values) .* (TE_values(SD) / T2_fast^2) .* ...
                       exp(-(1 / T2_fast) * TE_values(SD)));


    end                                                                     % End loop over indirect dimension


     if isfield(parameter, 'NoiseSD') && ~isempty(parameter.NoiseSD)
        NoiseSD = parameter.NoiseSD;
        if size(NoiseSD,1) ~= secDim % Not the right dimensions
            NoiseSD = NoiseSD';
        end
        NoiseSD = repmat(NoiseSD,[1 length(parameter.b_values)]);
        NoiseSD = NoiseSD';
    else
        NoiseSD = 1;
     end

    dYdffast = reshape((dYdffast./NoiseSD)',[],1);
    dYdDslow = reshape((dYdDslow./NoiseSD)',[],1);
    dYdDfast = reshape((dYdDfast./NoiseSD)',[],1);
    dYdT2slow = reshape((dYdT2slow./NoiseSD)',[],1);
    dYdT2fast = reshape((dYdT2fast./NoiseSD)',[],1);

    jac = cat(2, dYdffast, dYdDslow, dYdDfast, dYdT2slow, dYdT2fast);   % Create final jacobian

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
    TE_values = parameter.TE_values;                                        % Get TE values
    secDim = length(TE_values);                                             % Secondary dimension length

    parStruct = x2pars(x,parameter);                                        % Convert x to readable parameters
    f_fast = parStruct.f_fast;                                              % Get f fast parameter
    D_slow = parStruct.D_slow;                                              % Get D slow parameter
    D_fast = parStruct.D_fast;                                              % Get D fast parameter
    T2_slow = parStruct.T2_slow;                                            % Get T2 slow parameter
    T2_fast = parStruct.T2_fast;                                            % Get T2 fast parameter

    % Initialize output
    Y               = [];                                                   % Initialize model 
    for SD = 1 : secDim
        S0 = (1-f_fast)*exp(-(1/T2_slow).*TE_values(SD)) + f_fast*exp(-(1/T2_fast).*TE_values(SD));
        M = (1-f_fast)*exp(-D_slow.*b_values)*exp(-(1/T2_slow).*TE_values(SD)) + f_fast*exp(-D_fast.*b_values)*exp(-(1/T2_fast).*TE_values(SD));
        M = M./S0;
        Y = cat(1,Y,M);
    end

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

