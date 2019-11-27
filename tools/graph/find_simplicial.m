function [simplicial, notsimplicial] = find_simplicial(link_list)
% find_simplicial Given a list of states, this functions returns which states are 
% simplicial (first output) and which states are not (second output).
%
% Mario Coppola, 2018

out = zeros(1, size(link_list, 1));
for i = 1:length(link_list)
    l = link_list(i, :);
 
    statespace_local = statespace_grid;
    statespace_local(l == 0, :) = []; % leave only neighbors
 
    newarrangement = statespace_local;
 
    % Check if one agent is left alone
    if size(statespace_local, 1) > 1
     
        for j = 1:size(newarrangement, 1)
            if all(max(abs([newarrangement(j, 1) newarrangement(j, 2)] - newarrangement([1:j - 1, j + 1:end], :)), [], 2) > 1)
                out(i) = 1;
            end
        end

        dar = diff(sort(newarrangement), 1);
        if any(dar(:) > 1)
            out(i) = 1;
        end

    end
end

notsimplicial = find(out == 1);
simplicial = find(out == 0);

end
