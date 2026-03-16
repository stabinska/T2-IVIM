
%%
clear all
direc='/Users/helge/Library/Mobile Documents/com~apple~CloudDocs/2D_IVIM/20251108_R1_NewOptim_Distributions/20251112_Liver_largerTE_conB_D_Phantom_Model_2d_b_set_'


n_splits ={'100','200','300','400','500','600','700','800','900','1000'};

n_splits ={'100','200','300','400','500','600','700','800','900','1000',...
            '1100','1200','1300','1400','1500','1600','1700','1800','1900','2000',...
            '2100','2200','2300','2400','2500'};

for b_set = 1 : 1
    for te_set = 1 : 4
        load([direc num2str(b_set) '_te_set_' num2str(te_set) '_' n_splits{1} '.mat']);        
        fields = fieldnames(Results); 
        for ff = 1 : length(fields)
            AllResults.(fields{ff}) =[];
        end

        for noise = 1 : length(n_splits)
            load([direc num2str(b_set) '_te_set_' num2str(te_set) '_' n_splits{noise} '.mat']);        
            for ff = 1 : length(fields)
                AllResults.(fields{ff}) = cat(1,AllResults.(fields{ff}),Results.(fields{ff}));
            end
        end

        save([direc num2str(b_set) '_te_set_' num2str(te_set) '.mat'],'AllResults')
    end
end

%%
clear all
direc='/Users/helge/Library/Mobile Documents/com~apple~CloudDocs/2D_IVIM/20251112_Figure3_Data_R1/20250816_Liver_Phantom_Model_2d_b_set_1_te_set_1';



n_splits ={'100','200','300','400','500','600','700','800','900','1000'};

n_splits ={'100','200','300','400','500','600','700','800','900','1000',...
            '1100','1200','1300','1400','1500','1600','1700','1800','1900','2000',...
            '2100','2200','2300','2400','2500'};

for b_set = 1 : 1
    for te_set = 1 : 1
        load([direc '_' n_splits{1} '.mat']);        
        fields = fieldnames(Results); 
        for ff = 1 : length(fields)
            AllResults.(fields{ff}) =[];
        end

        for noise = 1 : length(n_splits)
            load([direc '_' n_splits{noise} '.mat']);        
            for ff = 1 : length(fields)
                AllResults.(fields{ff}) = cat(1,AllResults.(fields{ff}),Results.(fields{ff}));
            end
        end

        save([direc '.mat'],'AllResults')
    end
end