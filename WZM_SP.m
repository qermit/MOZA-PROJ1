function [freq,y]=WZM_SP(par,varnames,...
    params_const, varnames_const,...
    sp_fname,par_fname,params_const_fname,bat_fname,raw_fname)
% y=LPF7_SP(p,sp_fname,par_fname,bat_fname,raw_fname)
% Funkcja obliczaj�ca przy pomocy NgSpice warto�ci
% |Av(f)| dla warto�ci f zapisanych w pliku analizy uk�adu
% Warto�ci cz�stotliwo�ci s� zwracane w wektorze freq, a 
% odpowiedzi - w wektorze y.
% varnames - cela, kt�rej sk�adowe s� nazwami parametr�w z wektora p
% sp_fname - �cie�ka do sparametryzowanego pliku opisuj�cego uk�ad
% par_fname - �cie�ka do pliku z definicjami zmiennych dla sp_fname
% params_const_fname - �cie�ka do pliku z definicjami sta�ych dla sp_fname
% bat_fname - plik wsadowy, wywo�uj�cy NgSpice'a dla sp_fname
% raw_fname - �cie�ka do pliku, kt�ry ma zawiera� wyniki
% symulacji w formacie raw-ascii. Za�o�ono, �e odpowiedzi AC
% s� w pierwszej sekcji wynik�w.
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