function [ KTp,KTm ] = KTmults( tm,Wp,Wm,fp,w )
%[KTp,KTm]=KTMULTS(tm,Wp,Wm,fp,w) Kuhn-Tucker multipliers for maximisation
%of SNR(t) wrt elements of Wp,Wm
%   tm = time value
%   Wp = potentiation transition rates
%   Wm = depression transition rates
%   fp = Fraction of potentiation transitions
%   w = Weights of states (+/-1)

error(CheckSize(tm,@isscalar));
error(CheckSize(Wp,@ismat));%matrix
error(CheckSize(Wp,@issquare));%square
error(CheckSize(Wm,@(x)samesize(Wp,x),'samesize(Wp)'));%also square matrix of same size
error(CheckSize(fp,@isscalar));
error(CheckValue(fp,@(x) inrange(x,0,1),'inrange(0,1)'));%fp in [0,1]
error(CheckSize(w,@iscol));
error(CheckValue(w,@(x) all(x.^2==1),'all w = +/-1'));


[~,dSdWp,dSdWm]=GradSNR(tm,Wp,Wm,fp,w);

KTdiag=diag(dSdWp,1);
KTp=[KTdiag;0]*ones(1,length(Wp))-dSdWp;

KTdiag=diag(dSdWm,-1);
KTm=[0;KTdiag]*ones(1,length(Wp))-dSdWm;


end

