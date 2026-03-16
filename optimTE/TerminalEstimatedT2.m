function [out] = TerminalEstimatedT2(outputDir,outFile,index_1,index_2,bset)
    load(fullfile(outputDir,outFile))
    PhantomPars.Model = 'BiExpFitModelT2Relax';
    switch bset
        case {1,2}
            PhantomPars.b_values = [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 330, 350, 450, 500, 550, 650, 750, 800];
            PhantomPars.TE_values = [47,52,57,62,67,72,77,82,87,92];
        case 3
            PhantomPars.b_values = [0, 30, 70, 200, 330, 750];
            PhantomPars.TE_values = [47,52,57,62,67,72];
        case 4
            PhantomPars.b_values = [0, 10, 20, 100, 200, 550];
            PhantomPars.TE_values = [47,52,57,62,67,72];
        case 5 
            PhantomPars.b_values = [0,10,100,200,500,800];
            PhantomPars.TE_values = [47,52,57,62,67,72,77,82,87,92];
    end

    
    PhantomPars.N_noise(1)=0.025;
    
    switch bset
        case 1
            [~, indices_b_values, ~] = intersect(PhantomPars.b_values, [0,10,100,200,500,800]);
            [~, indices_te_values, ~] = intersect(PhantomPars.TE_values, [47,52,57,62,67,72]);
        case 2
            [~, indices_b_values, ~] = intersect(PhantomPars.b_values, [0, 10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 350, 450, 550, 650, 750]);
            [~, indices_te_values, ~] = intersect(PhantomPars.TE_values, [47,52,57,62,67,72]);
         case 3
            [~, indices_b_values, ~] = intersect(PhantomPars.b_values, [0,30,70,200,330,750]);
            [~, indices_te_values, ~] = intersect(PhantomPars.TE_values, [47,52,57,62,67,72]);
        case 4
            [~, indices_b_values, ~] = intersect(PhantomPars.b_values, [0, 10, 20, 100, 200, 550]);
            [~, indices_te_values, ~] = intersect(PhantomPars.TE_values, [47,52,57,62,67,72]);
        case 5
            [~, indices_b_values, ~] = intersect(PhantomPars.b_values, [0,10,100,200,500,800]);
            [~, indices_te_values, ~] = intersect(PhantomPars.TE_values, [47,52,57,62,67,72,77,82,87,92]);
    end
    
    PhantomPars.b_values = PhantomPars.b_values(indices_b_values);
    PhantomPars.TE_values = PhantomPars.TE_values(indices_te_values);
    
    PhantomPars.NoiseSD= repmat(2*PhantomPars.N_noise',[1 length(PhantomPars.TE_values)]);


    DataMatrix = (DataMatrix(index_1:index_2,2,1,indices_b_values,indices_te_values,:,1,:,1,:));
    noise_reps = size(DataMatrix,1);
    
    % Initialize arrays
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
            %         ffast Dslow   Dfast T2slow T2fast
            lb =      [ 0.01  0.0007  0.01 25 25 ];  % Biexp
            x0 =      [ 0.1  0.0015   0.08  40 40 ];
            ub =      [ 0.7 0.01    0.9  90 320 ];

            %         ffast Dslow   Dfast T2slow T2fast
            % lb =      [ 0.01  0.0007  0.01 25 25 ];  % Biexp
            % x0 =      [ 0.15  0.001   0.02  40 40 ];
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
    Results.f_fast_crlb = f_fast_crlb;
    Results.D_slow_crlb = D_slow_crlb;
    Results.D_fast_crlb = D_fast_crlb;
    switch PhantomPars.Model
            case 'BiExpFitModelT2RelaxS0'
                Results.S_0 = S_0;
                Results.S_0 = S_0_crlb;
    end
    save(fullfile(outputDir,strrep(outFile,'withNoise.mat',['Phantom_Model_T2_2D_Set_' num2str(bset) '_distribution_' num2str(index_2) '.mat'])),'Results','-v7.3');
    out = 1;
    exit;
end


