function [name] = sec(file,row,fb,kb,tb,D,l)
%clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modeling of Hydrophilic %
% drug release from P(DL)-%
% LGA 53/47 film.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%import the data
data_raw = importdata(file);
data = data_raw.data;
data(isnan(data(:,2)),:)=[];



% parameters 
%fb=0.11; % Fraction of burst relase
%l=0.0045; % Half-thickness (cm)
%l=0.0025; % Half-thickness (cm)

%
%D=2.26*10^-12*24*3600; % Diffusion coefficient (cm2/day)
%kb=1.89; % Burst constant (day-1)
%tb=20.8; % End of Burst release (day)
fd=1-fb; % Fraction of diffusion release

% data import
M= data(:,row);
th = data(:,1);
t=th/24; % time in days

% divided time into 2 parts:
% burst and diffusion
nn=0;
for i=1:length(t)
    if t(i)<=tb
        t1(i)=t(i);
        nn=i;
    else 
        t2(i-nn)=t(i);
    end
end

% burst part
burst=fb*(1-exp(-1*t1*kb));

% diffusion part
n=0;
temp2=1;
temp=0;
tsum=0;
while abs(temp2-temp)>0.0000001;
    d=n+1;
    temp=8/((2*n+1)^2)/(pi^2)*exp(-1*D*(2*n+1)^2*pi^2*(t2-tb)/4/l^2);
    temp2=8/((2*d+1)^2)/(pi^2)*exp(-1*D*(2*d+1)^2*pi^2*(t2-tb)/4/l^2);
    tsum=temp+tsum;
    n=n+1;
end
diff=fd*(1-tsum);

% combine 2 parts
Mt=[burst,diff];
% plot the result
%plot(t,M,'--rs',t,Mt,'r')
%hold on
% calculate R^2
R=corrcoef(Mt,M);
R2=R(1,2).^2
end
