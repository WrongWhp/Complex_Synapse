function [ Wp,Wm,w ] = PooledBuilder( n,q )
%POOLEDBUILDER Summary of this function goes here
%   Detailed explanation goes here

    w=(-1:2/(n-1):1)';
    if diff(q)~=0
        qq=(q(1):(diff(q)/(n-2)):q(2)).*(n-1:-1:1)/(n-1);
    else
        qq=q(1)*(n-1:-1:1)/(n-1);
    end

    [Wp,Wm]=MakeSMS(qq);


end
