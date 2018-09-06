function plotCameraPyramid(K,R,C,pix,varargin)
% PLOTCAMERAPYRAMID Plots a pyramid to visualize a camera in world coords
%   A camera pyramid visualization can help debug photogrammetry problems.
%   The focal length and IO determine the shape of the pyramid, and the
%   user can optionally input different settings to make it more visually
%   appealing.  
%
% Required Inputs: (default)
%	- K          : Camera K Matrix (IO)
%	- R          : Camera Rotation Matrix 
%	- C          : Camera Position Vector (X,Y,Z) 
%	- pix        : Pixel Dimensions of Camera (x,y) 
% Optional Inputs: (default)
%	- 's'        : (1) scale of the triangle (camera z dimension) 
%	- 'optLine'  : ({'linewidth',3,'color','k'}) additional plot inputs
%	- 'optPatch' : ({'facecolor','b','faceAlpha',0.5}) more patch inputs 
%	- 'optSides' : ({}) more patch inputs for side of pyramid
%
% Outputs:
%   - n/a 
% 
% Examples:
%     K = [5000 0 2000;0 5000 1500;0 0 1];
%     R = [1 0 0;0 1 0; 0 0 -1];
%     C = [0 0 20];
%     pix = [4000 3000];
%     optLine = {'linewidth',3,'color','k'};
%     optPatch = {'facecolor','b','faceAlpha',0.5};
%     plotCameraPyramid(K,R,C,pix,'s',0.5,'optLine',optLine,'optPatch',optPatch)
% 
% Dependencies:
%   - uvs2xyz.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-Feb-2018
% Date Modified : 20-Feb-2018
% Github        : 


%% Function Call
[K,R,C,pix,s,optLine,optPatch,optSides] = parseInputs(K,R,C,pix,varargin{:});

%% Pixel Coordinates to use for each

upix = [1, pix(1), pix(1)/2,      1, pix(1)];
vpix = [1, 1     , pix(2)/2, pix(2), pix(2)];  
sval = [s, s, 0, s, s];

%% Get Plot Coordinates for Lines
plotinds = [1 2 3 1 4 3 5 2 5 4];

uplot = upix(plotinds);
vplot = vpix(plotinds);
splot = sval(plotinds);

[xplot,yplot,zplot]=uvs2xyz(K,R,C,uplot,vplot,splot);
%% Get Patch Coordinates for Image Rectangle
patchinds = [1 2 5 4]';

upatch = upix(patchinds);
vpatch = vpix(patchinds);
spatch = sval(patchinds);

[xpatch,ypatch,zpatch]=uvs2xyz(K,R,C,upatch,vpatch,spatch);



%% Plot Camera
% plot lines around edge of pyramid
plot3(xplot,yplot,zplot,optLine{:});
hold on
% plot patch for base of pyramid
patch(xpatch,ypatch,zpatch,'b',optPatch{:})
% plot patch for edges of pyramid
if ~isempty(optSides)
    patchSide = [1 2 3;2 5 3;5 4 3;1 3 4];

    for i=1:4
        upatchside = upix(patchSide(i,:));
        vpatchside = vpix(patchSide(i,:));
        spatchside = sval(patchSide(i,:));

        [xpatch,ypatch,zpatch]=uvs2xyz(K,R,C,upatchside,vpatchside,spatchside);
        patch(xpatch,ypatch,zpatch,'b',optSides{:})
    end
end
drawnow
end

function [K,R,C,pix,s,optLine,optPatch,optSides] = parseInputs(K,R,C,pix,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_s         = 1;
default_optLine   = {'linewidth',3,'color','k'};
default_optPatch  = {'facecolor','b','faceAlpha',0.5};
default_optSides  = {};

% Check Values
check_K         = @(x) size(x,1)==3 & size(x,2)==3;
check_R         = @(x) size(x,1)==3 & size(x,2)==3;
check_C         = @(x) numel(x)==3;
check_pix       = @(x) numel(x)==2;
check_s         = @(x) isscalar(x);
check_optLine   = @(x) iscell(x);
check_optPatch  = @(x) iscell(x);
check_optSides  = @(x) iscell(x);

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'K'   , check_K   );
addRequired(p, 'R'   , check_R   );
addRequired(p, 'C'   , check_C   );
addRequired(p, 'pix' , check_pix );
% Parameter Arguments
addParameter(p, 's'        , default_s       , check_s        );
addParameter(p, 'optLine'  , default_optLine , check_optLine  );
addParameter(p, 'optPatch' , default_optPatch, check_optPatch );
addParameter(p, 'optSides' , default_optSides, check_optSides );

% Parse
parse(p,K,R,C,pix,varargin{:});
% Convert to variables
K        = p.Results.('K');
R        = p.Results.('R');
C        = p.Results.('C');
pix      = p.Results.('pix');
s        = p.Results.('s');
optLine  = p.Results.('optLine');
optPatch = p.Results.('optPatch');
optSides = p.Results.('optSides');
end
