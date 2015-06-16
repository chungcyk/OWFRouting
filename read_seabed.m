% ================================================================
% Optimal wind farm layout, with the main emphasis on optimal cabling
% Michael Yat Kit Chung ykc111
% June 2015
% 
% read_seabed.m
% Reads in the seabed data in column form from a text file. 'X Y Z'
% ================================================================

% fileID = fopen('seabed_data.txt','r');
% 
% formatSpec = '%f %f %f';
% sizeA = [3 Inf];
% 
% seabed_grid = fscanf(fileID,formatSpec,sizeA);
% fclose(fileID);

% For 2D testing only
addpath('test_data');
load humps_big.mat
seabed_grid = flatseabed;
seaX = seabed_grid(:,1);
seaY = seabed_grid(:,2);
seaZ = seabed_grid(:,3);
% 

% seaX = seabed_grid(1,:)';
% seaY = seabed_grid(2,:)';
% seaZ = seabed_grid(3,:)';

% Tidy Up
clear fileID;
clear formatSpec;
clear sizeA;

% geodesic
    global geodesic_library;                
    geodesic_library = 'geodesic_debug';      %"release" is faster and "debug" does additional checks
    rand('state', 0);  

    clear vertices;
    vertices(:,1) = seaX';
    vertices(:,2) = seaY';
    vertices(:,3) = seaZ';
    faces = delaunay(seaX',seaY');

%% Read in turbine location data
display('Reading turbine location data');
load test_16.mat
% load test50grid.mat

%% Compile the location data into points
display('Mapping turbine coordinates to seabed data');

for WTG = 1:size(WTG_location,1)
    temp = abs(seaX-WTG_location(WTG,1))+abs(seaY-WTG_location(WTG,2));
    [c WTGindex(WTG)] = min(temp);
end