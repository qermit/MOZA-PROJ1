function fc = opt_fc_postoptim(params_orig,varnames,sp_fname,par_fname,bat_fname,raw_fname,var_to_opt, var_val)

numel(params_orig);
params=params_orig;
if (var_to_opt > 0)
    params(var_to_opt) = var_val;
end
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%[varnames(var_to_opt), var_val]
%params
%if(params(2)<0 || params(1) < 0 || params(3) < 0)
if(params(2)<0 || params(1) < 0 || params(3) < 0)
    fc=0;
else
    
    [freq,y]=LPF7_SP(params,varnames,sp_fname,par_fname,bat_fname,raw_fname);

    k0=y(60);
    k0_prim=k0/0.01;
    k3db = k0/sqrt(2);
    k3db_prim = k0_prim/sqrt(2);
    ind = find(y<k3db,1,'first');
    f3db = freq(ind) / 1000000;
    

if isempty(ind)
    fc=0;
else
    if(f3db>1000000000)
        fc=0;
    elseif(k0_prim<2)
        fc=0;
    %elseif(par
    else
        %hold on
        %grid on
        fc=-(k0_prim*f3db);
        %subplot(2,1,1), plot(k0,f3db,'o')
end
end
end