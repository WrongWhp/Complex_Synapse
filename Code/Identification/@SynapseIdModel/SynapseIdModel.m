classdef SynapseIdModel
    %SYNAPSEIDMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess=protected)%data
        %prob dist of iniitial state, row vec. default: [0.5 0.5]
        Initial=[0.5 0.5];
        %cell of Markov matrices. default: {Mpot,Mdep} 
        M={[1 0; 0 1], [1 0; 0 1]};
        %synaptic weights. default: [-1; 1]
        w=[-1; 1];
        %cell of diagonal matrices for each possible value of
        %output(low to high), with elements equal to prob of output
        outProj={[1 0; 0 0],[0 0; 0 1]};
    end
    
    methods %setting data
        %
        function newobj=setInitial(obj,newInitial)
            newobj=obj;
            newobj.Initial=newInitial;
        end            
        %
        function newobj=setM(obj,newM)
            newobj=obj;
            newobj.M=newM;
        end
        %
        function newobj=setW(obj,newW)
            newobj=obj;
            newobj.w=newW;
            newobj=newobj.CalcOutProj;
        end            
        %
        function newobj=setOutProj(obj,newOutProj)
            newobj=obj;
            newobj.outProj=newOutProj;
        end
    end
    
    methods%validity etc.
        newobj=Normalise(obj)
        newobj=Zero(obj)
        [newobj,ix]=Sort(obj,fp)
        tf=isvalid(obj)
        tf=iscompatible(obj,simulationobj)
    end
    
    methods %size info
        %
        function val=NumStates(obj)
            val=length(obj.Initial);
        end
        %
        function val=NumPlast(obj)
            val=length(obj.M);
        end
        %
        function val=NumWvals(obj)
            val=length(obj.outProj);
        end
        %
        tf=SameSizes(obj,otherobj)
    end
    
    methods%calculations etc.
        [initdiv,Mdivs]=KLdivs(obj1,obj2)
        obj3=plus(obj1,obj2)
        obj3=mtimes(obj1,obj2)
        obj3=mrdivide(obj1,obj2)
    end
    
    methods%for simulations
        wvals=GetWVals(obj)
        wvalinds=GetWValInds(obj)
        simobj=Simulate(obj,fp,randno)
        imh=image(obj,axInitial,axM,varargin)
    end
    
    methods%for calculation of properties
        %called when changing w
        obj=CalcOutProj(obj)
        %set Initial to eq dist
        newobj=CalcEqProb(obj,fp)
    end%methods
    
    methods (Static=true) %for construction
        newobj=Build(func,fp,varargin)
        newobj=Rand(w,varargin)
    end
    
    methods (Access=private)%for constructiuon
        %called by constructor
        copy=CopyProps(original,copy)
        [s,x] = assignToObject(s, x)
    end%methods
    
    methods%constructor
        function obj=SynapseIdModel(varargin)
            if nargin ~=0%false -> default constructor does nothing
                if nargin==2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
                    %true -> preallocate with default constructor doing nothing
                    obj(max(varargin{1},1),max(varargin{2},1))=SynapseIdModel;
                    if varargin{1}<1
                        obj(1,:)=[];
                    end
                    if varargin{2}<1
                        obj(:,1)=[];
                    end
                else
                    %
                    %default parameters:
                    %if we're copying another obj
                    [tempobj,varargin]=extractArgOfType(varargin,'SynapseIdModel');
                    %otherwise
                    if isempty(tempobj)
                        tempobj=obj;
                    end
                    %
                    %Set size of object:
                    %
                    if nargin>=2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
                        obj(varargin{1},varargin{2})=SynapseIdModel;
                    end%if nargin>=2
                    %
                    %set parameter values:
                    [tempobj,varargin]=assignToObject(tempobj,varargin);
                    obj=CopyProps(tempobj,obj);
                    %
                    %Extract data:
                    %
                end% if nargin=2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
            end%if nargin ~=0
        end%function SynapseIdModel
    end%methods constructor
    
end
