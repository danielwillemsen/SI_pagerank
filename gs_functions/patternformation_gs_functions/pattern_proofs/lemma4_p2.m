function [lemma4_p2_success,G2r] = lemma4_p2(states,active,t_passive_red)
%lemma4_p1 Implementation of Lemma4 Condition 2

[lemma4_p2_success,~,~,~,G2r] = reach_graph_direct(states, t_passive_red, active, 'any');

end

