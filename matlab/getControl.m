function [controldata,lidarcontrol] = getControl(justname)

[pt,AsAz,~,controlnames, lidarbiasz]=getUSVIXsAsCoords(justname);

if ~isempty(controlnames.kayakname)
    kayak = readControlData(controlnames.kayakname);
else
    kayak.e=[];
    kayak.n=[];
    kayak.ellip=[];
end

if ~isempty(controlnames.kayakname)
    ts = readControlData(controlnames.tsname,controlnames.tsignore);
else
    ts.e=[];
    ts.n=[];
    ts.ellip=[];
end

if ~isempty(controlnames.lidarname)
    lidarcontrol = readLAS(controlnames.lidarname);
    [lidarcontrol.Xs,lidarcontrol.As] = calcXsAs(lidarcontrol.E,lidarcontrol.N,pt,AsAz);
    lidarcontrol.Z = lidarcontrol.Z - lidarbiasz;
else
    lidarcontrol = [];
end

controldata.iskayak = logical([ones(size(kayak.e)) zeros(size(ts.n))]);
controldata.E = [kayak.e ts.e];
controldata.N = [kayak.n ts.n];
controldata.Z = [kayak.ellip ts.ellip];

[controldata.Xs,controldata.As] = calcXsAs(controldata.E,controldata.N,pt,AsAz);

end