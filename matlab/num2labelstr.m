function xstr = num2labelstr(x,str)
% convert number to a nice string for a label
xstr = cell(numel(x),1);
for i=1:numel(x)
    xstr{i} = sprintf(str,x(i));
end

end