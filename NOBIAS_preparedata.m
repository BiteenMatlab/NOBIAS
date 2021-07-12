function data=NOBIAS_preparedata(AllTracks)
% input All tracks is a N by 1 cell array, where each element of the cell
% array is a tracectories with at least 4 colmns, where the 2nd columns
% should correspond to the frame of the tracks (gaps are allowed and 
% should be pre-filtered in tracking step to avoid too huge gaps), the 3rd
% and 4th columns should be the rows and columns of the 2D tracks
% coordinates, pay attention to x-y and row-col difference.

TrID=[];
All_steps={};
All_corrstep={};
min_length=5;
for i=1:length(AllTracks)
    temptr=AllTracks{i};
    fixedTrack = nan(max(temptr(:,2)),size(temptr,2));
    fixedTrack(temptr(:,2),:) = temptr;
    fixedTrack(1:find(all(isnan(fixedTrack),2)==0,1,'first')-1,:)=[];
    tempstep=fixedTrack(2:end,[4,3])-fixedTrack(1:end-1,[4,3]);
    tempcorrstep=[tempstep(1:end-1,:).*tempstep(2:end,:); nan, nan];
    gapsID=(~isnan(tempstep(:,1)))&(~isnan(tempstep(:,2)));
    tempstep=tempstep(~isnan(tempstep(:,1)),:);
    tempstep=tempstep(~isnan(tempstep(:,2)),:);
    tempcorrstep=tempcorrstep(gapsID,:);
    if size(tempstep,1)>min_length
        All_steps{end+1}=tempstep;
        All_corrstep{end+1}=tempcorrstep;
    end
end
for i=1:length(All_steps)
    TrID=[TrID, ones(1,size(All_steps{i},1))*i];
end
data.obs=cat(1,All_steps{:})';
data.TrID=TrID;
data.obs_corr=cat(1,All_corrstep{:})'; %not needed if motion blur correction not wanted


end