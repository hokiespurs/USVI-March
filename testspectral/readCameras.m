function cameras = readCameras(fname)
rawdata = importdata(fname);
cameras=[];
for i=1:size(rawdata.data,1)
    cameras.name{i} = rawdata.textdata(2+i,1);
    cameras.E(i) = rawdata.data(i,1);
    cameras.N(i) = rawdata.data(i,2);
    cameras.Z(i) = rawdata.data(i,3);
    R = reshape(rawdata.data(i,7:end),3,3)';
    cameras.R{i} = diag([1, -1, -1]) * R;
end

end