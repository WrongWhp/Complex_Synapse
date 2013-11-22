function [ Wp,Wm,A ] = FindOptL( sm,n,reps,varargin )
%[Wp,Wm]=FINDOPT(sm,n,reps) Find synapse model that maximises SNR(t)
%   t    = time value
%   n    = #states
%   reps = number of attempts we max over
%   Wp = potentiation transition rates
%   Wm = depression transition rates
%   A  = Laplace Transf value

existsAndDefault('reps',1);

if reps==1

    InitRand=true;
    % Triangular=false;
    varargin=assignApplicable(varargin);

    if InitRand
    %     if Triangular
    %         W=RandTrans(n);
    %         w=BinaryWeights(n);
    %         [Wp,Wm]=TriangleDcmp(W,0.5,w,sm);
    %         Wp=Stochastify(Wp+eye(n));
    %         Wm=Stochastify(Wm+eye(n));
    %     else
            Wp=RandTrans(n);
            Wm=RandTrans(n);
    %     end
    else
    %    [Wp,Wm]=MakeSMS(ones(1,n-1));
         [Wp,Wm]=DiffJump(n);
    end

    try
    %     [Wp,Wm] = ModelOpt( Wp,Wm,t,varargin{:});
        [Wp,Wm,A] = ModelOptL( Wp,Wm,sm,varargin{:});
    catch ME
        A=SNRlaplace(s,Wp,Wm,fp,w);
        disp(ME.message);
        disp(['In function: ' ME.stack(1).name ' at line ' int2str(ME.stack(1).line) ' of ' ME.stack(1).file]);
        return;
    end
    
else
    
    DispReps=false;
    varargin=assignApplicable(varargin);
    Wp=[];
    Wm=[];
    A=0;
    for i=1:reps
        [ Wpt,Wmt,At ] = FindOptL( sm,n,1,varargin{:} );
        if At>A
            Wp=Wpt;
            Wm=Wmt;
            A=At;
        end
        if DispReps
            disp([int2str(i) '/' int2str(reps)]);
        end
    end
    
end

end
