%%
no_of_routes = 1;
    route_flag = zeros(1,size(seaX,1));
    
for r = 1:no_of_clusters

%     route_curr = route_clusters{r}+1;
  route_curr = route_clusters{r};  
    if (numel(route_curr) == 1) % If there is only one node in that path
        
        a = route_clusters{r}(1);
        route{vStart,no_of_routes}(1) = a; % a to be the first node
        route_flag(a) = 1;
        no_of_routes = no_of_routes+1;
        
    elseif (numel(route_curr) == 2) % If there is only one node in that path

                a = route_clusters{r}(1);
        b = route_clusters{r}(2);
        route{vStart,no_of_routes}(1) = a; % a to be the first node
        route{vStart,no_of_routes}(2) = b; % a to be the first node
        route_flag(a) = 1;
        route_flag(b) = 1;
        no_of_routes = no_of_routes+1;
        
%         a = route_clusters{r}(1);
%         route{vStart,no_of_routes}(1) = a; % a to be the first node
%         route_flag(a) = 1;
%         no_of_routes = no_of_routes+1;
% 
%         b = route_clusters{r}(2);
%         route{vStart,no_of_routes}(1) = b; % a to be the first node
%         route_flag(b) = 1;
%         no_of_routes = no_of_routes+1;
    
    else 
    route_curr = [WTGindex(1); route_curr'];
%     temp_loc =  WTG_location(route_curr,:);
    
    % By now all WTG location of route r is in temp_loc
    
%     [dist_matrix_curr , ~] = mdist(route_curr, vertices, faces);
    
    for m=1:numel(route_curr)
        route_curr(m) = find(WTGindex == route_curr(m));
    end

    dist_matrix_curr = dist_matrix(route_curr,route_curr);   

    turbine_on_string = numel(route_clusters{r});
    
    savings = zeros(turbine_on_string);

    for i = 1:turbine_on_string
        for j = 1:turbine_on_string        
            if i<j
                savings(i,j) = dist_matrix_curr(1,j+1)+dist_matrix_curr(i+1,1)-dist_matrix_curr(i+1,j+1); %Look at this
            end        
        end
    end

    % Sort the savings into descending values
    [~,sort_index] = sort(savings(:),'descend');
    sort_index=sort_index(1:nnz(savings));

    savings_index = 1;
    

    while (sum(route_flag(route_clusters{r})) < turbine_on_string)
    
        index = sort_index(savings_index);%+turbine_on_string;
        loc_a = ceil(index/ (turbine_on_string));
        loc_b = mod(index, (turbine_on_string));
       
        a = route_clusters{r}(loc_a);
        b = route_clusters{r}(loc_b);
        
 
    % Check to see if it exceeds capacity and appeared before
        if (xor(route_flag(a), route_flag(b)))
                check=0;
                for k = 1:no_of_routes-1
                    check(k) = ismember(a,route{vStart,k});                
                end          
                routeIdx = find(check==1);
                
                present = a;
                non_present = b;
     
              if isempty(routeIdx)             
                for k = 1:no_of_routes-1
                    check(k) = ismember(b,route{vStart,k});                
                end          
                routeIdx = find(check==1);
                
                present = b;
                non_present = a;
            end

            if (route{vStart,routeIdx}(end) == present)
                route{vStart,routeIdx}(end+1)= non_present;
                route_flag(non_present) = 1;
            elseif (route{vStart,routeIdx}(1) == present)
                route{vStart,routeIdx} = [non_present route{vStart,routeIdx}];
                route_flag(non_present) = 1;
            else
               ;
            end
      
        elseif (route_flag(a) == 0 && route_flag(b) == 0)
            % new route

                route{vStart,no_of_routes}(1) = a; % a to be the first node
                route{vStart,no_of_routes}(end+1) = b; % b to be the last node

                route_flag(a) = 1;
                route_flag(b) = 1;
                no_of_routes = no_of_routes+1;

        else 
            ;
        end
     
        savings_index = savings_index+1;      
    end
    end
    
end