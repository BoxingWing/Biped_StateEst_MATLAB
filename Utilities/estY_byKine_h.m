classdef estY_byKine_h < matlab.System
    % get CoM velocity est from the joints position feedback
    properties (Access=private)
%         yWidth=97/1000; % distantce between left and right roll axis, i.e. distance between left and right leg coordinates
%         xWidth=210.8/1000; % distance between fore and hind pitch axis, i.e. distance between fore and hind leg coordinates
        pArrayOld=zeros(3,2);
        iniCount=0;
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
%             obj.piOFF(:,1)=[obj.xWidth;obj.yWidth;0]/2;
%             obj.piOFF(:,2)=[obj.xWidth;-obj.yWidth;0]/2;
%             obj.piOFF(:,3)=[-obj.xWidth;obj.yWidth;0]/2;
%             obj.piOFF(:,4)=[-obj.xWidth;-obj.yWidth;0]/2;
            obj.iniCount=0;
        end
        
        function [ym,pArray_W_kine,vArray_W_kine] = stepImpl(obj,pArray_B,RPY,OmegaW,dt)
            % omegaB must be the world coordinate
            % pArray_B is the foot-end position in body coordinate, unit: m
            %R=Rz(RPY(3))*Ry(RPY(2))*Rx(RPY(1));
            R=eul2rotm([RPY(3),RPY(2),RPY(1)]);
            pArray_B=reshape(pArray_B,3,2);
            pArray_W=R*pArray_B;
            vArray_W=zeros(3,2);
            for i=1:1:2
                vArray_W(:,i)=-R*(pArray_B(:,i)-obj.pArrayOld(:,i))/dt+cross(OmegaW,pArray_W(:,i));
            end
            if obj.iniCount<0.5
                vArray_W=zeros(3,2);
                obj.iniCount=1;
            end

            ym=[reshape(pArray_W,6,1);reshape(vArray_W,6,1);0;0];
            pArray_W_kine=pArray_W;
            vArray_W_kine=vArray_W;
            obj.pArrayOld=pArray_B;
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