function [freq,y]=WZM_SP(par,varnames,...
    params_const, varnames_const,...
    sp_fname,par_fname,params_const_fname,bat_fname,raw_fname)
% y=LPF7_SP(p,sp_fname,par_fname,bat_fname,raw_fname)
% Funkcja obliczaj¹ca przy pomocy NgSpice wartoœci
% |Av(f)| dla wartoœci f zapisanych w pliku analizy uk³adu
% Wartoœci czêstotliwoœci s¹ zwracane w wektorze freq, a 
% odpowiedzi - w wektorze y.
% varnames - cela, której sk³adowe s¹ nazwami parametrów z wektora p
% sp_fname - œcie¿ka do sparametryzowanego pliku opisuj¹cego uk³ad
% par_fname - œcie¿ka do pliku z definicjami zmiennych dla sp_fname
% params_const_fname - œcie¿ka do pliku z definicjami sta³ych dla sp_fname
% bat_fname - plik wsadowy, wywo³uj¹cy NgSpice'a dla sp_fname
% raw_fname - œcie¿ka do pliku, który ma zawieraæ wyniki
% symulacji w formacie raw-ascii. Za³o¿ono, ¿e odpowiedzi AC
% s¹ w pierwszej sekcji wyników.
% 17.XI.2012, L. Opalski

np=numel(varnames);
fid=fopen(par_fname,'w+');
for n=1:np
    fprintf(fid,'.PARAM %s %g\n',varnames{n},par(n));
end
fclose(fid);

np=numel(varnames_const);
fid=fopen(params_const_fname,'w+');
for n=1:np
    fprintf(fid,'.PARAM %s %g\n',varnames_const{n},params_const(n));
end
fclose(fid);

test = sprintf('%s -b %s -r %s',bat_fname,sp_fname,raw_fname);
[status,result]=system(test);

raw_data = LTspice2Matlab(raw_fname);
freq=raw_data.freq_vect;
vout_index = strmatch('V(out)', raw_data.variable_name_list, 'exact');
%vout_index = 5;
y=real(raw_data.variable_mat(vout_index,:));