function trajectory = trimTrajectory(trajectoryAll,pstrajectory)

trajectory = [];
for i=1:numel(pstrajectory.E)
    ind = strcmp(trajectoryAll.name,pstrajectory.name{i});
    
    trajectory.name{i} = pstrajectory.name{i};
    
    trajectory.E(i) = trajectoryAll.E(ind);
    trajectory.N(i) = trajectoryAll.N(ind);
    trajectory.Z(i) = trajectoryAll.Z(ind);
    
end


end