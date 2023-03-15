classdef LegSptInd < matlab.System
    properties
        maxPhiCount=500;
    end

    properties (Access=private)
        legSptIndOld=ones(2,1);
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function legSptInd = stepImpl(obj,pas_delta)
            legSptInd = obj.legSptIndOld;
            if pas_delta(1)<-0.06
                legSptInd(1)=1;
            elseif pas_delta(1)>-0.0542*0.6
                legSptInd(1)=0;
            end

            if pas_delta(3)>0.05
                legSptInd(2)=1;
            elseif pas_delta(3)<0.0536*0.6
                legSptInd(2)=0;
            end
            obj.legSptIndOld=legSptInd;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end