function h = plot_maps(fit)
% h = plot_maps(fit)
% Plot parameter maps from model
%
% USAGE:
% h = plot_maps(fit)
%
%   INPUTS:
%       fit            = fit results from IVIM model
%
%   OUTPUTS:
%       h           = figure handle
%
%   AUTHOR:
%       Dr. Helge Zoellner (Johns Hopkins University, 2025-06-12)
%       hzoelln2@jhmi.edu
%       Dr. Julia Stabinska
%       jstabin3@jhmi.edu
%
%% Create figure  with maps
pars = fields(paramStruct);
cols = 3;
rows = ceil(length(pars)/cols);

% Figures with subplots are created according to model
figure,
tiledlayout(rows,cols)

for i = 1 : length(pars)
    nexttile
    imagesc(rot90(squeeze(fit.(pars{i})(:,:))))
    title(pars{i})
    colorbar            
    h = get(gcf);
end
     
end