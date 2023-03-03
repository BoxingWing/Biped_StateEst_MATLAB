clear variables;
close all;
% cXXfile=fopen('OutputData_C_pp.txt','r');
% formatStr='%f %f %f %f %f %f %f %f %f %f %f %f\n';
% A=fscanf(cXXfile,formatStr,[inf 12]);
% fclose(cXXfile);
A=importdata('OutputData_C_pp.txt');
pCoM_CXX=A(:,1:3);
vCoM_CXX=A(:,4:6);
peW_CXX=A(:,7:12);
time_CXX=(0:1:length(pCoM_CXX(:,1))-1)*0.001;

smuData=load('simulink_outData.mat');
time_SMU=(0:1:length(smuData.pCoM(1,:))-1)*0.001;

figure();
subplot(2,2,1)
plot(time_CXX,pCoM_CXX(:,1),time_CXX,pCoM_CXX(:,2),time_CXX,pCoM_CXX(:,3));
hold on;
plot(time_SMU,smuData.pCoM(2,:));
subplot(2,2,2)
plot(time_CXX,vCoM_CXX(:,1));
hold on;
plot(time_SMU,smuData.vCoM(1,:));
subplot(2,2,3)
plot(time_CXX,peW_CXX(:,3));
hold on;
plot(time_SMU,smuData.peW(3,:))
subplot(2,2,4)
plot(time_CXX,peW_CXX(:,5));
hold on;
plot(time_SMU,smuData.peW(5,:))
legend('CXX','SMU')