function [z] = cholesky_test(params_var, varnames_var,...
    params_const, varnames_const,...
    varargin)
%function [z] = cholesky_test(params_orig,varnames,sp_fname,par_fname,bat_fname,raw_fname,var_to_opt, var_val, korelacja)
%par_fname='param_postoptim.inc';
%sp_fname='schemat_postoptim.net';
%bat_fname='LTspice.bat';
%raw_fname='schemat_postoptim.raw';
i_p = inputParser;
i_p.FunctionName = 'cholesky_test';

i_p.addRequired('params_var');
i_p.addRequired('varnames_var');
i_p.addRequired('params_const');
i_p.addRequired('varnames_const');
i_p.addOptional('korelacja',0); 
i_p.addOptional('n', 10);

i_p.addOptional('par_fname','param.inc');
i_p.addOptional('params_const_fname','param_const.inc');

i_p.addOptional('sp_fname','schemat_optim.net');
i_p.addOptional('bat_fname','LTspice.bat');
i_p.addOptional('raw_fname','schemat_optim.raw');
i_p.addOptional('prefix','Test');

i_p.parse(params_var, varnames_var,params_const, varnames_const, varargin{:});
i_p.Results

%params=params_orig;
%if (var_to_opt>0)
%    numel(params_orig);
%    params(var_to_opt) = var_val;
%end

    n = i_p.Results.n;
    params_count = numel(i_p.Results.params_var);
    x1 = randn(n,params_count);
    
    m = ones(params_count) * i_p.Results.korelacja;

    for i=1:params_count
        m(i,i) = 1;
    end
    
    
    random_vals=x1 * chol(m);
    %z = corrcoef(random_vals);
    z =random_vals;
    
        
    
    z = zeros(n,1);
    for i = 1:n
        sprintf('%s: Iteracja %d na %d', i_p.Results.prefix, i, n)
        
        params = zeros(params_count,1);
        for j=1:params_count
            % 5% 
            zmiana = i_p.Results.params_var(j) * 0.05 * random_vals(i,j);
            params(j) = i_p.Results.params_var(j) + zmiana;
        end
        %z = params;
        z(i) = opt_fc(params,i_p.Results.varnames_var,...
            params_const, varnames_const, ...
            i_p.Results.sp_fname,...
            i_p.Results.par_fname,...
            i_p.Results.params_const_fname,...
            i_p.Results.bat_fname,...
            i_p.Results.raw_fname);
    end
       
    
end