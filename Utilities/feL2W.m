classdef feL2W < matlab.System
    % get CoM velocity est from the joints position feedback
    properties (Access=private)

    end
    
    methods(Access = protected)
        function setupImpl(obj)

        end
        
        function pArray_W = stepImpl(obj,pArray_B,RPY)
            % omegaB must be the world coordinate
            % pArray_B is the foot-end position in body coordinate, unit: m
            %R=Rz(RPY(3))*Ry(RPY(2))*Rx(RPY(1));
            R=eul2rotm([RPY(3),RPY(2),RPY(1)]);
            pArray_B=reshape(pArray_B,3,2);
            pArray_W=R*pArray_B;
            pArray_W=reshape(pArray_W,6,1);
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