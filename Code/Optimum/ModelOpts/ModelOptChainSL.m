function [ newqv,A,ef ] = ModelOptChainSL( qv,sm,varargin)
%[newqv,A,ef]=MODELOPTCHAINL(qv,sm) run gradient descent on model to
%maximise A(s)
%   sm = Laplace param value
%   qv = nearest neighbour transition rates
%   A  = Laplace Transf value
%   ef = exit flag

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='ModelOptChainL';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addParameter('UseDerivs',true,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOptChainL','UseDerivs'));
    p.addParameter('DispExit',false,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOptChainL','DispExit'));
    p.addParameter('TolFun',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainL','TolFun'));
    p.addParameter('TolX',1e-10,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainL','TolFun'));
    p.addParameter('TolCon',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainL','TolFun'));
    p.addParameter('MaxIter',1000,@(x) validateattributes(x,{'numeric'},{'scalar','integer'},'ModelOptChainL','TolFun'));
    p.addParameter('Algorithm','interior-point',@(x) validatestring(x,{'trust-region-reflective','active-set','interior-point','sqp'},'ModelOptChainL','TolFun'));
    p.addParameter('Display','off',@(x) validatestring(x,{'off','iter','iter-detailed','notify','notify-detailed','final','final-detailed'},'ModelOptChainL','TolFun'));
end
p.parse(varargin{:});
r=p.Results;

qmin=zeros(size(qv));
qmax=ones(size(qv));

options = optimset(p.Unmatched,'Algorithm',r.Algorithm,'Display',r.Display,...
    'TolFun', r.TolFun,...  % termination based on function value (of the derivative)
    'TolX', r.TolX,...
    'TolCon',r.TolCon,...
    'MaxIter',r.MaxIter, ...
    'largescale', 'on');

if r.UseDerivs
    options = optimset(options,'GradObj','on');
    [newqv,A,ef] = fmincon(@(y)OptFunGradChainSL(y,sm),qv,...
        [],[],[],[],qmin,qmax,[],... 
        options);
else
    [newqv,A,ef] = fmincon(@(y)OptFunChainSL(y,sm),qv,...
        [],[],[],[],qmin,qmax,[],... 
        options);
end
A=-A;

if r.DispExit
    disp(ExitFlagMsg(ef));
end

end
