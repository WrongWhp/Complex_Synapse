function [ hs ] = PlotDoubleEnv( t1,t2,S2,n,varargin )
%hs=PLOTDOUBLEENV(t1,t2,S2,n,hs) Plot Two-time envelope
%   t1 = time of maximisation
%   t2 = time of fixed SNR
%   S2 = SNR(t2)
%   n = # states
%   hs = handle struct, fields:
%       fh      = figure
%       ax_???  = axes for plot
%       ph_???  = plot handle
%       ??_snr  = envelopes
%       ??_exp  = # of exponentials for optimal curve
%       ??_conX = is constraint X active? (X=1,2)
%
%   Constraints:
%       1: sum_a c_a q_a < 1
%       2: sum_a c_a     < n-1
%       3: c_a sqrt(q_a) < gamma

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='PlotDoubleEnv';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addRequired('t1',@(x)validateattributes(x,{'numeric'},{'row','positive'},'PlotDoubleEnv','t1',1));
    p.addRequired('t2',@(x)validateattributes(x,{'numeric'},{'scalar','positive'},'PlotDoubleEnv','t2',2));
    p.addRequired('S2',@(x)validateattributes(x,{'numeric'},{'scalar','positive'},'PlotDoubleEnv','S2',3));
    p.addRequired('n',@(x)validateattributes(x,{'numeric'},{'scalar','positive'},'PlotDoubleEnv','n',4));
    p.addOptional('hs',[],@(x) validateattributes(x,{'numeric','struct'},{'scalar'},'PlotDoubleEnv','hs'));
    p.addParameter('Constraint3',false,@(x) validateattributes(x,{'logical'},{'scalar'},'PlotDoubleEnv','Constraint3'));
    p.addParameter('FontSize',16,@(x) validateattributes(x,{'numeric'},{'scalar'},'PlotDoubleEnv','FontSize'));
end
p.parse(t1,t2,S2,n,varargin{:});
r=p.Results;

t1=r.t1;
hs=r.hs;


if isempty(hs)
    hs.fh=figure('Units','normalized','WindowStyle','docked');
    hs.ax_snr=axes('Parent',hs.fh,'OuterPosition',[0,0.5,1,0.5]);
    hs.ax_exp=axes('Parent',hs.fh,'OuterPosition',AxPos(1));
    hs.ax_con1=axes('Parent',hs.fh,'OuterPosition',AxPos(2));
    hs.ax_con2=axes('Parent',hs.fh,'OuterPosition',AxPos(3));
    if r.Constraint3
        hs.ax_con3=axes('Parent',hs.fh,'OuterPosition',Axpos(4));
    end
end

cla(hs.ax_snr);cla(hs.ax_exp);cla(hs.ax_con1);cla(hs.ax_con2);

S1=zeros(size(t1));
numexp=S1;
cons=zeros(2+r.Constraint3,length(t1));

for i=1:length(t1)
    [S1(i),whichcase,numexp(i)]=DoubleEnv(t1(i),r.t2,r.S2,r.n,'Constraint3',r.Constraint3,p.Unmatched);
    cons(:,i)=BinVec(whichcase,2,2+r.Constraint3)';
end

S1(S1==0)=NaN;
valid=~isnan(S1);

xl=[t1(1) t1(end)];

[hs.envh,yl]=PlotEnvs(t1,n,'Parent',hs.ax_snr,'Format',false);
hs.ph_snr=plot(t1(valid),S1(valid),'b',r.t2,r.S2,'r+','LineWidth',1.5,'Parent',hs.ax_snr);
xlabel(hs.ax_snr,'Time','FontSize',r.FontSize);
ylabel(hs.ax_snr,'SNR','FontSize',r.FontSize);
ylim(hs.ax_snr,yl);
xlim(hs.ax_snr,xl);
set(hs.ax_snr,'XScale','log','YScale','log');

hs.ph_exp=area(t1(valid),numexp(valid),'Parent',hs.ax_exp);
ylabel(hs.ax_exp,'#exp','FontSize',r.FontSize);
xlim(hs.ax_exp,xl);
set(hs.ax_exp,'XScale','log');

hs.ph_con1=area(t1(valid),cons(1,(valid)),'Parent',hs.ax_con1);
ylabel(hs.ax_con1,'Initial','FontSize',r.FontSize);
xlim(hs.ax_con1,xl);
set(hs.ax_con1,'XScale','log');

hs.ph_con2=area(t1(valid),cons(2,(valid)),'Parent',hs.ax_con2);
ylabel(hs.ax_con2,'Area','FontSize',r.FontSize);
xlim(hs.ax_con2,xl);
set(hs.ax_con2,'XScale','log');

if r.Constraint3
    hs.ph_con3=area(t1,cons(3,(valid)),'Parent',hs.ax_con2);
    ylabel(hs.ax_con3,'Mode','FontSize',r.FontSize);
    xlim(hs.ax_con3,xl);
    set(hs.ax_con3,'XScale','log');
end

    function axpos=AxPos(n)
        numax=3+r.Constraint3;
        axpos=[0,0.5*(numax-n)/numax,1,0.5/numax];
    end


end

