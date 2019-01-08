function plotCameraPyramid(K,R,C,pix,varargin)
% PLOTCAMERAPYRAMID Short summary of this function goes here
%   Detailed explanation goes here
%
% Required Inputs: (default)
%	- K          : *description* 
%	- R          : *description* 
%	- C          : *description* 
%	- pix        : *description* 
% Optional Inputs: (default)
%	- 's'        : (1) *description* 
%	- 'optLine'  : ('a') *description* 
%	- 'optPatch' : ('b') *description* 

% Outputs:
%   - [enter any outputs here] 
% 
% Examples:
%   - [enter any example code here]
% 
% Dependencies:
%   - [unknown]
% 
% Toolboxes Required:
%   - [unknown]
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-Feb-2018
% Date Modified : 20-Feb-2018
% Github        : [enter github web address]

K = [5000 0 2000;0 5000 1500;0 0 1];
R = [1 0 0;0 1 0; 0 0 -1];
C = [0 0 20];
pix = [4000 3000];
s = .2;
varargin = {'color','r','linewidth',3};

%% Function Call
[K,R,C,pix,s,optLine,optPatch] = parseInputs(K,R,C,pix,varargin{:});

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
figure(1);clf;
plot3(xplot,yplot,zplot,optLine{:});
hold on
patch(xpatch,ypatch,zpatch,optPatch{:})

end

function [K,R,C,pix,s,optLine,optPatch] = parseInputs(K,R,C,pix,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_s         = 1;
default_optLine   = {'linewidth',3,'color','k'};
default_optPatch  = {'color','b','faceAlpha',0.5};

% Check Values
check_K         = @(x) size(x,1)==3 & size(x,2)==3;
check_R         = @(x) size(x,1)==3 & size(x,2)==3;
check_C         = @(x) numel(x)==3;
check_pix       = @(x) numel(x)==2;
check_s         = @(x) isscalar(x);
check_optLine   = @(x) iscell(x);
check_optPatch  = @(x) iscell(x);

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
end
