function isbad = findbadinds(x)
isbad = false;

if numel(x)<10
    isbad=true;
elseif ~strcmp(x([7:9]),'257')
    isbad=true;
end


end