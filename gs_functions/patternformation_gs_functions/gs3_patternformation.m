function new_link_possibilities = gs3_patternformation(s, link_list)
% gs3_patternformation Calculates the local graph GS2, which is defined as:
% GS3 : indicates all state transitions that a robot could go through if another robot, previously out of view, were to move into view and become a new neighbor.
% 
% Note that, because the neighbor does not know what is beyond a certain point it cannot know what state their neighbors are in,
% it thus assumes everything is possible to generate this graph.
%
% Mario Coppola, 2018

start_state_bin = dec2bin(s, 8) - '0';
newagent = eye(8, 8);
newlinks = or(newagent, start_state_bin);
new_link_possibilities = get_local_state_id(newlinks);
new_link_possibilities = unique(new_link_possibilities);

s_id_orig = get_local_state_id(link_list);
new_link_possibilities = find(ismember(s_id_orig, new_link_possibilities));

end
