classdef LegSptInd < matlab.System
    properties
        
    end

    properties (Access=private)
        legSptIndOld=ones(2,1);
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function legSptInd = stepImpl(obj,pas_delta,legPhi,legState)
            legSptInd = obj.legSptIndOld;
            if pas_delta(1)<-0.06
                legSptInd(1)=1;
            elseif pas_delta(1)>-0.0542*0.5
                if legState(1)>0.5 && legPhi(1)>0.8 || legState(1)<0.5
                    legSptInd(1)=0;
                end
            end

            if pas_delta(3)>0.06
                legSptInd(2)=1;
            elseif pas_delta(3)<0.0536*0.5
                if legState(2)>0.5 && legPhi(2)>0.8 || legState(2)<0.5
                    legSptInd(2)=0;
                end
            end
            obj.legSptIndOld=legSptInd;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end