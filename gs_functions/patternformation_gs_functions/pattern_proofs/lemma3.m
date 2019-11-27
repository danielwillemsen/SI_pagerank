function lemma3_success = lemma3(tgs1,tgs2,des,states)
%lemma3 Implementation of Lemma 3
%
% Mario Coppola, 2018

% Calculate combined edges for GS1 and GS2
t_f = cellfun(@(x,y) unique([x y]), tgs1, tgs2, 'UniformOutput', false);

% Determine whether all states can reach all desired states via bfsearch
lemma3_success = reach_graph(states, t_f, states, des);

end

