classdef IMUinfoProcess < matlab.System
    properties
        offsetTriggerTime=52;
    end

    properties (Access=private)
        offsetYaw=0;
        timeOld=0;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function [freeAcc,Eul_woOff,omegaW] = stepImpl(obj,acc,eul,omegaL,time)
                eulNew=[eul(3) eul(2) eul(1)];
                freeAcc=eul2rotm(eulNew)*acc-[0;0;9.81];
                if time>obj.offsetTriggerTime && obj.timeOld<obj.offsetTriggerTime
                    obj.offsetYaw=eul(3);
                end
                Eul_woOff=[eul(1),eul(2),eul(3)-obj.offsetYaw];
                R=Rz(eul(3))*Ry(eul(2))*Rx(eul(1));
                omegaW=R*omegaL;
                obj.timeOld=time;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end

function M=Rx(sita)
% 3D rotation matrix, from world to body
M=[1,0,0;
    0,cos(sita),-sin(sita);
    0,sin(sita),cos(sita)];
end

function M=Ry(sita)
% 3D rotation matrix, from world to body
M=[cos(sita),0,sin(sita);
    0,1,0;
    -sin(sita),0,cos(sita)];
end

function M=Rz(sita)
% 3D rotation matrix, vb=M*v:
% rotate a vector in one frame,
% or change the vector 'v' in rotated frame to 'vb' in world frame
M=[cos(sita),-sin(sita),0;
    sin(sita),cos(sita),0;
    0,0,1];
end