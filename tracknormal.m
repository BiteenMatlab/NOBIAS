function tracks=tracknormal(tracks)
% tracks are 2 by T
tracks = [(tracks(1,:)-mean(tracks(1,:)))/std(tracks(1,:));...
    (tracks(2,:)-mean(tracks(2,:)))/std(tracks(2,:))];

end