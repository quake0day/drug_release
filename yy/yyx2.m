function [name] = yyx2(sheet,range)
%clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modeling of Hydrophobic %
% drug release from P(DL)-%
% LGA 53/47 film.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Define data file name
DATA = 'data.xlsx';

% parameters 
fb=0.028; % Fraction of burst relase
l=0.0015; % Half-thickness (cm)
kr=0.070; % Degradation relaxation constant (day-1)
D=1.65*10^-12*24*3600; % Diffusion coefficient (cm2/day)
kb=0.083; % Burst constant (day-1)
tb=20.99; % End of Burst release (days)
tr=47.14; % End of relaxation release (days)
fr=0.074; % Relaxation release coefficient
fd=1-fb-fr; % Fraction of diffusion release

% data import
M=  xlsread(DATA,sheet,range)';
th = xlsread(DATA,sheet,'A3:A29')';
t=th/24; % time in days

% divided time into 3 parts:
% burst and diffusion
nb=0;
nr=0;
for i=1:length(t)
    if t(i)<=tb
        t1(i)=t(i);
        nb=i;
    else if t(i)<=tr 
        t2(i-nb)=t(i);
        nr=i;
    else 
        t3(i-nr)=t(i);
    end
    end
end

% burst part
burst=fb*(1-exp(-1*t1*kb));

% relaxation part

relaxation=fr*(exp(kr*(t2-tb))-1);


% diffusion part
if i-nr~=0
    n=0;
    temp2=1;
    temp=0;
    tsum=0;
    while abs(temp2-temp)>0.0000001;
        d=n+1;
        temp=8/((2*n+1)^2)/(pi^2)*exp(-1*D*(2*n+1)^2*pi^2*(t3-tr)/4/l^2);
        temp2=8/((2*d+1)^2)/(pi^2)*exp(-1*D*(2*d+1)^2*pi^2*(t3-tr)/4/l^2);
        tsum=temp+tsum;
        n=n+1;
    end
    diff=fd*(1-tsum);
end

% combine 3 parts
if i-nr~=0
    Mt=[burst,relaxation,diff];
else
    Mt=[burst,relaxation];
end

title(sheet);
plot(t,M,'--rs',t,Mt,'b')
hold on
end
