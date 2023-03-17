close all;

fk_l=fk_real_l_ts.Data;
fk_r=fk_real_r_ts.Data;
acc=acc_ts.Data;
figure();
subplot(2,1,1)
plot(time,acc);
subplot(2,1,2);
plot(time,fk_r);
hold on;
plot(time,fk_l);

startT=1;
endT=7;
tmp=find(time>startT);
startN=tmp(1);
tmp=find(time>endT);
endN=tmp(1);

dt=0.001;

dfk_l=(fk_l(2:end,:)-fk_l(1:end-1,:))/dt;
dfk_r=(fk_r(2:end,:)-fk_r(1:end-1,:))/dt;

varfk_l=var(fk_l(startN:endN,:));
varfk_r=var(fk_r(startN:endN,:));
vardfk_l=var(dfk_l(startN:endN,:));
vardfk_r=var(dfk_r(startN:endN,:));
varAcc=var(acc(startN:endN,:));

B=[0.5*eye(3)*dt^2;eye(3)*dt;zeros(6,3);zeros(3,3)];
R_u=B*diag(varAcc)*B';