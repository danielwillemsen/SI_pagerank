function [proof_outcome,tgs1,tgs1_a,tgs2,tgs3] = localproof(Q,s)
%localproof checks all the conditions of the local proof.
% It also outputs the transitions describing GS1, GS2, and GS3, which can be used later in the evaluation of PageRank.
%
% Mario Coppola, 2018
proof_outcome = 0;

% Proof check
tgs1    = cell(1,size(Q,1)); % Transitions when an action is computed
tgs2    = tgs1; % Transitions when a neighbor computes an action
tgs2r   = tgs1; % Transitions when a neighbor computes an action without escape
tgs3    = tgs1; % Transitions when a neighbor pops up from nowhere
tgs1_a  = tgs1;

if ~lemma4_p1(s.link_list,s.blocked,s.des,s.simplicial,s.mm,s.pm)
    fprintf('\tFailed Lemma 4 Part 1\n')
    return;
end

for i = 1:size(Q,1)
    tgs3{i} = gs3_patternformation(i,s.link_list);
end
if ~theorem1_p4(s.link_list,s.states,s.active,tgs3)
    fprintf('\tFailed Theorem 1 Part 4\n')
    return;
end

for i = 1:size(Q,1)
    [tgs2{i},tgs2r{i}] = gs2_patternformation(i,s.link_list);
end
if ~lemma4_p2(s.states,s.active,tgs2r)
    fprintf('\tFailed Lemma 4 Part 2\n')
    return;
end

for i = 1:size(Q,1)
    [tgs1{i},~,tgs1_a{i},~] = gs1_patternformation(i,Q,s.action_state_relation_idx,s.link_list);
end
if ~lemma3(tgs1,tgs2,s.des,s.states)
    fprintf('\tFailed Lemma 3\n')
    return;
end

if ~theorem1_p3(s.link_list,Q,s.active,s.simplicial,s.static)
    fprintf('\tFailed Theorem 1 Part 3\n')
    return;
end

proof_outcome = 1;

end