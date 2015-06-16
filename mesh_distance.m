function [ d , result_path, x, y, z] = mesh_distance( start, finish, vertices, faces)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %Based on example1.m
    [mesh, edge_to_vertex, edge_to_face] = geodesic_new_mesh(vertices,faces);         %initilize new mesh and receive edge info
%     disp(sprintf('mesh has %d edges', length(edge_to_vertex)));

    %put the first source at the vertex #10
    source_points = {};
    vertex_id = start;        
    source_points{1} = geodesic_create_surface_point('vertex',vertex_id,vertices(vertex_id,:));

    algorithm = geodesic_new_algorithm(mesh, 'exact');      %initialize new geodesic algorithm
    geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm (the most time-consuming)

    [source_ids, distances] = geodesic_distance_and_source(algorithm);     %for every vertex, figure out which source it belongs to

    vertex_id = finish;           %last vertex of the mesh is destination
    destination = geodesic_create_surface_point('vertex',vertex_id, vertices(vertex_id,:));

    for j=1:length(algorithm)

        geodesic_propagate(algorithm, source_points);   %propagation stage of the algorithm 
        path = geodesic_trace_back(algorithm, destination); %find a shortest path from source to destination

        [x,y,z] = extract_coordinates_from_path(path);
%         plot3(x,y,z,'LineWidth',2);    %plot a sinlge path for this algorithm
        result_path = [x y z];
        
        path_length = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));            %length of the path
        [source_id, d] = geodesic_distance_and_source(algorithm, destination);    %you can confirm that the path length is equal to the distance estimated by geodesic_best_source
    %     s = sprintf('%s algorithm, estimated/actual length of the path is %f/%f', ...
    %          algorithm.type, d, path_length);
    %     disp(s);
       
    end

end

