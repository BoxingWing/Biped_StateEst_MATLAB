classdef TrustRegion_h_v2 < matlab.System
    properties
        k_few=10;
        k_fez2zero=10^-3;
    end

    properties (Access=private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function [Xi,Xih,diagXi,diagXih] = stepImpl(obj,LegState,LegPhi,pW)
           pW_M=reshape(pW,3,2);
           C=zeros(3,3,2);
           Ch=zeros(2,1);
           for i=1:1:2
                %Cphi=CphiFun(LegPhi(i),LegState(i),obj.Cphi_W);
                Cphi=CphiFun(0.5,LegState(i),obj.Cphi_W);
                Cz=CzFun(pW_M(3,i),obj.Cz_kp,obj.Cz_kn);

%                 C(:,:,i)=Cphi*diag([1,1,Cz]);
%                 Ch(i)=Cphi*Cz;
                C(:,:,i)=Cphi*diag([1,1,1]);
                Ch(i)=Cphi*1;
           end
           Xi=eye(6)+obj.k*(eye(6)-blkdiag(C(:,:,1), ...
               C(:,:,2)));
           Xih=eye(2)+obj.k_h*(eye(2)-diag(Ch));
           diagXi=diag(Xi);
           diagXih=Ch;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end
function y=CphiFun(phi,s,W)
if phi>1
    phi=1;
end
if phi<0
    phi=0;
end
    y=s*(erf(12*phi/W-6)+erf(12*(1-phi)/W-6)-1);
end

function y=CzFun(pz,kp,kn)
% kp=100;
% kn=20;
if pz>=0
    y=exp(-kp*pz^2);
else
    y=exp(-kn*pz^2);
end
end

% function y=erf(x)
%     y=1/(1+exp(-x));
% end