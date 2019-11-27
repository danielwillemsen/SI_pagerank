function Q0 = init_policy_consensus(states)
%init_policy_consensus_binary Initializes the default policy for the consensus task
%
% Mario Coppola, 2019

nstates = size(states, 1);
bw = size(states, 2) - 1;
Q0 = ones(nstates,bw)/bw;

end
