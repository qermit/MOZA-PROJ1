korel = [0.7;0 ];
liczba = numel(korel);
n = 1000;
wyniki = zeros(n,liczba);
par_default=[5250;200;250;50;50;50;703.486];
varnames={'RC1';'RC2';'RC3';'RS';'RE1';'RE3';'R7'};

for i=1:liczba
    wyniki(:, i) = cholesky_test(par_default, varnames,...
        'korelacja', korel(i),...
        'prefix', sprintf('Seria %d z %d', i, liczba), ...
        'n', n);
end
wariancje = var(wyniki);
%z1 = cholesky_test(par_default, varnames, 'korelacja', 0.7, 'n', 1000); var(z1);
%z2 = cholesky_test(par_default, varnames, 'korelacja', 0, 'n', 1000); var(z2);