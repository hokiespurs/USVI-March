clc

SEARCHDIR = 'P:\Slocum\USVI_project\01_DATA\20180319_USVI_UAS_BATHY\02_PROCDATA\06_PROCIMAGES';
[~,dnames] = dirname('*',0,SEARCHDIR);
[~, justnames, ~] = filepartsstruct(dnames);

for i=1:numel(dnames)
    fprintf('%s\n',justnames{i});
    if exist([dnames{i} '/03_IMAGEMARKERS/gcps.xml'],'file')
        gcps = xml2struct([dnames{i} '/03_IMAGEMARKERS/gcps.xml']);
        ngcps = numel(gcps.document.chunk.markers.marker);
        labels = '';
        isenabled = '';
        if ngcps>1
            for j=1:ngcps
                markerstr = gcps.document.chunk.markers.marker{j}.Attributes.label;
                markerenabled = gcps.document.chunk.markers.marker{j}.reference.Attributes.enabled;
                labels = [labels sprintf(' | %8s',markerstr)];
                isenabled = [isenabled sprintf(' | %8s',markerenabled)];
            end
        else
            markerstr = gcps.document.chunk.markers.marker.Attributes.label;
            markerenabled = gcps.document.chunk.markers.marker.reference.Attributes.enabled;
            labels = [labels sprintf(' | %8s',markerstr)];
            isenabled = [isenabled sprintf(' | %8s',markerenabled)];
        end
        fprintf(labels);
        fprintf('\n');
        fprintf(isenabled);
        fprintf('\n');
    else
       fprintf('No Markers\n'); 
    end
    fprintf('\n');
end