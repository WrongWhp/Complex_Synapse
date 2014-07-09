function [ newWp,newWm,snr,ef ] = ModelOpt( Wp,Wm,tm,varargin)
%[newWp,newWm,snr,ef]=MODELOPT(Wp,Wm,tm) run gradient descent on model to
%maximise snr(t)
%   TM = time value
%   WP = potentiation transition rates
%   WM = depression transition rates
%   snr= snr at T
%   ef = exit flag

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='ModelOpt';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addParameter('UseDerivs',false,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOpt','UseDerivs'));
    p.addParameter('DispExit',false,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOpt','DispExit'));
    p.addParameter('TolFun',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOpt','TolFun'));
    p.addParameter('TolX',1e-10,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOpt','TolFun'));
    p.addParameter('TolCon',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOpt','TolFun'));
    p.addParameter('MaxIter',1000,@(x) validateattributes(x,{'numeric'},{'scalar','integer'},'ModelOpt','TolFun'));
    p.addParameter('Algorithm','interior-point',@(x) validatestring(x,{'trust-region-reflective','active-set','interior-point','sqp'},'ModelOpt','TolFun'));
    p.addParameter('Display','off',@(x) validatestring(x,{'off','iter','iter-detailed','notify','notify-detailed','final','final-detailed'},'ModelOpt','TolFun'));
end
p.parse(varargin{:});
r=p.Results;

n=length(Wp);
w=BinaryWeights(n);

[A,b]=ParamsConstraints(n);

x0 = Mats2Params(Wp,Wm);            % Starting guess 
options = optimset(p.Unmatched,'Algorithm',r.Algorithm,'Display',r.Display,...
    'TolFun', r.TolFun,...  % termination based on function value (of the derivative)
    'TolX', r.TolX,...
    'TolCon',r.TolCon,...
    'MaxIter',r.MaxIter, ...
    'largescale', 'on');

if r.UseDerivs
    options = optimset(options,'GradObj','on');
    [x,snr,ef] = fmincon(@(y)OptFunGrad(y,tm,0.5,w),x0,A,b,...
         [],[],[],[],[],... 
       options);
else
    [x,snr,ef] = fmincon(@(y)OptFun(y,tm,0.5,w),x0,A,b,...
         [],[],[],[],[],... 
       options);
end
[Wp,Wm]=Params2Mats(x);
snr=-snr;

% [~,~,ix]=SortByEta(0.5*Wp+0.5*Wm,w);
[~,~,ix]=SortByWt(0.5*Wp+0.5*Wm,w,tm);
newWp=Wp(ix,ix);
newWm=Wm(ix,ix);

if r.DispExit
    disp(ExitFlagMsg(ef));
end


end

