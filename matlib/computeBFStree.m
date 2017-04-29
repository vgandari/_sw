function parent = computeBFStree(AdjTable,start,goal)

% initialize parent array
% -1 corresponds to NONE
parent = -1*ones(1,length(AdjTable));

% define starting node as its own parent
parent(start) = start;

% initialize queue with starting node
queue = [];
queue = [queue start];

while length(queue) > 0
    % retrieve first element of queue
    v = queue(1);
    queue(1) = [];
    
    % loop through each adjacency table array
    for ii = 1:length(AdjTable{1,v})
        % store i'th node in array
        u = AdjTable{1,v}{ii};
        % if u has no parent
        if parent(u) == -1
            % set v as parent of u
            parent(u) = v;
            % add u to queue
            queue = [queue u];
        end
        
        % if reached goal, return
        if u == goal
            return
        end
    end
end

if u ~= goal
    fprintf('Goal not reached, graph not connected\n');
    fprintf('Expect error when calling computeBFSpath');
    return
end

