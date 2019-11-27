%% Set up policy parameters
linkset_des = feval(pattern_name);  % Desired states
% Build the state action map
if strcmp(type_test,'pattern') % Default
    [Q0, s.des, ~, ~, s.link_list] = init_policy_pattern (linkset_des, 0, 1:8, 'n_agents', s.n_agents);
    % Normalize Q0 to not just be binary but to also be probabilistic
    Q0 = bsxfun(@rdivide,double(Q0),sum(Q0,2));
    Q0(isnan(Q0)) = 0;
    Qidx = find(double(Q0) > 0.01);
    
    sml.des = get_local_state_id(s.link_list(s.des, :));
    sml.observation = @model_pattern_local;
    sml.model = @model_pattern_global;
elseif strcmp(type_test,'consensus')
    [ga, s, Q0] = initialize_parameters_consensus(10, s);
    Qidx = find(double(Q0) > 0.01);
    sml.bw = s.bw;
    sml.des = s.des;
    sml.states = s.states;
end

%% Set up simulation parameters
sml.n_agents = s.n_agents;
param = {'visualize', 0, 'verbose', 1, 'type', type_test};
normalize = '>1';

%% Evaluate
for i = 1:n_policies
    Q = Q0;
    new_mutated = rand(1,numel(Qidx));
    Qtest = double(Q); % Initialize copy of Q to test on
    Qtest(Qidx) = new_mutated; % Set mutated values
    
    if strcmp(normalize,'>1')
        Qt = Qtest((sum(Qtest, 2) > 1), :); % Get sum larger one
        Qtest((sum(Qtest, 2) > 1), :) = Qt ./ sum(Qt, 2);
    elseif strcmp(normalize,'all')
        Qt = Qtest;
        Qtest = Qt ./ sum(Qt,  2); % Normalize
    end
    Qtest(isnan(Qtest)) = 0; % Remove NaN just in case
    if strcmp(type_test,'pattern')
        Qt = zeros(255,8);
        Qt(get_local_state_id(s.link_list),:) = Qtest;
        Qtest_store_pattern{p,i} = Qt;
    else
        Qt = Qtest;
        Qtest_store_consensus{p,i} = Qt;
    end
    stats{p,i} = simulation_episode_batch_launch (sml, Qt, n_episodes, param{:});
end