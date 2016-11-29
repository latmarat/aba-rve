
%% Input
% dimensions of the FE mesh (ito elements)
dims = [11 11 11];
% path to the folder with input files
inpDir = 'C:\Users\mlatypov\Documents\_Projects\dp\mks\aba\test-E\';

%% Define FE file names

files2load = cell(4,1);
files2load{1} = sprintf('_%dx%dx%d.mesh', dims);
files2load{2} = '_tensionX-Y-Z.eqn';
files2load{3} = '_dp.mater';
files2load{4} = '_tensionX-Y-Z.load';

xyz = [-0.5:1:(dims(1)-0.5); -0.5:1:(dims(2)-0.5); -0.5:1:(dims(3)-0.5)]';

%% Generate mesh
elem = meshgen(xyz,dims+1,inpDir);  

%% Assign phases

volfr = 0.95;

ph = ones(prod(dims),1);
rind = randperm(prod(dims),ceil(volfr*prod(dims)));
ph(rind) = 2;

% ph = randi(2,prod(dims),1);
% mid = fix(numel(ph)/2+1);
% ph(mid) = 2;

%% Generate inp file with phases
ph2inp([inpDir 'delta.inp'], ph, elem, files2load)