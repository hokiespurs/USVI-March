function controldata = getControl(justname)

[pt,AsAz,~,controlnames]=getUSVIXsAsCoords(justname);

kayak = readControlData(controlnames.kayakname);
ts = readControlData(controlnames.tsname,controlnames.tsignore);

controldata.iskayak = logical([ones(size(kayak.e)) zeros(size(ts.n))]);
controldata.E = [kayak.e ts.e];
controldata.N = [kayak.n ts.n];
controldata.Z = [kayak.ellip ts.ellip];

[controldata.Xs,controldata.As] = calcXsAs(controldata.E,controldata.N,pt,AsAz);

end