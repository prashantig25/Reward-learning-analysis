clc
clearvars

% Get the current working directory
currentDir = pwd;
save_dir = strcat('Data', filesep, 'estimation error analysis'); 
mkdir(save_dir);

% LOAD DATA
abs_lr = 1; % if absolute LRs are to be used for estimation error analysis
if abs_lr == 1
    betas_all = importdata(fullfile('Data',filesep,'LR analyses' ...
        ,filesep,'betas_abs_wo_rewunc_obj.mat')); % betas from lr analysis model
else
    betas_all = importdata(fullfile('Data',filesep,'LR analyses' ...
        ,filesep,'betas_signed_wo_rewunc_obj.mat')); % betas from lr analysis model
end
data = readtable(fullfile('Data',filesep,'LR analyses',filesep,'preprocessed_data.xlsx')); % get choice performance

% INITIALISE VARS
num_subjs = 98; % number of subjects
ecoperf = NaN(num_subjs,1); % initialised array for economic performance
esterror = NaN(num_subjs,1); % initialised array for estimation error
id_subjs = unique(data.ID); % subject IDs
save_mat = 1; % set to 1, if data needs to be saved for plotting
abs_esterror = 1; % set to 1, if analysis needs to be done for absolute estimation error
num_vars = 5; % number of variables
num_vars_partial = 4; % number of variables for partial R2
pred_vars = {'pe','pe__condiff','pe__salience','pe__congruence','pe__rewunc','pe__pesign'}; % predictor variables
resp_var = 'perf'; % response variable
cat_vars = ''; % categorical variables
res_subjs = []; % residuals

% INITIALISE MODELS
mdl = 'perf ~ pe + pe__condiff  + pe__pesign + pe__salience + pe__congruence'; % full model
mdl_pe = 'perf ~ pe__condiff + pe__salience + pe__congruence + pe__pesign'; % partial model without fixed LR
mdl_pe_condiff = 'perf ~ pe + pe__salience + pe__congruence + pe__pesign'; % partial model without BS adapted LR
mdl_pe_pesign = 'perf ~ pe + pe__condiff + pe__salience + pe__congruence'; % partial model without confirmation bias
mdl_pe_salience = 'perf ~ pe + pe__condiff + pe__congruence + pe__pesign'; % partial model without salience
mdl_pe_congruence = 'perf ~ pe + pe__condiff + pe__salience + pe__pesign'; % partial model without congruence
%% FIT LEARNING RATE ANALYSIS COEFFICIENTS TO MEAN PERFORMANCE

% COMPUTE ESTIMATION ERROR
for i = 1:height(data)
    if data.choice_cond(i) == 2 % actual mu for each condition
        data.actual_mu(i) = 0.9; 
    else 
        data.actual_mu(i) = 0.7;
    end
    data.est_error(i) = data.mu_congruence(i) - data.actual_mu(i); 
    if abs_esterror == 1
        data.est_error(i) = abs(data.est_error(i));
    end
end

% GET ECONOMIC PERFORMANCE & EST. ERROR
for i = 1:num_subjs
    ecoperf(i,:) = nanmean(data.ecoperf(data.ID == id_subjs(i)));
    esterror(i,:) = nanmean(data.est_error(data.ID == id_subjs(i)));
end

% NORMALISE ALL COEFFICIENTS
norm_betas_all = betas_all;
for i = 1:num_vars
    norm_betas_all(:,i) = normalise_zero_one(betas_all(:,i),NaN(height(betas_all),1));
end
norm_ecoperf = normalise_zero_one(ecoperf,NaN(height(betas_all),1));
norm_esterror = normalise_zero_one(esterror,NaN(height(betas_all),1));
data = [norm_betas_all,norm_esterror];

var_names = {'pe','pe__condiff','pe__salience','pe__congruence','pe__pesign','perf'}; % variable names
data_tbl = array2table(data, 'VariableNames', var_names); % data table
safe_saveall(fullfile(save_dir,"esterror_analysis_abs_error_abs_lr.xlsx"),data_tbl); % save table

% INITIALISE VARIABLES TO FIT MODEL
esterror = lr_analysis_obj(); % linear regression object
esterror.filename = 'Data\estimation error analysis\esterror_analysis_abs_error_abs_lr.xlsx'; % use the estimation error data file
esterror.mdl = mdl; % model to be fit
esterror.pred_vars = pred_vars; % predictor variables
esterror.resp_var = resp_var; % response variable
esterror.cat_vars = cat_vars; % categorical variables
esterror.num_vars = num_vars; % number of regressors
esterror.weighted = 0; % non-weighted regression
esterror.weight_y_n = 0;
esterror.absolute_analysis = 0; % absolute analysis or not

% FIT FULL AND PARTIAL MODELS
[~,~,~,~,lm] = esterror.linear_fit(data_tbl,@fitlm);
esterror.num_vars = num_vars_partial;
esterror.mdl = mdl_pe;
[~,~,~,~,lm_pe] = esterror.linear_fit(data_tbl,@fitlm);
esterror.mdl = mdl_pe_condiff;
[~,~,~,~,lm_pe_condiff] = esterror.linear_fit(data_tbl,@fitlm);
esterror.mdl = mdl_pe_pesign;
[~,~,~,~,lm_pe_pesign] = esterror.linear_fit(data_tbl,@fitlm);
esterror.mdl = mdl_pe_salience;
[~,~,~,~,lm_pe_salience] = esterror.linear_fit(data_tbl,@fitlm);
esterror.mdl = mdl_pe_congruence;
[betas,rsquared,residuals,coeffs_name,lm_pe_congruence] = esterror.linear_fit(data_tbl,@fitlm);

% COMPUTE PARTIAL R-SQAURE
rsq_full = lm.Rsquared.Ordinary; % r-square for full model
rsq_partial = [lm_pe.Rsquared.Ordinary; lm_pe_condiff.Rsquared.Ordinary; lm_pe_salience.Rsquared.Ordinary; lm_pe_congruence.Rsquared.Ordinary
    lm_pe_pesign.Rsquared.Ordinary]; % r-square for partial models
partial_rsq = NaN(5,1);
for i = 1:num_vars
    partial_rsq(i,1) = abs(compute_partialrsq(rsq_partial(i),rsq_full));
end

% SAVE DATA
if save_mat == 1
    safe_saveall(fullfile(save_dir,filesep,"lm_abs_esterror_abs_lr.mat"),lm);
    safe_saveall(fullfile(save_dir,filesep,"partialrsq_abs_esterror_abs_lr.mat"),partial_rsq);
end