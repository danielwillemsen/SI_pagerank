function [gs2,tgs2] = gs2_aggregation(Q,s)
%gs2_aggregation holds the passive graph GSp for the aggregation task
%
% Mario Coppola, 2019

n = numel(s.states);

l1 = [s.states s.states(2:end)   s.states(1:end-1)  ];
l2 = [s.states s.states(2:end)-1 s.states(1:end-1)+1];

tgs2 = cell(1,n);
for i = 1:n
    tgs2{i} = l2(l1==i);
end

gs2 = digraph(l1,l2);

end
