function theorem_p3_success = theorem1_p3(link_list,Q,active,simplicial,static)
%lemma4_p1 Implementation of Theorem 1 Condition 3

as = intersect(active,simplicial);
next_layer = [0 2; 1 2; 2 2; 
              2 1; 2 0; 2 -1; 2 -2;
              1 -2; 0 -2; -1 -2; -2 -2;
              -2 -1; -2 0; -2 1; -2 2;
              -1 2];
inner_layer = statespace_grid;
[to_exclude,~] = find(and(sum(link_list,2)==7,any(link_list(:,[1,3,5,7])==0,2))); % states that locally become loops, which will collapse, but not captured here.
as(ismember(as,to_exclude)) = [];
theorem_p3_success_loc = zeros(1,numel(as));

for i = 1:numel(as)
    
    % Create square of positions of the agent.
    inner_layer_i = inner_layer;
    inner_layer_i(link_list(as(i),:)==1,:)=[]; % remove neighbor positions.
    
    neighbor_positions = inner_layer;
    neighbor_positions(link_list(as(i),:)==0,:)=[]; % get neighbor positions.
    x_marks_raw = [0,0; next_layer; inner_layer_i];
    d1 = x_marks_raw(:,1)-neighbor_positions(:,1)';
    d2 = x_marks_raw(:,2)-neighbor_positions(:,2)';
    d = sqrt( d1.^2 + d2.^2 );
    x_marks     = x_marks_raw(min(d,[],2)<=1.01,:);
    x_marks_all = x_marks_raw(min(d,[],2)<=1.5,:);
    
    % Identify possible states that the neighbor could be in
    s = zeros(numel(size(x_marks_all,2)),1);
    for j = 1:size(x_marks_all,1)
        [state_idx] = model_pattern_local( [x_marks_all(j,:);neighbor_positions] );
        s(j) = state_idx(1);
    end
    
    sd = zeros(numel(size(x_marks,2)),1);
    for j = 1:size(x_marks,1)
        [state_idx] = model_pattern_local( [x_marks(j,:);neighbor_positions] );
        sd(j) = state_idx(1);
    end
    sd = unique(sd,'stable');
    
    % Remap if the size of Q is smaller due us having less agents
    s_id_orig = get_local_state_id(link_list);
    for k = 1:numel(s)
        s(k) = find(ismember(s_id_orig,s(k)));
    end
    for k = 1:numel(sd)
        sd(k) = find(ismember(s_id_orig,sd(k)));
    end
    
    % Motion graph of possible actions
    gr = digraph;
    for k = 1:numel(s)
        gr = addedge(gr,...
        k*ones(1,numel(Q(s(k),:))>0),...
        find(ismember(x_marks_all,x_marks_all(k,:)+inner_layer(Q(s(k),:)>0,:),'rows')));
    end
    
    % plot for debug purposes
%     newfigure(1); 
%     plot_state(as(i));
%     plot(gr,'NodeLabel',s,'XData',x_marks_all(:,1),'YData',x_marks_all(:,2))
    
    % Test
    t = conncomp(gr,'Type','Strong');

    if numel(t) == numel(s) && range(t(ismember(s,sd)))==0 %% no singletons and all belong to the same connection
       theorem_p3_success_loc(i) = 1;
    elseif any(ismember(s(bfsearch(gr,1)),static)) % If it can reach a static state it's all good
        t = ismember(find(ismember(s,static)),bfsearch(gr,1)); %as(i) is 1 because x_marks(1,:)=[0 0]
        if any(t)
           theorem_p3_success_loc(i) = 1;
        else
           break;
        end
    else
        break;
    end
end
    
if all(theorem_p3_success_loc)
    theorem_p3_success = 1;
else
    theorem_p3_success = 0;
end

end