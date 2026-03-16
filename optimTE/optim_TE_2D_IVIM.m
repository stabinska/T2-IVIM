function [nRMSE]=optim_TE_2D_IVIM(TEVec,DataMatrix,PhantomPars)
    
            NoisePars.N_noise = PhantomPars.N_noise;
            NoisePars.N_rep = PhantomPars.N_rep;
            [DataMatrix] = add_noise_IVIM_T2_phantom(NoisePars,[],[], DataMatrix, 0,PhantomPars);
            
            PhantomPars.TE = PhantomPars.TE(TEVec);
            PhantomPars.NoiseSD= repmat(2*PhantomPars.N_noise',[1 length(PhantomPars.TE)]);
            
            DataMatrix = (DataMatrix(:,2,:,:,TEVec,:,1,:,1,:));
            noise_reps = size(DataMatrix,1);

            f_fast = zeros(noise_reps,length(PhantomPars.TR),...
                     length(PhantomPars.T1_tissue), length(PhantomPars.T1_blood), length(PhantomPars.T2_tissue),length(PhantomPars.T2_blood));
            f_fast_crlb = f_fast;

            switch PhantomPars.Organ
                case 'Kidney_invivo'
                     %         ffast Dslow   Dfast T2slow T2fast
                    lb =      [ 0.01  0.0007  0.01 10 50 ];  % Biexp
                    x0 =      [ 0.1  0.0015   0.015  60 60 ];
                    ub =      [ 0.7 0.01    0.5  90 320 ];
                case 'Liver_invivo'
                    %         ffast Dslow   Dfast T2slow T2fast
                    lb =      [ 0.01  0.0007  0.01 10 25 ];  % Biexp
                    x0 =      [ 0.1  0.001   0.05  30 45 ];
                    ub =      [ 0.7 0.01    0.9  45 320 ];
                case 'Kidney_Eric_table'
                    % from Eric's table
                    %         ffast Dslow   Dfast T2slow T2fast
                    lb =      [ 0.01  0.0007  0.01 25 25 ];  % Biexp
                    x0 =      [ 0.1  0.0015   0.08  40 40 ];
                    ub =      [ 0.7 0.01    0.9  90 320 ];
            end

           
            penalty = abs(length(unique(TEVec))-length(TEVec)) +(1-issorted(TEVec));
            
            if penalty == 0
                for id_tr = 1: length(PhantomPars.TR)
                    for id_t1t = 1: length(PhantomPars.T1_tissue)
                        for id_t1b = 1: length(PhantomPars.T1_blood)
                            for id_t2t = 1: length(PhantomPars.T2_tissue)
                                for id_t2b = 1: length(PhantomPars.T2_blood)
                                    for id_rep = 1 : noise_reps
                                        [xk,crlb] = createModelIVIM(squeeze(DataMatrix(id_rep,1,1,:,:,id_tr,id_t1t,id_t1b,id_t2t,id_t2b)), 'BiExpFitModelT2Relax',PhantomPars,lb,x0,ub,PhantomPars.NoiseSD(1,:),PhantomPars.TE);
                                           
                                                f_fast(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = xk(1);
                                                f_fast_crlb(id_rep,id_tr,id_t1t,id_t1b,id_t2t,id_t2b) = crlb(1);
    
                                    end
                                end
                            end
                        end
                    end
                end   
    
                % We have to calculate the nRMSE now like Assaf
                nRMSE = 0;
                f_fast_bias_sq = (f_fast-PhantomPars.ffast).^2;
                if ~PhantomPars.crlb
                    f_fast_var = var(f_fast,0,1);
                else
                    f_fast_var = f_fast_crlb.^2;
                end
                f_fast_eq = sqrt(f_fast_bias_sq+f_fast_var)./f_fast;
                if ~PhantomPars.crlb
                    f_fast_eq_mean = mean(f_fast_eq,1);
                else
                    f_fast_eq_mean = f_fast_eq;
                end
                nRMSE = sum(f_fast_eq_mean,'all');
            else
                % Violated constraint
                nRMSE = 0;
                f_fast_bias_sq = (2*PhantomPars.ffast).^2;
                f_fast_var = (ub(1)-lb(1)).^2;
                f_fast_eq = sqrt(f_fast_bias_sq+f_fast_var)./PhantomPars.ffast;
                nRMSE = f_fast_eq*length(PhantomPars.T2_blood);
            end

end