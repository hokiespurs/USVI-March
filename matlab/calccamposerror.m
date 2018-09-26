function camposerror = calccamposerror(pstrajectory,trajectory)
    camposerror.Xs = trajectory.Xs;
    camposerror.As = trajectory.As;
    camposerror.Z  = trajectory.Z;
    
    camposerror.dXs = pstrajectory.Xs - trajectory.Xs;
    camposerror.dAs = pstrajectory.As - trajectory.As;
    camposerror.dZ  = pstrajectory.Z - trajectory.Z ;

end
