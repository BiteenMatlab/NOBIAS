function state_model=predict_state_model(out,data,net, minseglength)

[Tempnonrepseq , TempSeqLen]= GetUniqueSeq(out.stateSeq, data.TrID);%ones(length(out.stateSeq),1));%data.TrID);
Mark=[0, cumsum(TempSeqLen)];

long_seq_label=[];
long_seq_lenth=[];
long_track={};
for k=1:length(Tempnonrepseq)
    if TempSeqLen(k)>minseglength
        long_track{end+1}=tracknormal(cumsum(data.obs(:,Mark(k)+1:Mark(k+1)),2));
        long_seq_label(end+1)=Tempnonrepseq(k);
        long_seq_lenth(end+1)=TempSeqLen(k);
    end
end

state_model.model= predict(net,long_track,'MiniBatchSize',1);
state_model.state=long_seq_label;
state_model.length=long_seq_lenth;
end
function tracks=tracknormal(tracks)
% tracks are 2 by T
tracks = [(tracks(1,:)-mean(tracks(1,:)))/std(tracks(1,:));...
    (tracks(2,:)-mean(tracks(2,:)))/std(tracks(2,:))];

end