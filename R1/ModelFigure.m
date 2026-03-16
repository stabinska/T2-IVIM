%%
Phantom.fslow = .64;

Phantom.finter = .29;

Phantom.ffast = .10;

Phantom.Dslow = .0015;

Phantom.Dinter = .0052;

Phantom.Dfast = .08;

Phantom.S0 = 184;

ffast = Phantom.ffast;

% T1_tissue = 900:20:1700; % 900 to 1700
% T1_blood = 1500:20:2100; % 1500 to 2100 
% T2_tissue = 70:10:90; % 50 to 90
% T2_blood = 220:10:320; % 220 to 320

T1_tissue = 1200; % 900 to 1700
T1_blood = T1_tissue;
T2_tissue = 60; % 50 to 90
T2_blood = T2_tissue;


% b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750]; % b-values
TE = [47,52,57,62,67,72]; % TE values


TR = 3000; % 2000 3000 4000

b_values = 0:10:800;
b_value_index = [1,2,3,4,6,8,11,16,21,26,31,36,41,46,56,66,76];
% TE = 60:2:80; % 60 70 80


% N_noise = [0 0.01 0.025 0.05 0.075];
% N_noise = [0 0.005 0.0075 0.01 0.0125 0.015];
N_noise = [0];
N_rep = 1;
%
% corr=1/((1-ffast)*exp(1-TR/Phantom.T1_tissue)*exp(-TE/Phantom.T2_tissue) + (ffast*exp(1-TR/Phantom.T1_blood)*exp(-TE/Phantom.T2_blood)));

% Matrix dimension definitons:
% 0 - representations
% 1 - noise
% 2 - pixel singelton
% 3 - b values
% 4 - TE
% 5 - TR
% 6 - T1 tissue
% 7 - T1 blood
% 8 - T2 tissue
% 9 - T2 blood

DataMatrix = zeros(N_rep,length(N_noise),1,length(b_values),...
                length(TE),length(TR),...
                length(T1_tissue),length(T1_blood),...
                length(T2_tissue),length(T2_blood));

f = waitbar(0, 'Starting');
i = 1;
n = N_rep * length(TE) * length(TR)* length(T1_tissue) * length(T1_blood) * length(T2_tissue) *length(T2_blood);
for id_rep = 1 : N_rep
    for id_te = 1: length(TE)
        for id_tr = 1: length(TR)
            for id_t1t = 1: length(T1_tissue)
                for id_t1b = 1: length(T1_blood)
                    for id_t2t = 1: length(T2_tissue)
                        for id_t2b = 1: length(T2_blood)
                            Phantom.T1_tissue = T1_tissue(id_t1t); 
                            Phantom.T1_blood = T1_blood(id_t1b); 
                            Phantom.T2_tissue = T2_tissue(id_t2t); 
                            Phantom.T2_blood = T2_blood(id_t2b); 
    
                            [S_m_noise]= Phantom_Simulation_BiExp_Relax_Pixel(Phantom,N_noise,b_values,TE(id_te),TR(id_tr));
                            DataMatrix(id_rep,:,1,:,id_te,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = S_m_noise;
    
                            waitbar(i/n, f, sprintf('Progress: %d %%', floor(i/n*100)));
                            i = i + 1;
                        end
                    end
                end
            end
        end
    end
end

%%
toPlot = [];
for ii = 1 :length(TE)
    TE1 =squeeze(DataMatrix(1,1,1,:,ii))*((Phantom.fslow *exp(-TE(ii)/60))+(Phantom.ffast *exp(-TE(ii)/60)));
    toPlot = cat(2,toPlot,TE1);
end

figure,
tiledlayout(3,3)
nexttile([3 1])

plot3(repmat(TE(1:end),[17 1]),repmat(b_values(b_value_index),[6 1])',toPlot(b_value_index,:),'o'), hold on
view(116,11)
title ('Data with multiple TEs')
xlabel('echo time (ms)')
ylabel('b-value')
zlabel('signal intensity')
set(gca,'TickDir','out')
nexttile(2)

scatter(b_values(b_value_index), squeeze(toPlot(b_value_index,1))), hold on
plot(b_values(:), squeeze(toPlot(:,1)))
set(gca,'YLim',[0 0.35],'TickDir','out')

% ylabel('signal intensity')
title('Separate IVIM Model for each TE')

nexttile(5)
scatter(b_values(b_value_index), squeeze(toPlot(b_value_index,3))), hold on
plot(b_values(:), squeeze(toPlot(:,3)))
set(gca,'YLim',[0 0.35],'TickDir','out')
ylabel('signal intensity')
nexttile(8)
scatter(b_values(b_value_index), squeeze(toPlot(b_value_index,6))), hold on
plot(b_values(:), squeeze(toPlot(:,6)))
set(gca,'YLim',[0 0.35],'TickDir','out')
xlabel('b-value')
% ylabel('signal intensity')
nexttile([3 1])

plot3(repmat(TE(:)',[17 1]),repmat(b_values(b_value_index),[6 1])',toPlot(b_value_index,:),'o'), hold on
plot3(repmat(TE(:)',[17 1]),repmat(b_values(b_value_index),[6 1])',toPlot(b_value_index,:)),
title('2D IVIM Model')
plot3(repmat(TE(:)',[17 1])',repmat(b_values(b_value_index),[6 1]),toPlot(b_value_index,:)'),
xlabel('echo time (ms)')
ylabel('b-value')
zlabel('signal intensity')
view(116,11)
set(gca,'TickDir','out')
%%
set(gcf,'Renderer', 'painters', 'Color',[1 1 1])

saveas(gcf,fullfile(outputDir ,'Model.fig'))
saveas(gcf,fullfile(outputDir ,'Model.pdf'),'pdf')