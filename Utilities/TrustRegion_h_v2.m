classdef TrustRegion_h_v2 < matlab.System
    properties
        k_few=10;
        k_fez2zero=10;
    end

    properties (Access=private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function [Xi,Xih,diagXi,diagXih] = stepImpl(obj,LegState)
           xiDiag=ones(2,3);
           xiHDiag=ones(2,1);
           for i=1:1:2
                %Cphi=CphiFun(LegPhi(i),LegState(i),obj.Cphi_W);
                %Cphi=CphiFun(0.5,LegState(i),obj.Cphi_W);
                if LegState(i)>0.8
                    xiDiag(i,:)=[1,1,obj.k_few];
                    xiHDiag(i)=1;
                else
                    xiDiag(i,:)=[obj.k_few,obj.k_few,obj.k_few];
                    xiHDiag(i)=obj.k_fez2zero;
                end
           end
           Xi=diag(reshape(xiDiag,6,1));
           Xih=diag(xiHDiag);
           diagXi=diag(Xi);
           diagXih=diag(Xih);
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