function fv = read_ply2(fileName)

% mesh = read_ply('fileName')
%
% this function reads a ply file (must be in text format)
% 
% to calc. normals etc use calcMeshNormals
%
% Copyright : This code is written by Ajmal Saeed Mian {ajmal@csse.uwa.edu.au}
%              Computer Science, The University of Western Australia. The code
%              may be used, modified and distributed for research purposes with
%              acknowledgement of the author and inclusion this copyright information.
%
% Modified by Vipin Vijayan.

fid = fopen(fileName);
line = fgetl(fid);
line = fgetl(fid);
line = fgetl(fid);
fclose(fid);

if strcmp(line(1:7),'element')
    x = dlmread(fileName, ' ', [2 2 2 2]);
    y = dlmread(fileName, ' ', [6 2 6 2]);
    header = 9;
else
    x = dlmread(fileName, ' ', [3 2 3 2]);
    y = dlmread(fileName, ' ', [7 2 7 2]);
    header = 10;
end

vertex = dlmread(fileName, ' ', [header 0 x+(header-1) 2]);

poly = dlmread(fileName, ' ', [x+header 0 x+(header-1)+y 3]);
poly(:,1) = [];
poly = poly + 1;

fv.vertices = vertex;
fv.faces = poly;
