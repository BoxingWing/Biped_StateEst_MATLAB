classdef LegStatePhi < matlab.System
    properties
        maxPhiCount=500;
    end

    properties (Access=private)
        StartFlag=false;
        legSwingOld=2;
        phaseAllOld=0;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function [LegStateNew,LegPhi,EN] = stepImpl(obj,phaseAll,legSwing)
           LegStateNew=ones(2,1);
           LegPhi=zeros(2,1);

           if obj.StartFlag==true
                LegPhi(1,1)=phaseAll/obj.maxPhiCount;
                LegPhi(2,1)=phaseAll/obj.maxPhiCount;
                if abs(legSwing-1)<0.1
                    LegStateNew(1,1)=0; % right leg
                    LegStateNew(2,1)=1; % left leg
                else
                    LegStateNew(1,1)=1; % right leg
                    LegStateNew(2,1)=0; % left leg
                end

           end
           
           if phaseAll~=obj.phaseAllOld && obj.StartFlag==false
               obj.StartFlag=true;
           end
           obj.legSwingOld=legSwing;
           obj.phaseAllOld=phaseAll;

           EN=~obj.StartFlag;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end