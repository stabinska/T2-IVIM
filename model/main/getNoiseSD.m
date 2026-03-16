function [NoiseSD]=getNoiseSD(data,mask_noise);
% [NoiseSD]=getNoiseSD(data,mask_noise);
% Calcualte the standard deviation of the noise using the noise covariance
% matrix
%
% USAGE:
% [NoiseSD]=getNoiseSD(data,mask_noise);
%
%   INPUTS:
%       in             = image matrix (multi TEs)
%       mask_noise     = noise mask
%
%   OUTPUTS:
%       NoiseSD           = Estimated standard deviation of noise.
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Calculate noise estimates
noise = zeros(sum(mask_noise,'all'),size(data,4));                          % Setup noise matrix
for secDim = 1 : size(data,4)                                               % Loop over second dim (TEs) start
    tempData = squeeze(data(:,:,:,secDim));
    noise(:,secDim) = tempData(mask_noise==1);                           % Get noise vectors
end                                                                         % End loop over TEs

noisecovariance = cov(real(noise));                                         % Calculate covariance matrix
NoiseSD = sqrt(diag(noisecovariance))';                                      % Calculate standard deviation

end



