function laspts = readLAS(pcname)

rawlasdata = LASread(pcname, false, false);

laspts.E = rawlasdata.record.x;
laspts.N = rawlasdata.record.y;
laspts.Z = rawlasdata.record.z;

try
    laspts.R = uint8(rawlasdata.record.red/255);
    laspts.G = uint8(rawlasdata.record.green/255);
    laspts.B = uint8(rawlasdata.record.blue/255);
catch
   laspts.R = zeros(size(laspts.E),'uint8');
   laspts.G = zeros(size(laspts.E),'uint8');
   laspts.B = zeros(size(laspts.E),'uint8');
end

end