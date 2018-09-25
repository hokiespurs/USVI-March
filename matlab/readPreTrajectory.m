function traj = readPreTrajectory(fname)

dat = importdata(fname);
traj.name = dat.textdata(2:end,1);
traj.E = dat.data(:,3);
traj.N = dat.data(:,4);
traj.Z = dat.data(:,5);
traj.stdX = dat.data(:,6);
traj.stdY = dat.data(:,7);
traj.stdZ = dat.data(:,8);

end