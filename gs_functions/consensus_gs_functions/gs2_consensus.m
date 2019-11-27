function [gs2,tgs2] = gs2_consensus(states)
%gs2_consensus holds the passive graph GSa for the consensus task
%
% Mario Coppola, 2019

nstates = size(states, 1);
s = [];
t = [];
tgs2 = cell(1,nstates);
states = double(states);
for i = 1:nstates
    s_i = states(i,:);
    % indexes with same zero sum
    indexes_samesum = find(sum(s_i(2:end)) == sum(states(:,2:end),2))';
    % indexes with single change + not part of gs1
    indexes_single = indexes_samesum(max(abs(states(indexes_samesum,2:end)-s_i(2:end)),[],2)==1);
    % your own state stays the same
    indexes_single(states(indexes_single,1) ~= s_i(1)) = [];
    
    s = [s i*ones(size(indexes_single))];
    t = [t indexes_single];
    tgs2{i} = indexes_single;
end
gs2 = 0;%digraph(s,t);

end

