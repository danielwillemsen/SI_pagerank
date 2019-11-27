function [fitness, c] = fitness_pattern_phase2(Q, s)
% fitness_pattern_phase2 uses the policy to compute GS1
% (GS2 and GS3 remain unchanged since too little information is known about the environmnent) 
% and uses this to calculate the PageRank fitness
%
% Mario Coppola, 2018

% Define set of states
s.active = find(any(Q, 2));
s.static = s.states(~ any(Q, 2));
s.blocked = s.static(~ ismember(s.static, s.des));

% Proof check
tgs1 = cell(1, size(Q, 1)); % Transitions when an action is computed
tgs1_a = tgs1;
tgs1r = tgs1;
tgs1r_a = tgs1;

for i = 1:size(Q, 1)
    [tgs1{i}, tgs1r{i}, tgs1_a{i}, tgs1r_a{i}] = gs1_patternformation(i, Q, s.action_state_relation_idx, s.link_list);
end

[fitness, c] = fitness_pattern_centrality(Q, s, tgs1, tgs1_a, s.tgs2, s.tgs3);

end
