function [out] = TerminalOpt(outputDir,outFile,index_1,index_2, optim_method, organ)
    % addpath(genpath(path));
   switch optim_method
       case 1
            Bsets{1} = [0, 200, 500];
            Bsets{2} = [0, 10, 20, 100, 200, 500];
            Bsets{3} = [0, 200, 800];
            Bsets{4} = [0, 30, 70, 200, 330, 800];
            Bsets{5} = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750];
            
            TEsets{1} = [47,57,72];
            TEsets{2} = [52,72,92];
            TEsets{3} = [72,82,92];
            TEsets{4} = [47,57,67,77];
            TEsets{5} = [62,72,82,92];
            TEsets{6} = [52,62,72,82,92];
            TEsets{7} = [47,52,57,62,67,72];
       case 2 % In vivo TE with cortex consensus b-values
            Bsets{1} = [0, 30, 70, 100, 200, 750];
            
            TEsets{1} = [47,72];
            TEsets{2} = [47,57,72];
            TEsets{3} = [47,52,62,72];
            TEsets{4} = [47,52,62,67,72];
       case 3 % In vivo TE with medulla consensus b-values
            Bsets{1} = [0, 30, 70, 100, 200, 750];
            
            TEsets{1} = [47,67];
            TEsets{2} = [47,62,67];
            TEsets{3} = [47,52,57,72];
            TEsets{4} = [47,57,62,67,72]; 
       case 4 % In vivo TE with liver consensus b-values
            Bsets{1} = [0, 10, 20, 100, 200, 550];
            
            TEsets{1} = [47,72];
            TEsets{2} = [47,52,72];
            TEsets{3} = [47,52,62,72];
            TEsets{4} = [47,52,57,67,72]; 
       case 5 % Free TE with cortex consensus b-values
            Bsets{1} = [0, 30, 70, 100, 200, 750];
            
            TEsets{1} = [60,95];
            TEsets{2} = [50,65,100];
            TEsets{3} = [50,55,90,100];
            TEsets{4} = [50,55,60,95,100];
       case 6 % Free TE with medulla consensus b-values
            Bsets{1} = [0, 30, 70, 100, 200, 750];
            
            TEsets{1} = [55,95];
            TEsets{2} = [60,70,100];
            TEsets{3} = [50,55,60,95];
            TEsets{4} = [50,60,80,90,95]; 
       case 7 % Free TE with liver consensus b-values
            Bsets{1} = [0, 10, 20, 100, 200, 550];
            
            TEsets{1} = [50,100];
            TEsets{2} = [55,65,100];
            TEsets{3} = [50,55,60,100];
            TEsets{4} = [55,60,75,90,100];  
       case 8 % Liver
            Bsets{1} = [0, 10, 100, 200, 500, 800];            
            TEsets{1} = [47,52,57,62,67,72,77,82,87,92];
   end
    
    % outputDir =pwd;
    load(fullfile(outputDir,outFile));
    PhantomPars.Model = 'BiExpFitModelT2Relax';
    switch optim_method
        case 1
            b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 330, 350, 450, 500, 550, 650, 750, 800];
            TE_values = [47,52,57,62,67,72,77,82,87,92];
        case 2
            b_values = [0, 30, 70, 100, 200, 750];
            TE_values = [47,52,57,62,67,72];
        case 3
            b_values = [0, 30, 70, 100, 200, 750];
            TE_values = [47,52,57,62,67,72];
        case 4
            b_values = [0, 10, 20, 100, 200, 550];
            TE_values = [47,52,57,62,67,72];
        case 5
            b_values = [0, 30, 70, 100, 200, 750];
            TE_values = [50:5:100];
        case 6
            b_values = [0, 30, 70, 100, 200, 750];
            TE_values = [50:5:100];
        case 7
            b_values = [0, 10, 20, 100, 200, 550];
            TE_values = [50:5:100];
        case 8 
            b_values = [0, 10, 100, 200, 500, 800];    
            TE_values = [47,52,57,62,67,72,77,82,87,92];
    end
    % PhantomPars.N_noise(1)=0.025;
    N_noise = PhantomPars.N_noise;
    FullDataMatrix = DataMatrix;
    
    
    for b_set_id = 1 : length(Bsets)
        for te_set_id = 1 : length(TEsets)
        
            [~, indices_b_values, ~] = intersect(b_values, Bsets{b_set_id});
            [~, indices_te_values, ~] = intersect(TE_values, TEsets{te_set_id});
            
            PhantomPars.b_values = b_values(indices_b_values);
            PhantomPars.TE_values = TE_values(indices_te_values);
            PhantomPars.NoiseSD= repmat(2*N_noise',[1 length(PhantomPars.TE_values)]);
            
            DataMatrix = (FullDataMatrix(index_1:index_2,2,:,indices_b_values,indices_te_values,:,1,:,1,:));
            noise_reps = size(DataMatrix,1);

            f_fast = zeros(noise_reps,length(PhantomPars.TR),...
                     length(PhantomPars.T1_tissue), length(PhantomPars.T1_blood), length(PhantomPars.T2_tissue),length(PhantomPars.T2_blood));
            D_slow = f_fast;
            D_fast = f_fast;
            T2_slow = f_fast;
            T2_fast = f_fast;
            
            f_fast_crlb = f_fast;
            D_slow_crlb = f_fast;
            D_fast_crlb = f_fast;
            T2_slow_crlb = f_fast;
            T2_fast_crlb = f_fast;
            switch PhantomPars.Model
            case 'BiExpFitModelT2RelaxS0'
            S_0 = f_fast;
            S_0_crlb = f_fast;
            end
            
            switch PhantomPars.Model
                case 'BiExpFitModelS0'
                    %       ffast Dslow  Dfast s0 
                    lb =  [ 0.01  0.0007  0.01 50];  % Biexp
                    x0 =  [ 0.1   0.0015 0.08 184];
                    ub =  [ 0.7   0.01   0.9  250];
                case 'BiExpFitModel'
                    %       ffast Dslow  Dfast 
                    lb =  [ 0.01  0.0007  0.01];  % Biexp
                    x0 =  [ 0.1   0.0015 0.08];
                    ub =  [ 0.7   0.01   0.9];
                case 'BiExpFitModelT2Relax'
                    switch organ 
                        case 1 % Kidney
                            %         ffast Dslow   Dfast T2slow T2fast
                            lb =      [ 0.01  0.0007  0.005 40 55 ];  % Biexp
                            x0 =      [ 0.15  0.001   0.012  70 85 ];
                            ub =      [ 0.7 0.005    0.9  80 320 ];
                            % from in vivo ISMRM settings
                            %         ffast Dslow   Dfast T2slow T2fast
                            lb =      [ 0.01  0.0007  0.01 10 50 ];  % Biexp
                            x0 =      [ 0.1  0.0015   0.015  60 60 ];
                            ub =      [ 0.7 0.01    0.5  90 320 ];
                        case 2 % Liver
                            %         ffast Dslow   Dfast T2slow T2fast
                            lb =      [ 0.01  0.0007  0.01 10 25 ];  % Biexp
                            x0 =      [ 0.1  0.001   0.05  30 45 ];
                            ub =      [ 0.7 0.01    0.9  45 320 ];
                    end
                    %         ffast Dslow   Dfast T2slow T2fast
                    % lb =      [ 0.01  0.0007  0.01 25 25 ];  % Biexp
                    % x0 =      [ 0.1  0.0015   0.08  40 40 ];
                    % ub =      [ 0.7 0.01    0.9  90 320 ];
            end
            
            for id_tr = 1: length(PhantomPars.TR)
                for id_t1t = 1: length(PhantomPars.T1_tissue)
                    for id_t1b = 1: length(PhantomPars.T1_blood)
                        for id_t2t = 1: length(PhantomPars.T2_tissue)
                            for id_t2b = 1: length(PhantomPars.T2_blood)
                                for id_rep = 1 : noise_reps
                                    [xk,crlb] = createModelIVIM(squeeze(DataMatrix(id_rep,1,1,:,:,id_tr,id_t1t,id_t1b,id_t2t,id_t2b)), PhantomPars.Model,PhantomPars,lb,x0,ub,PhantomPars.NoiseSD(2,:),PhantomPars.TE_values);
                                    
                                    switch PhantomPars.Model
                                        case 'BiExpFitModelT2RelaxS0'
                                        f_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(1);
                                        D_slow(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(2);
                                        D_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(3);
                                        T2_slow(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(4);
                                        T2_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(5);
                                        S_0(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(6);
                                        
                                        f_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(1);
                                        D_slow_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(2);
                                        D_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(3);
                                        T2_slow_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(4);
                                        T2_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(5);
                                        S_0_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(6);
                                        case 'BiExpFitModelT2Relax'
                                        
                                        f_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(1);
                                        D_slow(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(2);
                                        D_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(3);
                                        T2_slow(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(4);
                                        T2_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(5);
                                        
                                        f_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(1);
                                        D_slow_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(2);
                                        D_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(3);
                                        T2_slow_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(4);
                                        T2_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(5);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        
        
            Results.f_fast = f_fast;
            Results.D_slow = D_slow;
            Results.D_fast = D_fast;
            Results.T2_slow = T2_slow;
            Results.T2_fast = T2_fast;
            Results.f_fast_crlb = f_fast_crlb;
            Results.D_slow_crlb = D_slow_crlb;
            Results.D_fast_crlb = D_fast_crlb;
            Results.T2_slow_crlb = T2_slow_crlb;
            Results.T2_fast_crlb = T2_fast_crlb;
            switch PhantomPars.Model
            case 'BiExpFitModelT2RelaxS0'
            Results.S_0 = S_0;
            Results.S_0 = S_0_crlb;
            end
            save(fullfile(outputDir,strrep(outFile,'withNoise.mat',['Phantom_Model_separate_b_set_' num2str(b_set_id) '_te_set_' num2str(te_set_id) '_' num2str(index_2) '.mat'])),'Results','-v7.3');
        end %TE sets
    end % b value set

    out = 1;
    exit;
end


