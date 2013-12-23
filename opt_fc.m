function fc = opt_fc(params,varnames,...
    params_const, varnames_const,...
    sp_fname,par_fname,params_const_fname,bat_fname,raw_fname,...
    varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% funkcja przyjmuje parametry w nastêpuj¹cy sposów
% Je¿eli varname zaczyna siê od C -> wartoœæ to pikofarady (skalowana razy
% 10^-12)

params_count = numel(params);
params_const_count = numel(params_const);

i_p = inputParser;
i_p.FunctionName = 'opt_fc';
i_p.addRequired('params');
i_p.addRequired('varnames');
i_p.addRequired('params_const');
i_p.addRequired('varnames_const');

i_p.addOptional('minval_param',0.1);
i_p.parse(params, varnames,...
    params_const, varnames_const,...
    varargin{:});


%if(params(2)<0 || params(1) < 0 || params(3) < 0)
%¿aden z parametrów nie powinen byæ mniejszy od minval_param(0.1));
if(~isempty(find(params() <= i_p.Results.minval_param)))
    fc=0;
else
    
    for i=1:params_count
        if strncmp(varnames(i), 'C', 1)
            params(i) = params(i) * 1e-12;
        end
    end
        for i=1:params_const_count
        if strncmp(varnames_const(i), 'C', 1)
            params_const(i) = params_const(i) * 1e-12;
        end
    end
    
    [freq,y]=WZM_SP(params,varnames,...
        params_const,varnames_const,...
        sp_fname,par_fname,params_const_fname,bat_fname,raw_fname);

    %y = abs(y);
    k0=y(60);
    k0_prim=k0/0.01;
    k3db = k0/sqrt(2);
    k3db_prim = k0_prim/sqrt(2);
    ind = find(y<k3db,1,'first');
    f3db = freq(ind) / 1000000000;
    

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