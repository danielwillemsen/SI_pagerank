%% Initialize
init;

%% Set up input variables
fprintf('---- Starting Optimization ----');
data_write_folder = 'data_paper/consensus/evolutions/'; % Where the final data will be stored
runtime_ID = set_runtime_ID();
savedata = 0;
generations_max = 1000;
population.size = 10; % Genome population size
s.bw = 3; % Number of choices m

%% States
fprintf("Setting up problem \n");
[ga, s, Q0] = initialize_parameters_consensus(generations_max, s);
gs1 = gs1_consensus(Q0,s.states);
[~,s.tgs2] = gs2_consensus(s.states);

%% Generates the D and E matrices similar to the paper
[D,E] = pr_DE_consensus(s);

%% From here on the approach is different from the original paper.
% We construct a reward vector: taking any action in a desired state receives a reward of 1. Else 0.
% reward vector r_sa: S x A
r_sa = zeros(length(s.states),s.bw);
r_sa(s.des,:) = 1.0;

r_sa = -1.*reshape(r_sa, [length(r_sa)*s.bw,1]);


%% We then construct the state transition matrix 
%%state transition P: S x S' x A -> R 

% For the active part we use the graph gs1. We only use the connections,
% not the weights as our P-matrix should be independent of policy.
% in this task, the active part of the matrix is deterministic.

P_ssa = zeros(length(s.states),length(s.states),s.bw); 
for i = 1:height(gs1.Edges)
    edge = gs1.Edges{i,1};
    s_old = edge(1);
    s_new = edge(2);
    a = s.states(s_new,1);
    P_ssa(s_old, s_new, a) = 1;
end

% The active part is multiplied with the probability that the robot
% takes a move in contrast to the environment.
% The passive part (E) is independent of our policy and can be added to the
% matrix, multiplied with (1-alpha).
% For every action (s.bw), there is 1-alpha probability that an
% environment transition gets executed instead of the desired action.
% We do not use D in our model, as the robot can discover moves in which it
% shall not take any actions on its own. The optimal action will then
% simply be to keep the current opinion.
alpha = diag(1./(s.n_neighbors + 1));
for i = 1:s.bw
    P_ssa(:,:,i) = alpha*P_ssa(:,:,i) + (eye(length(alpha))-alpha)* E;
end

% This concludes the creation of the MDP: we have the rewards (r(s,a)) and
% state transitions P(s, s',a)

%% Reformulating the MDP into a linear programming (or linear optimization) problem:
% Objective:
% minimize transpose(r_sa)*x
%
% such that:    Aeq * x = beq
%               x >= lb
% Here: x is the vector to be found. lb, beq and f are vector. Aeq is a
% matrix. In our case:
% x(s,a):   is the probability of being in state s taking action a.
%               similarly, x(s) is the sum of x(s,a) over all actions, i.e.
%               the probability of being in state s.
% r_sa(s,a):   reward associated with being in state s, taking action a.
% Aeq * x = beq are the constraints:
%   1. consistency of state transitions: 
%           x(s') = sum_a (x(s,a)*P(s,s',a)) for all s'
%   2. total probability of being in a state should be 1. Now, we are
%   actually dealing with n_maxneighbors seperate MDP's, neigbors dont
%   disappear or suddenly appear in the model. Therefore; for every
%   seperate number of neighbor, the total probability of being in any
%   state associated with that number of neighbors should be equal to 1.
%
% The reward vector r_sa is already derived. So the next step is to create
% the constraints.

%% Constraint 1
%% Reformat P_ssa to the correct dimensions
sizeP_ssa = size(P_ssa);
RH = P_ssa;
RH = reshape(permute(RH,[1,3,2]), [sizeP_ssa(1)*sizeP_ssa(3), sizeP_ssa(2)]);
RH = RH.';

%% Substract x(s') to set sum_a (x(s,a)*P(s,s',a)) - x(s') = 0
I = eye(sizeP_ssa(1));
I2 = repmat(I,1,s.bw);

Aeq = RH-I2;
beq = zeros(sizeP_ssa(1),1);

%% Constraint 2
for i = 1:s.maxneighbors
    Aeq2_single = zeros(1,sizeP_ssa(1));
    Aeq2_single(s.n_neighbors == i) = 1;
    Aeq2 = repmat(Aeq2_single,1,s.bw);
    beq2 = ones(1);
    Aeq = [Aeq; Aeq2];
    beq = [beq; beq2];
end

%% Al state probabilites >= 0
lb = zeros(sizeP_ssa(1)*sizeP_ssa(3),1);

fprintf("Solving LP problem")

%% Solve the resulting problem problem:
y = linprog(r_sa,[],[],Aeq,beq, lb, []);
y = reshape(y,[length(y)/s.bw, s.bw])+0.00;
y = y ./ sum(y,2);

%% Create the policy in the same format as the other scripts
Q = y;
Q(s.des,:) = 0;

%% Evaluate fitness
F = fitness_consensus_centrality(Q, s);

fprintf("resulting fitness:" + string(F) + "\n")

% The resulting policy is deterministic.

%% Some parts of the policy have no influence on the fitness function.
% The following lines set the values associate with these parts to 0.5 
% Instead of 0 or 1, to reduce deterministicness, hopefully resulting in
% less deadlocks?


for i=1:length(y)
    y_temp = y;
    y_temp(i,:) = repmat(1/s.bw, 1, s.bw);
    Q = y_temp;
    Q(s.des,:) = 0;
    F_temp = fitness_consensus_centrality(Q, s);
    if abs(F_temp-F) < 0.00001
        y = y_temp;
    end
end
Q = y;
Q(s.des,:) = 0;

% Q = y+0.05;
% Q = Q ./ sum(Q,2);
% Q(s.des,:) = 0;
% 
% sml.des = s.des;
% sml.bw = s.bw;
% sml.states = s.states;
% Q1 = Q;
% param_sim = { 'type', 'consensus', 'visualize', 1, 'verbose', 1};
% n_episodes = 10; % Number of runs
% m = 3;
% n_agents = [10 20]; % number of robots in the swarm
% 
% for j = 1:numel(n_agents)
%     sml.n_agents = n_agents(j);
%     stats{i,j} = simulation_episode_batch_launch (sml, Q1, n_episodes, param_sim{:});
% end
