function [ tf ] = isvalid( obj )
%tf=ISVALID(obj) are all matrices of appropriate size and integers?

tf=isvalid@SynapsePlastSeq(obj) &&...
    isvector([obj.stateseq]) &&...
    all(isint([obj.stateseq])) &&...
    min([obj.stateseq])>0 &&...
    length([obj.stateseq])==length([obj.readouts]);



end
