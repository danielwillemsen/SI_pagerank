function [lemma4_p1_success] = lemma4_p1(link_list,blocked,des,simplicial,mm,pm)
%lemma4_p1 Implementation of Lemma4 Condition 1
%
% Mario Coppola, 2018

% Let's not be premature, it could be that the states just
% perpetuate the branch so that we don't really have a
% reason to worry. It could also be that the states do not
% match with eachother
% Can they form a leaf of the branch? If not, then we are
% not concerned with them, or else we are too stringent,
% because the same situation will just happen further down.
% We do not look at this.
des = des(~any(and(link_list(des,1:4),(link_list(des,1:4)-link_list(des,5:8))==0),2));

% Lemma 4
% Condition 1 - None of the cliques of S_blocked can be formed by intersect(S_des,S_simplicial)
simplicial_des = intersect(simplicial,des);

mm_red_o = mm(blocked,simplicial_des);
pm_red_o = pm(blocked,intersect(simplicial,simplicial_des));

blocked_that_match_to_des = blocked(find(any(mm_red_o,2)));
violation_flag = zeros(size(blocked_that_match_to_des));
pm_red = pm_red_o(any(mm_red_o,2),:);

% Extract cliques of blocked states
for i = 1:length(blocked_that_match_to_des)
    if all(link_list(blocked_that_match_to_des(i),:))
        continue;
    end
    t = link_list(blocked_that_match_to_des(i),:);
    a = [t t];
    directions_where_cliques_begin = unique(wraptosequence(find(diff(a(1:end-1))==1)+1,[1 8]),'stable');
    directions_where_cliques_end   = unique(wraptosequence(find(diff(a)==-1),[1 8]),'stable');
    
    b = unique([directions_where_cliques_begin;directions_where_cliques_end]','rows')';
    crossover = any(b(2,:)-b(1,:)<0,1);
    
    for j = 1:numel(directions_where_cliques_begin)
        if ~crossover(j)
            clique_members = b(1,j):b(2,j);
        else
            clique_members = [b(2,j):8,1:b(1,j)];
        end

        match_directions_available = unique(cell2mat(pm_red(i,:)));
        if all(ismember(clique_members,match_directions_available))
            violation_flag(i) = 1;
            break;
        end
    end

end

states_that_do_not_meet_conditions = blocked_that_match_to_des(violation_flag==1);

lemma4_p1_success = 0;
if isempty(states_that_do_not_meet_conditions)
    lemma4_p1_success = 1;
end

% It seems like the pivot points of the pattern give trouble.
% I think this can be an exception in the whole thing.
% Also these are not leafs!!!!

end
