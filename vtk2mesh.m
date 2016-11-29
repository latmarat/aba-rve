function [xyz, ph, dims] = vtk2mesh(vtkFileName)

fid = fopen(vtkFileName);            % Open file
rawData = textscan(fid, '%s', '\n'); % Get all lines
fclose(fid);                         % Close file
rawData = rawData{1};                % First level is 1x1 cell

% helper function 
getStrPos = @(data,myStr) find(~cellfun('isempty', strfind(data, myStr)));

%% find dimensions of the image
pos = getStrPos(rawData,'DIMENSIONS');
dims = zeros(3,1);
for ii = 1:3
    dims(ii) = str2double(rawData(pos + ii));
end

%% get node coordinates
ctrLines = {'X_COORDINATES','Y_COORDINATES','Z_COORDINATES','CELL_DATA'};
if all(dims == dims(1))
    xyz = zeros(dims(1),3);
    for ii=1:3
        pos1 = getStrPos(rawData,ctrLines{ii});
        pos2 = getStrPos(rawData,ctrLines{ii+1});
        xyz(:,ii) = str2double(rawData(pos1+3:pos2-1));
    end
end

%% get size of the data 
pos = getStrPos(rawData,'CELL_DATA');
dataSize = str2double(rawData(pos + 1));

%% read phase IDs
pos = getStrPos(rawData,'Phases');
ph = str2double(rawData((pos+5):(pos+5+dataSize-1)));

end

% posScal = getStrPos(rawData,'SCALARS');
% 
% numScalarVars = numel(posScal);
% varData = zeros(dataSize,numScalarVars);
% for ii = 1:numScalarVars
%     varName{ii} = rawData(posScal(ii)+1);
%     varData(:,ii) = str2double(rawData((posScal(ii)+6):(posScal(ii)+6+dataSize-1)));
% end