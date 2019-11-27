function [gs2,tgs2] = gs2_consensus_binary(states)
%gs2_consensus_binary holds the passive graph GSp for the consensus task (binary variant)
%
% Mario Coppola, 2019

nstates = size(states, 1);
bw = max(states(:,1));
p = repmat([2/3 1/3],1,bw);

s = [];
t = [];
w = [];
tgs2 = cell(1,nstates);
states = double(states);

for i = 1:nstates
    s_i = states(i,:);
    t_temp = find(states(:,1)==s_i(1))';
    t = [t t_temp];
    s = [s i*ones(size(t_temp))];
    w = [w p(t_temp)];
end
gs2 = digraph(s,t,w);

end

