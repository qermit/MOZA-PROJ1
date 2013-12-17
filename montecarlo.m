%vdivMonte.m
R1nom=750;
%Nominal resistance values
R2nom=250;
t1=2;
%Resistor tolerances in %
t2=2;
Gnom=R2nom/(R1nom+R2nom);
%nominal gain
tg=1.5;
%Gain tolerance
n=15;
%Number of trials
m=0;
%
fprintf('\n')
fprintf('\tR1\t\tR2\t\tvo/vs \n')
fprintf('------------------------------------\n')
Gains = zeros(n,1);
for i=1:n
    R1=(1+(2*rand-1)*t1/100)*R1nom;
    %actual resistance values
    R2=(1+(2*rand-1)*t1/100)*R2nom;
    G = R2/(R1+R2);
    Gains(i) = G;
    %voltage divider gain
    if abs(G-Gnom)/Gnom<tg/100
        m=m+1;
    end
fprintf(' %6.3f %6.3f %6.4f \n',R1,R2,G)
end
fprintf('\n%4.1f%% of the voltage dividers have a ',100*m/n)
fprintf('gain\nthat is within %3.1f%% of %4.2f.\n',tg,Gnom)