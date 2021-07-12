function HammingD=NOBIAS_HammingD(TrueLabel, stateSeq, Sigma)



used_state=unique(stateSeq);
[~, L_Ranked]=sort(Sigma(1,1,used_state),'ascend');
used_state=used_state(L_Ranked);

SQ=stateSeq;
for i=1:length(used_state)
    SQ(SQ==used_state(i))=i+10;
end
SQ=SQ-10;
HammingD=sum(TrueLabel~=SQ)/size(SQ,2);

end