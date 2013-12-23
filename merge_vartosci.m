function [ params ] = merge_vartosci(  varnames_all, params_start, varnames_var, params_var )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

params = params_start;

for i = 1:numel(varnames_var)
    n=strmatch(varnames_var(i), varnames_all,'exact');
    params(n) = params_var(i);
end

end

