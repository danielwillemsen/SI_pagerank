function gs1 = gs1_aggregation(Q,s)
%gs1_aggregation holds the active graph GSa for the aggregation task
%
% Mario Coppola, 2019

n = numel(s.states);
l1 = rude(n*ones(size(s.states)),s.states);
l2 = repmat(s.states,1,n);
p = 1./(s.states.^2);
state_diff = abs(l1-l2);

w = zeros(size(l1));
w(state_diff==0) = Q(:,1); %% Column 1 = stop %% good till here
w(state_diff~=0) = Q(l1(state_diff~=0),2)'.*p(l2(state_diff~=0));

gs1 = digraph(l1,l2,w);

end
