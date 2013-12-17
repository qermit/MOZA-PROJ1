par=[600.0;5.82e-12;0.956];
par_fname='param.inc';
sp_fname='schemat1.net';
bat_fname='LTspice.bat';
raw_fname='schemat1.raw';
varnames={'R5';'C1';'V3'};


fc=@(par)opt_fc(par,varnames,sp_fname,par_fname,bat_fname,raw_fname);


%BFGS
%opt=optimset(opt,'GradObj','on');
%opt=optimset(opt,'HessUpdate','bfgs');%
%opt = optimset('Display','iter','lArgeScale', 'off','MaxIter', 500,'TolFun', 1e-8);
%[popt,fval,exitflag,output] = fminunc(fc,par,opt);


%LM
%opt=optimset(opt,'PlotFcns',@optimplotfval );
%opt=optimset(opt,'Algorithm','levenberg-marquardt');
%[popt,resnorm,residual,exitflag,output]= lsqnonlin(fc,par,[],[],opt);

%NM
opt = optimset ( 'PlotFcns' ,@optimplotfval );
[popt,fval,exitf,output]=fminsearch(fc,par,opt);


popt
fval
output

