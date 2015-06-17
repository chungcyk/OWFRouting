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

display('Reading seabed data');

read_seabed

%% Sweep
display('Generating distance matrix');

capacity = 4;
no_of_nodes = size(WTG_location,1);
no_of_turbines = no_of_nodes -1 ;

[dist_matrix , pathCell]= mdist(WTGindex, vertices, faces);

% Sweep matrix
x_pt = [1,1,1,1,1,1,1,1,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,1,1,1,1,1,1,1,1,1];
y_pt = [1.01540000000000,1.06420000000000,1.15470000000000,1.30540000000000,1.55570000000000,2,2.92380000000000,5.75880000000000,1,1.01540000000000,1.06420000000000,1.15470000000000,1.30540000000000,1.55570000000000,2,2.92380000000000,5.75880000000000,0,-1.01540000000000,-1.06420000000000,-1.15470000000000,-1.30540000000000,-1.55570000000000,-2,-2.92380000000000,-5.75880000000000,-1,-1.01540000000000,-1.06420000000000,-1.15470000000000,-1.30540000000000,-1.55570000000000,-2,-2.92380000000000,-5.75880000000000,0];

for vStart = 1:numel(x_pt)
    display(sprintf('Processing Sweep Vector %d', vStart))
    sweep
    clarke
end

% Removing all temp variables
postclarketidy
%%

shortestroute

%%
% Representation

% Calculating distance
results= [];

for routeIdx = 1:size(route,2)
    
    for edge = 1:numel(route{ShortestRoute, routeIdx})-1
        rownumber = size(results,1)+1;
        results(rownumber,1) = routeIdx;
        results(rownumber,2) = route{ShortestRoute, routeIdx}(edge);
        results(rownumber,3) = route{ShortestRoute, routeIdx}(edge+1);
        results(rownumber,4) = dist_matrix(route{ShortestRoute,routeIdx}(edge)+1, route{ShortestRoute, routeIdx}(edge+1)+1);
        
    end
end

% Plotting on a figure
figure(1);
scatter(WTG_location(2:end,1),WTG_location(2:end,2),'x');
hold on;
scatter(WTG_location(1,1),WTG_location(1,2),'o');
hold on;

for cellNo = 1:size(route,2)
    for  nodeNo = 1:size(route{ShortestRoute,cellNo},2)-1
        start = route{ShortestRoute, cellNo}(nodeNo);
        finish = route{ShortestRoute, cellNo}(nodeNo+1);
        plot(pathCell{start+1,finish+1}(:,1),pathCell{start+1,finish+1}(:,2));
        hold on;
    end    
end

axis([0 21 0 21])

xlabel('x')
ylabel('y')
title(sprintf('Distance = %f', min(RouteDist)))
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
    for  nodeNo = 1:size(route{ShortestRoute,cellNo},2)-1
        start = route{ShortestRoute,cellNo}(nodeNo);
        finish = route{ShortestRoute,cellNo}(nodeNo+1);
        plot3(pathCell{start+1,finish+1}(:,1),pathCell{start+1,finish+1}(:,2),pathCell{start+1,finish+1}(:,3),'LineWidth',5);
        hold on;
    end    
end
xlabel('x')
ylabel('y')
zlabel('z')
title(sprintf('Distance = %f', min(RouteDist)))


%% Cost
cost