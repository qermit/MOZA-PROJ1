clear;

par=[600.0;5.82;0.956];
par_fname='param.inc';
par_fname_const='param_const.inc';
sp_fname='schemat_optim.net';
bat_fname='LTspice.bat';
raw_fname='schemat_optim.raw';
varnames={'R5';'C1';'V3'};



params_start=[5250;200;250;50;50;50;600.0;5.82;0.956];
varnames_all={'RC1';'RC2';'RC3';'RS';'RE1';'RE3';'R7';'C1';'V3'};
varnames_to_optim={'R7';'C1';'V3'};
varnames_to_postoptim={'RC1';'RC2';'RC3';'RS';'RE1';'RE3';'R7'};

do_optim = 0;
if (do_optim)
    
    [varnames_const, varnames_var, params_const, params_var] = podziel_wartosci (varnames_all, params_start, varnames_to_optim);
    fc=@(par)opt_fc(par, varnames_var, ...
        params_const, varnames_const,...
        sp_fname,par_fname,par_fname_const, bat_fname,raw_fname,...
        'minval_param', 0.2);
    
    %NM
    opt = optimset ( 'PlotFcns' ,@optimplotfval );
    [popt,fval,exitf,output]=fminsearch(fc,params_var,opt);
    save('workspace_optymalizacja.mat');
end

do_first = 1;
if (do_first)
    clear;
    load('workspace_optymalizacja.mat');
    
    
    fc=@(par)opt_fc(par, varnames_var, ...
        params_const, varnames_const,...
        sp_fname,par_fname,par_fname_const, bat_fname,raw_fname,...
        'minval_param', 0.2);
    fc(params_var);
    %fc(popt);
end

do_postoptim_montecarlo = 0;
if (do_postoptim_montecarlo)
    clear;
    load('workspace_optymalizacja.mat');
    params = merge_vartosci(varnames_all, params_start,  varnames_var, popt);     
    [varnames_const, varnames_var, params_const, params_var] = podziel_wartosci (varnames_all, params, varnames_to_postoptim);
   
    korel = [0.7;0];
    liczba = numel(korel);
    n = 100;
    wyniki = zeros(n,liczba);

    
    for i=1:liczba
        wyniki(:, i) = cholesky_test(params_var, varnames_var,...
            params_const, varnames_const,...
            'korelacja', korel(i),...
            'prefix', sprintf('Seria %d z %d', i, liczba), ...
            'n', n);
    end
    wariancje = var(wyniki);
    
    save('workspace_montecarlo.mat');
    
end


do_postoptim_deriv = 0;
if (do_postoptim_deriv)
    clear;
    load('workspace_optymalizacja.mat');
    
    params = merge_vartosci(varnames_all, params_start,  varnames_var, popt);
    %[varnames_const, varnames_var, params_const, params_var] = podziel_wartosci (varnames_all, params, varnames_to_postoptim);

    params_count = numel(varnames_to_postoptim);
    derivatives=zeros(1,params_count);
    variancje = zeros(1,params_count);
    par_start = 0;
    
    for i = 1:params_count
        %par_start = par_default(i);
        fprintf('Derivtest %d of %d\n', i, params_count);
        [varnames_const, varnames_var, params_const, params_var] = podziel_wartosci (varnames_all, params, varnames_to_postoptim(i));
        fc=@(par)opt_fc(par,varnames_var, params_const, varnames_const,...
            sp_fname,par_fname,par_fname_const,bat_fname,raw_fname);
        
        [d,e] = derivest(@(x) fc((x)),params_var(1), 'vectorized','no', 'MaxStep', 0.01 * params_var(1));
        %d = fc(200);
        derivatives(i) = d;
        variancje(i) = d^2 * (0.05 * params_var(1))^2;
    end
    save('workspace_derivatives.mat');

end

