function Q0 = init_policy_consensus_binary(s)
%init_policy_consensus_binary Initializes the default policy for the consensus task (binary variant)
%
% Mario Coppola, 2019

nstates = size(s.states, 1);
Q0 = ones(nstates,s.bw)/s.bw;

end
