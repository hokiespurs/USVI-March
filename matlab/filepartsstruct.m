function [d,f,e] = filepartsstruct(fnames,nameandextension)

d = cell(numel(fnames),1);
f = cell(numel(fnames),1);
e = cell(numel(fnames),1);

for i=1:numel(fnames)
   [d{i},f{i},e{i}] = fileparts(fnames{i});
   if nargin==2
       f{i} = [f{i} e{i}];
   end
end

end