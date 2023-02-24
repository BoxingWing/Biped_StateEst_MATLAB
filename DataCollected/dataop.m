%%
close all;
clear variables;
data = csvread('test.csv');

[num,~] = size(data);
qr = zeros(num,5);
qrref = zeros(num,5);
qrerr = zeros(num,5);
qrik = zeros(num,5);
ql = zeros(num,5);
qlref = zeros(num,5);
qlerr = zeros(num,5);
qlik = zeros(num,5);

Ir = zeros(num,4);
Il = zeros(num,4);

Terminal_ref = zeros(num,10);

Terminal_ik = zeros(num,14);
Terminal_fk = zeros(num,10);

imu = zeros(num, 9);

pas = zeros(num,4);


control_word = data(:,88);
qr(:,1) = data(:,6);
qr(:,2) = data(:,7);
qr(:,3) = data(:,8);
qr(:,4) = data(:,9);
qr(:,5) = data(:,10);
qrref(:,1) = data(:,1);
qrref(:,2) = data(:,2);
qrref(:,3) = data(:,3);
qrref(:,4) = data(:,4);
qrref(:,5) = data(:,5);
qrerr(:,1) = data(:,91);
qrerr(:,2) = data(:,92);
qrerr(:,3) = data(:,93);
qrerr(:,4) = data(:,94);
qrerr(:,5) = data(:,95);
limit_r = [];
%theta_G_r = q4_r + q5_r;

qrik(:,1) = data(:,78);
qrik(:,2) = data(:,79);
qrik(:,3) = data(:,80);
qrik(:,4) = data(:,81);
qrik(:,5) = data(:,82);

ql(:,1) = data(:,16);
ql(:,2) = data(:,17);
ql(:,3) = data(:,18);
ql(:,4) = data(:,19);
ql(:,5) = data(:,20);
qlref(:,1) = data(:,11);
qlref(:,2) = data(:,12);
qlref(:,3) = data(:,13);
qlref(:,4) = data(:,14);
qlref(:,5) = data(:,15);
qlerr(:,1) = data(:,96);
qlerr(:,2) = data(:,97);
qlerr(:,3) = data(:,98);
qlerr(:,4) = data(:,99);
qlerr(:,5) = data(:,100);
%theta_G_l = q4_l + q5_l;

qlik(:,1) = data(:,83);
qlik(:,2) = data(:,84);
qlik(:,3) = data(:,85);
qlik(:,4) = data(:,86);
qlik(:,5) = data(:,87);

Ir = data(:,49:52);
Il = data(:,53:56);

Terminal_ref = data(:,102:111);

imu = data(:,67:75);

pas = data(:,21:24);

Terminal_ik = data(:,78:91);

Terminal_fk = data(:,92:101);


startN=1000;

phaseAll=data(startN:end,117);

legSwing=data(startN:end,116); % 1 for right leg, 2 for left leg

fk_real_r=data(startN:end,92:94);

fk_real_l=data(startN:end,97:99);

RPY=data(startN:end,67:69)/180*pi; % rad/s

acc=data(startN:end,70:72);

gyro=data(startN:end,73:75); % rad/s

time=(0:1:length(phaseAll)-1)*0.001;

phaseAll_ts=timeseries(phaseAll,time);
legSwing_ts=timeseries(legSwing,time);
fk_real_r_ts=timeseries(fk_real_r,time);
fk_real_l_ts=timeseries(fk_real_l,time);
RPY_ts=timeseries(RPY,time);
acc_ts=timeseries(acc,time);
gyro_ts=timeseries(gyro,time);

answer = questdlg("Save current data into a MatFile?");
if strcmp(answer,'Yes')
save('TestDataV1_02_22.mat','phaseAll_ts','legSwing_ts',...
    "fk_real_r_ts","fk_real_l_ts","RPY_ts","acc_ts","gyro_ts", ...
    "time");
disp('Data Saved!');
end

figure();
plot(time',acc(:,1));
hold on;
plot(time',acc(:,2));
plot(time',acc(:,3));

legend('accx','accy','accz');

startT=53;
endT=55;
tmp=find(time>startT);
startTn=tmp(1);
tmp=find(time>endT);
endTn=tmp(1);

accX_std=std(acc(startTn:endTn,1))^2
accY_std=std(acc(startTn:endTn,2))^2
accZ_std=std(acc(startTn:endTn,3))^2

% figure;%1
% for i = 1:5
%     subplot(4,5,i);
%     plot(qr(:,i)/pi*180,'b');
%     hold on;
%     plot(Terminal_ik(:,i)/pi*180,'r');
% end
% 
% subplot(4,5,6);
% plot(pas(:,1)/pi*180,'b');
% hold on;
% plot(Terminal_ik(:,6)/pi*180,'r');
% subplot(4,5,7);
% plot(pas(:,2)/pi*180,'b');
% hold on;
% plot(Terminal_ik(:,7)/pi*180,'r');
% 
% for i = 1:5
%     subplot(4,5,i+10);
%     plot(ql(:,i)/pi*180,'b');
%     hold on;
%     plot(Terminal_ik(:,7+i)/pi*180,'r');
% end
% 
% subplot(4,5,16);
% plot(pas(:,3)/pi*180,'b');
% hold on;
% plot(Terminal_ik(:,13)/pi*180,'r');
% subplot(4,5,17);
% plot(pas(:,4)/pi*180,'b');
% hold on;
% plot(Terminal_ik(:,14)/pi*180,'r');
% 
% figure;%2
% % px, py, pz, yaw, pitch
% for i = 1:10
%     subplot(3,5,i);
%     plot(Terminal_ref(:,i),'r');
%     hold on;
%     plot(Terminal_fk(:,i),'b');
% end
% 
% figure;%3
% for i = 1:4
%     subplot(3,4,i);
%     plot(Ir(:,i));
% end
% for i = 1:4
%     subplot(3,4,i+4);
%     plot(Il(:,i));
% end
% 
% figure;%4
% for i = 1:9
%     subplot(3,3,i);
%     plot(imu(:,i));
% end
% 
% figure;%5
% for i = 1:7
%     subplot(4,5,i);
%     plot(Terminal_ik(:,i)/pi*180);
% end
% for i = 8:14
%     subplot(4,5,i+3);
%     plot(Terminal_ik(:,i)/pi*180);
% end





