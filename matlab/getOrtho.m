function ortho = getOrtho(fname)

[pt,AsAz,orthoname]=getUSVIXsAsCoords(fname);

[ortho.orthoRGB, basemap_geo] = geotiffread(orthoname);
ortho.orthoGray = rgb2gray(ortho.orthoRGB(:,:,1:3));

ortho.orthoX = basemap_geo.XWorldLimits;
ortho.orthoY = basemap_geo.YWorldLimits;

%% Remap to Xs/As

end