par_fname='param_postoptim.inc';
sp_fname='schemat_postoptim.net';
bat_fname='LTspice.bat';
raw_fname='schemat_postoptim.raw';
varnames={'RC1';'RC2';'RC3';'RS';'RE1';'RE3';'R7'};
par_default=[5250;200;250;50;50;50;703.486];
derivatives=zeros(1,7);
par_start = 0;

for i = 2:3
  par_start = par_default(i);
  fc=@(par)opt_fc_postoptim(par_default,varnames,sp_fname,par_fname,bat_fname,raw_fname,i,par);
  %[d,e] = derivest(@(x) fc(x),par_start, 'vectorized','no', 'MaxStep', 0.01 * par_start);
  d = fc(250);
  derivatives(i) = d;
  
end

derivatives

%
%
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
%opt = optimset ( 'PlotFcns' ,@optimplotfval );
%[popt,fval,exitf,output]=fminsearch(fc,par,opt);


%popt
%fval
%output

