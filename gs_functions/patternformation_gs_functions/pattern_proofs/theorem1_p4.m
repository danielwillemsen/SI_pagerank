function [theorem_p4_success,a] = theorem1_p4(link_list,states,active,t_surprise)
%lemma4_p1 Implementation of Theorem 1 Condition 4

[theorem_p4_success,yes] = reach_graph_direct(states, t_surprise, active, 'any');
a = find(yes==0);
a(sum(link_list(a,:),2) == size(link_list,2)-1)=[];

end

