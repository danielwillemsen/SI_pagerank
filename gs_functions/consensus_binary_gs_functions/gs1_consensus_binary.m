function gs1 = gs1_consensus_binary(Q,states)
%gs1_consensus_binary holds the active graph GSa for the consensus task (binary variant)
%
% Mario Coppola, 2019

nstates = size(states, 1);
bw = max(states(:,1));
s = []; t = []; w = [];
tgs1 = cell(1,nstates);

for i = 1:2:nstates % skip desired states
    s_i = states(i,:);
    
    indexes = zeros(1,bw);
    for j = 1:bw
        [~, indexes] = ismember([s_i(1) 1],states,'rows');
    end
    
    % transition
    t_temp = 1:nstates;
    t_temp(t_temp==indexes) = [];
    t = [t t_temp];
    
    s = [s i*ones(size(t_temp))];

    % Weights
    w_temp = Q(i,states(t_temp,1));
    p = hist(states(t_temp,1),bw);
    w_temp = w_temp./rude(p,p);
    w = [w w_temp];
    tgs1{i} = indexes;
end
gs1 = digraph(s,t,w);

end

