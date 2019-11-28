% Script to quickly evaluate the results of a given evolution.
% Mainly used for quick evaluation, not for the final one (dedicated scripts are available for that).
%
% Mario Coppola, 2019

%% Initialize
init;

%% Analysis params
n_episodes = 10; % Number of runs
n_policies = 50; % Number of random policies to test

%% Analysis params
pattern_list = {'triangle4','hexagon','triangle9','T'};
n_agents = [4 6 9];
type_test = 'pattern';

for p = 1:numel(pattern_list)
    pattern_name = pattern_list{p};
    s.n_agents = n_agents(p);
    script_test_time
end
fprintf('Done for standard patterns \n')
save('data_paper/patternformation/time_stats_4_6_9',Qtest_store_pattern,stats);

%% Plot
load('data_paper/patternformation/time_stats_4_6_9.mat')
for p = 1:3
    for i = 1:n_policies
        m(p,i) = mean(stats{p,i}.ev_time);
    end
end
a = [4 6 9];
newfigure(2,'','Fig25')

loglog(4*ones(1,50),m(1,:),'rx','MarkerSize',15)
hold on
loglog(6*ones(1,50),m(2,:),'bo','MarkerSize',15)
loglog(9*ones(1,50),m(3,:),'ks','MarkerSize',15)
legend('Triangle (4 robots)', 'Hexagon', 'Triangle (9 robots)','Location','SouthEast')
xlabel('Number of robots')
ylabel('Evaluation wall-clock time [s]')
xlim([0 10])
ylim([0 200])
grid on
grid minor
latex_printallfigures(get(0, 'Children'), '', 'paper_wide', 2);

%% Line
clear Qtest_store_pattern stats
n_agents = 3:10;
type_test = 'pattern';
for p = 1:numel(n_agents)
    pattern_name = 'lineNE';
    s.n_agents = n_agents(p);
    script_test_time
end
fprintf('Done for lineNE \n')
save('global_time_stats_line',Qtest_store_pattern,stats);

%% Consensus 2
clear Qtest_store_pattern stats
n_agents = 3:20;
type_test = 'consensus';
s.bw = 2;
for p = 1:numel(n_agents)   
    p
    pattern_name = 'lineNE';
    s.n_agents = n_agents(p);
    script_test_time
end

fprintf('Done for consensus 2 \n')
save('global_time_stats_consensus_2',Qtest_store_consensus,stats);

%%
load('data_paper/consensus/stats_consensus2_3to20.mat')
for p = 1:17
    for i = 1:n_policies
        m(p,i) = mean(stats{p,i}.ev_time);
    end
end
a = 3:20
plot(a,m,'o')
xlabel('Number of robots')
ylabel('Evaluation wall-clock time [s]')
xlim([0 20])
% ylim([0 200])


%% Consensus 3
clear Qtest_store_consensus stats
n_agents = 3:20;
type_test = 'consensus';
s.bw = 3;
for p = 1:numel(n_agents)
    p
    pattern_name = 'lineNE';
    s.n_agents = n_agents(p);
    script_test_time
end

fprintf('Done for consensus 3 \n')
save('global_time_stats_consensus_3',Qtest_store_consensus,stats);

%% Aggregation
% Load from swarmulator logs
n_agents = [5 10 20 50 100];
    newfigure(1)
for i = 1:numel(n_agents)
    name{i} = sprintf('data_paper/evaluation_times/global_swarmulator/timelog_%d.txt',n_agents(i));
    fileID = fopen(name{i},'r');
    times{i} = fscanf(fileID, '%d');
    mt(i) = mean(times{i});
    vt(i) = var(times{i});
end
plot(mt)
