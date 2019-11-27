function gs1 = gs1_consensus(Q,states)
%gs1_consensus holds the active graph GSa for the consensus task
%
% Mario Coppola, 2019

nstates = size(states, 1);
bw = size(states, 2) - 1;
s = []; t = []; w = [];
tgs1 = cell(1,nstates);
for i = 1:nstates
    s_i = states(i,:);
    indexes = zeros(1,bw);
    for j = 1:bw
        % This always returns an ordered list
        [~, indexes(j)] = ismember([j s_i(2:end)],states,'rows');
    end
    s = [s i*ones(size(indexes))];
    t = [t indexes];
    w = [w Q(i,:)];
    tgs1{i} = indexes;
end
gs1 = digraph(s,t,w);

end

