% Sweep
angles = zeros(no_of_nodes-1,1);
clear route_allocation
clear route_clusters

v1 = [x_pt(vStart),y_pt(vStart)]; 
u1 = v1 / norm(v1);

for i=1:no_of_turbines   
    v2 = [WTG_location(i+1,1)-WTG_location(1,1), (WTG_location(i+1,2)-WTG_location(1,2))];
    u2 = v2 / norm(v2);
    angles(i) = atan2(v1(1)*v2(2)-v2(1)*v1(2),v1(1)*v2(1)+v1(2)*v2(2));
end

[angle_ans,angle_order] = sort(angles); 

for i = 1:no_of_turbines
    route_allocation(angle_order(i)) = ceil(i/capacity);
end

route_allocation = route_allocation';
no_of_clusters = max(route_allocation);


% Allocating routes 
for i = 1:no_of_clusters
    route_clusters{i}  = WTGindex(find(route_allocation==i)+1);
end

