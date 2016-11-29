
%% Input
% dimensions of the FE mesh (ito elements)
dims = [33 33 1];
% path to the folder with input files
inpDir = '';
% vtk file path
vtkFileName = 'C:\Users\mlatypov\Documents\_Projects\dic\dream3d\msOut.vtk';

%% Define FE file names
files2load = cell(4,1);
files2load{1} = sprintf('_%dx%dx%d.mesh', dims);
files2load{2} = '_tensionX.eqn';
files2load{3} = '_dp.mater';
files2load{4} = '_tensionX.load';

step   = zeros(1,3);
boxmin = zeros(1,3);
boxmax = zeros(1,3);

for ii = 1:3
    boxmin(ii) = -0.5;
    boxmax(ii) = dims(ii)-0.5;
    step(ii) = 1;
end

%% Generate mesh
elem = meshgen(boxmin,boxmax,step,dims+1,inpDir);  

%% Get phases from vtk
[ph, dims] = vtk2ph(vtkFileName);

if size(elem,1) ~= size(ph,1)
    fprintf('Error! Mesh and ph are inconsistent \n')
    return
end

%% Generate inp file with phases
ph2inp([inpDir 'ms.inp'], ph, elem, files2load)