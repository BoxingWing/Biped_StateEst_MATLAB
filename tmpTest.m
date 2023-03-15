clear variables;
close all;
phi=linspace(0,1,1000);
s=ones(1,1000);
y=zeros(1,1000);
for i=1:1:1000
    y(i)=CphiFun(phi(i),s(i),0.1);
end

plot(phi,y)


function y=CphiFun(phi,s,W)
    y=s*(erf2(12*phi/W-6)+erf2(12*(1-phi)/W-6)-1);
end

function y=erf2(x)
    y=1/(1+exp(-x));
end