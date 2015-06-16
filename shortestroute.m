% Return all indexing back to normal
for routeno = 1:numel(route)
    for rk = 1:numel(route{routeno})
        route{routeno}(rk) = find(WTGindex==route{routeno}(rk))-1;
    end
end

%% Work out which is the better version
RouteDist = zeros(size(route,1),size(route,2));
for vNumber = 1:numel(x_pt)
    for routeIdx = 1:size(route,2)
        if (numel(route{vNumber,routeIdx}) == 1)
            route{vNumber,routeIdx} = [0 route{vNumber,routeIdx} 0];
        else 
            route{vNumber,routeIdx} = [0 route{vNumber,routeIdx} 0];
        end

        for edge = 1:numel(route{vNumber,routeIdx})-1
            RouteDist(vNumber,routeIdx) = RouteDist(vNumber,routeIdx) + dist_matrix(route{vNumber,routeIdx}(edge)+1, route{vNumber,routeIdx}(edge+1)+1);
        end
    end
end

RouteDist = sum(RouteDist,2);
[~, ShortestRoute] = min(RouteDist);