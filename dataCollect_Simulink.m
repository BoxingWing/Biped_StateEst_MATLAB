dataOut=out.simout.signals.values;
dataOut=reshape(dataOut,12,[]);
pCoM=dataOut(1:3,:);
vCoM=dataOut(4:6,:);
peW=dataOut(7:12,:);
save('simulink_outData.mat','pCoM','vCoM','peW');