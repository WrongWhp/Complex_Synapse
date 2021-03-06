function [ Wp,Wm,snr ] = FindOpt( t,n,varargin )
%[Wp,Wm]=FINDOPT(t,n,reps) Find synapse model that maximises SNR(t)
%   t    = time value
%   n    = #states
%   reps = number of attempts we max over
%   Wp = potentiation transition rates
%   Wm = depression transition rates

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='FindOpt';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addOptional('reps',1,@(x)validateattributes(x,{'numeric'},{'scalar'},'FindOpt','reps',3));
    p.addParameter('InitRand',true,@(x) validateattributes(x,{'logical'},{'scalar'},'FindOpt','InitRand'));
    p.addParameter('Triangular',false,@(x) validateattributes(x,{'logical'},{'scalar'},'FindOpt','InitRand'));
    p.addParameter('DispReps',false,@(x) validateattributes(x,{'logical'},{'scalar'},'FindOpt','InitRand'));
end
p.parse(varargin{:});
r=p.Results;

if r.reps==1

    w=BinaryWeights(n);

    if r.InitRand
        if r.Triangular
            W=RandTrans(n);
            [Wp,Wm]=TriangleDcmp(W,0.5,w,t);
            Wp=Stochastify(Wp+eye(n));
            Wm=Stochastify(Wm+eye(n));
        else
            Wp=RandTrans(n);
            Wm=RandTrans(n);
        end
    else
    %    [Wp,Wm]=MakeSMS(ones(1,n-1));
         [Wp,Wm]=DiffJump(n);
    end

    try
        [Wp,Wm,snr] = ModelOpt( Wp,Wm,t,p.Unmatched);
    %     [Wp,Wm,snr] = GradientModelOpt( Wp,Wm,t,varargin{:});
    catch ME
        snr=SNRcurve(t,Wp,Wm,0.5,w,'UseExpM',true);
        disp(ME.message);
        disp(['In function: ' ME.stack(1).name ' at line ' int2str(ME.stack(1).line) ' of ' ME.stack(1).file]);
        return;
    end

else
    
    warning('off','MATLAB:nearlySingularMatrix');
    Wp=[];
    Wm=[];
    snr=0;
    for i=1:r.reps
        if r.DispReps
            DispCounter(i,r.reps,'rep: ');
        end
        [ Wpt,Wmt,St ] = FindOpt( t,n,1, p.Unmatched,'InitRand',r.InitRand,'Triangular',r.Triangular );
        if St>snr
            Wp=Wpt;
            Wm=Wmt;
            snr=St;
        end
    end
        if r.DispReps
            DispCounter(r.reps+1,r.reps,'rep: ');
        end
        
    warning('on','MATLAB:nearlySingularMatrix');
end

end