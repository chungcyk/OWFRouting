% ================================================================
% Optimal wind farm layout, with the main emphasis on optimal cabling
% Michael Yat Kit Chung ykc111
% June 2015
% ================================================================

%% Initialisation
clear all;
close all;
addpath('geodesic');
%% Read in seabed data from text file
read_seabed

   % geodesic
    global geodesic_library;                
    geodesic_library = 'geodesic_debug';      %"release" is faster and "debug" does additional checks
    rand('state', 0);  

%     tri = delaunay(seaX',seaY');
%     trisurf(tri,seaX',seaY',seaZ')
%     colormap white
%     hold on;

%     %Based on create_flat_triangular_mesh(step, smoothness)
    clear vertices;
    vertices(:,1) = seaX';
    vertices(:,2) = seaY';
    vertices(:,3) = seaZ';
    faces = delaunay(seaX',seaY');

%% Read in turbine location data
load test16.mat
% load test50grid.mat


%% Compile the location data into points

for WTG = 1:size(WTG_location,1)
    temp = abs(seaX-WTG_location(WTG,1))+abs(seaY-WTG_location(WTG,2));
    [c WTGindex(WTG)] = min(temp);
end

%% Find the distance
% dist
%% Sweep
sweep

% Return all indexing back to normal
for routeno = 1:numel(route)
    for rk = 1:numel(route{routeno})
        route{routeno}(rk) = find(WTGindex==route{routeno}(rk))-1
    end
end

%%
% Representation

% Calculating distance
RouteDist = zeros(1,no_of_routes);
results= [];

for routeIdx = 1:numel(route)
    if (numel(route{routeIdx}) == 1)
        route{routeIdx} = [0 route{routeIdx}];
    else 
        route{routeIdx} = [0 route{routeIdx} 0];
    end
    
    
    for edge = 1:numel(route{routeIdx})-1
        rownumber = size(results,1)+1;
        results(rownumber,1) = routeIdx;
        results(rownumber,2) = route{routeIdx}(edge);
        results(rownumber,3) = route{routeIdx}(edge+1);
        results(rownumber,4) = dist_matrix(route{routeIdx}(edge)+1, route{routeIdx}(edge+1)+1);
        
        RouteDist(routeIdx) = RouteDist(routeIdx) + dist_matrix(route{routeIdx}(edge)+1, route{routeIdx}(edge+1)+1);
    end
end

% Plotting on a figure
figure(1);
scatter(WTG_location(2:end,1),WTG_location(2:end,2),'x');
hold on;
scatter(WTG_location(1,1),WTG_location(1,2),'o');
hold on;

for cellNo = 1:size(route,2)
    for  nodeNo = 1:size(route{cellNo},2)-1
        start = route{cellNo}(nodeNo);
        finish = route{cellNo}(nodeNo+1);
        plot(pathCell{start+1,finish+1}(:,1),pathCell{start+1,finish+1}(:,2));
        hold on;
    end    
end

axis([-1 11 -1 11])
hold off;

figure(2);
trisurf(faces,seaX',seaY',seaZ')
colormap white;
hold on;

scatter3(seaX(WTGindex(2:end)),seaY(WTGindex(2:end)),seaZ(WTGindex(2:end)),'x');
hold on;
scatter3(seaX(WTGindex(1)),seaY(WTGindex(1)),seaZ(WTGindex(1)),'o');
hold on;

for cellNo = 1:size(route,2)
    for  nodeNo = 1:size(route{cellNo},2)-1
        start = route{cellNo}(nodeNo);
        finish = route{cellNo}(nodeNo+1);
        plot3(pathCell{start+1,finish+1}(:,1),pathCell{start+1,finish+1}(:,2),pathCell{start+1,finish+1}(:,3));
        hold on;
    end    
end

%% Cost

cost