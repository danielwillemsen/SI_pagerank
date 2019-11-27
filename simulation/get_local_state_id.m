function idx = get_local_state_id(link_set)
%get_local_state_id returns the state ID given a binary neighbor set
%
% Mario Coppola, 2018

idx = makehorizontal(sum(link_set .* [128 64 32 16 8 4 2 1], 2));

end
