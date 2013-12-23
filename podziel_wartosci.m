function [ varnames_const, varnames_var, params_const, params_var  ] = podziel_wartosci( varnames_all, params_start, varnames_to_be_var  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

varnames_const = {};
varnames_var  = {};
params_const = [];
params_var = [];
for i = 1:numel(varnames_all)
    if  strmatch(varnames_all(i), varnames_to_be_var,'exact')
        tmp = numel(varnames_var)+1;
        varnames_var{tmp,1} = varnames_all{i};
        params_var(tmp,1) = params_start(i);
    else
        tmp = numel(varnames_const)+1;
        varnames_const{tmp,1} = varnames_all{i};
        params_const(tmp,1) = params_start(i);
    end
end


end

