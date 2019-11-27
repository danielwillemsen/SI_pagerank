function [gs2, gs2r] = gs2_patternformation(s, link_list)
% gs2_patternformation Calculates the local graphs GS2 and GS2r, which are defined as:
% GS2: indicates all state transitions that a robot could go through by an action of its neighbors, which could also move out of view.
% GS2r: a subgraph of GS2 which only indicates the state transitions in GS2 where a neighbor moves about the central robot, but not out of view.
%
% Note that, because the neighbor does not know what is beyond a certain point it cannot know what state their neighbors are in,
% it thus assumes everything is possible to generate this graph.
%
% Mario Coppola, 2018

gs2 = [];
gs2r = [];

p = find(link_list(s, :) == 1);
start_state_bin = link_list(s, :);
for i = 1:numel(p)
    if ~ check_iseven(p(i)) % p is odd
        jlim = [-2 -1 1 2];
    else
        jlim = [-1 1];
    end
    
    % The neighbor moves away from the neighborhood
    for j = jlim
        if start_state_bin(wraptosequence(p(i) + j, [1 8])) == 0
            newlink = start_state_bin;
            newlink(p(i)) = 0;
            newlink(wraptosequence(p(i) + j, [1 8])) = 1;
            newlink = get_local_state_id(newlink);
            gs2 = [gs2 newlink];
        end
    end
    
    % The neighbor stays in the neighborhood
    if start_state_bin(wraptosequence(p(i) - 1, [1 8])) == 1 || start_state_bin(wraptosequence(p(i) + 1, [1 8])) == 1
        newlink = start_state_bin;
        newlink(p(i)) = 0;
        newlink = get_local_state_id(newlink);
        gs2r = [gs2r newlink];
    end
 
end
gs2 = unique([gs2, gs2r]);

% Remap if the size of Q is smaller due us having less agents
s_id_orig = get_local_state_id(link_list);
gs2 = find(ismember(s_id_orig, gs2));
gs2r = find(ismember(s_id_orig, gs2r));

end
