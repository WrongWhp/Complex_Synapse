function simobj=Simulate(obj,fp,randno)
%simobj=SIMULATE(obj,fp,randno) simulate SynapsePlastSeq from
%SynapseIdModel
%   randno  = matrix(2,n) of random numbers in [0,1]
%               first row controls whether transition is pot/dep
%               second row controls which transition is used
%   fp      =  fraction of transitions that are potentiating

if ismatrix(randno)

    error(CheckValue(randno,@(x) all(all(inrange(x,0,1))),'inrange(0,1)'));
    error(CheckValue(fp,@(x) all(all(inrange(x,0,1))),'inrange(0,1)'));
    error(CheckSize(fp,@(x) length(x)==length(obj.M)-1,'length(fp)==length(obj.M)-1'));

    fp(fp==0)=1e-10;

    simobj=SynapsePlastSeq;
    simobj=simobj.setPotDep(WhichBin([0,cumsum(fp),1],randno(1,:)));
    randno=randno(2,:);

    %change pdf -> cdf
    obj.Initial=cumsum(obj.Initial);
    for i=1:length(obj.M)
        obj.M{i}=cumsum(obj.M{i},2);
    end

    states=zeros(1,size(randno,2));

    % states(1)=WhichBin(Initial,randno(1));
    states(1)=find(obj.Initial>randno(1),1,'first');

    for i=2:length(states)
        states(i)=find(obj.M{simobj.potdep(i-1)}(states(i-1),:)>randno(i),1,'first');
    end

    simobj=simobj.setStateSeq(states);

    wvalInds=obj.GetWValInds;
    simobj=simobj.setReadouts(wvalInds(states)');

    assert(simobj.isvalid,'simobj invalid');
    assert(obj.iscompatible(simobj),'simobj incompatible with modelobj');


else
    if ndims(randno)==3
        simobj=SynapsePlastSeq(1,size(randno,3));
    else
        siz=size(randno);
        simobj=SynapsePlastSeq(siz(3:end));
        randno=reshape(randno,siz(1),siz(2),[]);
    end
    
    for i=1:numel(simobj)
        simobj(i)=obj.Simulate(fp,squeeze(randno(:,:,i)));
    end    

end%if ismatrix

end
