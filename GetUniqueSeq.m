function [nonrepseq , SeqLen]= GetUniqueSeq(seq, trID)

% get the track segments with the same diffusive states
TrNum=length(unique(trID));
nonrepseq=cell(TrNum,1);
SeqLen=cell(TrNum,1);
for i=1:TrNum
    tempseq=seq(trID==i);
indicator = [1,diff(tempseq)];
indicator = indicator~=0;
nonrepseq{i} = tempseq(indicator)';
SeqLen{i} = diff([find(indicator), length(tempseq)+1])';
end
nonrepseq=cat(1,nonrepseq{:})';
SeqLen=cat(1,SeqLen{:})';
end 