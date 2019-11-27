%% Script to analyze the results of the consensus task optimization
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Bootstrap phase 1 pattern formation
datafolder = 'data_paper/patternformation/'; % Where the final data will be stored
fprintf('Bootstrap Phase 1 pattern formation...');
pattern_list = {'triangle4','hexagon','triangle9','T'};
Hp10 = zeros(4,5);
Hp10_var = Hp10;
for i = 1:numel(pattern_list)
    pattern_name = pattern_list{i};
    pe_q = load([datafolder, 'performance_evaluation/stats_q_', pattern_name], 'evo_q');
    if strcmp(pattern_name, 'triangle4') || ...
            strcmp(pattern_name, 'hexagon') || ...
            strcmp(pattern_name, 'triangle9')
        data_bl = load([datafolder, 'baseline/data_baseline.mat']);
        if i == 1
            tt = 1;
        elseif i == 2
            tt = 3;
        elseif i == 3
            tt = 2;
        end
    elseif strcmp(pattern_name, 'T')
        data_bl = load([datafolder, 'baseline/T.mat']);
        tt = 1;
    end
    
    for j = 1:numel(pe_q.evo_q)
        x1 = data_bl.stats{tt}.n_steps;
        x2 = pe_q.evo_q{j}.stats.n_steps;
        Hp10(i,j) = bootstrap_mean(x1,x2,0);
        Hp10_var(i,j) = bootstrap_var(x1,x2,0);
    end
    
end
if all(Hp10(:)) && all(Hp10_var(:))
    fprintf(' Pass\n')
elseHp21
    fprintf(' Fail\n')
    Hp10
end


%% Bootstrap phase 2 pattern formation to original
datafolder = 'data_paper/patternformation/'; % Where the final data will be stored
fprintf('Bootstrap Phase 2 pattern formation vs original...');
pattern_list = {'triangle4','hexagon','triangle9','T'};
Hp20 = zeros(4,5);
Hp20_var = Hp20;
for i = 1:numel(pattern_list)
    pattern_name = pattern_list{i};
    pe_q = load([datafolder, 'performance_evaluation/stats_p_', pattern_name], 'evo_p');
    if strcmp(pattern_name, 'triangle4') || ...
            strcmp(pattern_name, 'hexagon') || ...
            strcmp(pattern_name, 'triangle9')
        data_bl = load([datafolder, 'baseline/data_baseline.mat']);
        if i == 1
            tt = 1;
        elseif i == 2
            tt = 3;
        elseif i == 3
            tt = 2;
        end
    elseif strcmp(pattern_name, 'T')
        data_bl = load([datafolder, 'baseline/T.mat']);
        tt = 1;
    end
    for j = 1:numel(pe_q.evo_p)
        x1 = data_bl.stats{tt}.n_steps;
        x2 = pe_q.evo_p{j}.stats.n_steps;
        x2(x2==inf) = []; % remove
        Hp20(i,j) = bootstrap_mean(x1,x2,0);
        Hp20_var(i,j) = bootstrap_var(x1,x2,0);
    end
    
end
if all(Hp20(:)) && all(Hp20_var(:))
    fprintf(' Pass\n')
else
    fprintf(' Fail\n')
    Hp20
end


%% Bootstrap phase 2 pattern formation to phase 1
datafolder = 'data_paper/patternformation/'; % Where the final data will be stored
fprintf('Bootstrap Phase 2 pattern formation vs Phase 1...');
pattern_list = {'triangle4','hexagon','triangle9','T'};
Hp21 = zeros(4,5);
Hp21_var = Hp21;

for i = 1:numel(pattern_list)
    pattern_name = pattern_list{i};
    pe_q = load([datafolder, 'performance_evaluation/stats_q_', pattern_name], 'evo_q');
    pe_p = load([datafolder, 'performance_evaluation/stats_p_', pattern_name], 'evo_p');
   
    for j = 1:numel(pe_p.evo_p)
        x1 = pe_q.evo_q{j}.stats.n_steps;
        x2 = pe_p.evo_p{j}.stats.n_steps;
        x2(x2==inf) = []; % remove
        Hp21(i,j) = bootstrap_mean(x1,x2,0);
        Hp21_var(i,j) = bootstrap_var(x1,x2,0);
    end
    
end
if all(Hp21(:)) && all(Hp21_var(:))
    fprintf(' Pass\n')
else
    fprintf(' Fail\n')
    Hp21
end

%% Bootstrap consensus m = 2
datafolder = 'data_paper/consensus/'; % Where the final data will be stored

fprintf('Bootstrap consensus m = 2...');
data_consensus_m2_baseline = load([datafolder,'evaluations/consensus_m2_baseline_5_10_20.mat']);
data_consensus_m2_results = load([datafolder,'evaluations/consensus_m2_results_5_10_20.mat']);
nagents = [5 10 20];
Hm2 = zeros(3,5);
Hm2_var = Hm2;
for i = 1:numel(nagents)
    for j = 1:5
        x1 = data_consensus_m2_baseline.stats{i}.n_steps;
        x2 = data_consensus_m2_results.stats{j,i}.n_steps;
        Hm2(i,j) = bootstrap_mean(x1,x2,0);
        Hm2_var(i,j) = bootstrap_var(x1,x2,0);
    end
end
if all(Hm2(:)) && all (Hm2_var(:))
    fprintf(' Pass\n')
else
    fprintf(' Fail\n')
    Hm2
end

%% Bootstrap consensus m = 3
fprintf('Bootstrap consensus m = 3...');
data_consensus_m3_baseline = load([datafolder,'evaluations/consensus_m3_baseline_5_10_20.mat']);
data_consensus_m3_results = load([datafolder,'evaluations/consensus_m3_results_5_10_20.mat']);
nagents = [5 10 20];
Hm3 = zeros(3,5);
Hm3_var = Hm3;
for i = 1:numel(nagents)
    for j = 1:5
        x1 = data_consensus_m3_baseline.stats{i}.n_steps;
        x2 = data_consensus_m3_results.stats{j,i}.n_steps;
        Hm3(i,j) = bootstrap_mean(x1,x2,0);
        Hm3_var(i,j) = bootstrap_var(x1,x2,0);
    end
end
if all(Hm3(:)) && all(Hm3_var(:))
    fprintf(' Pass\n')
else
    fprintf(' Fail\n')
    Hm3
end
%% Bootstrap consensus (binary variant) m = 2
fprintf('Bootstrap consensus (binary variant) m = 2...');
data_consensus_binary_m2_baseline = load([datafolder,'evaluations/consensus_binary_m2_baseline_5_10_20.mat']);
data_consensus_binary_m2_results = load([datafolder,'evaluations/consensus_binary_m2_p0.3_results_5_10_20.mat']);
nagents = [5 10 20];
Hm2_bin = zeros(3,5);
Hm2_bin_var = Hm2_bin;
for i = 1:numel(nagents)
    for j = 1:5
        x1 = data_consensus_binary_m2_baseline.stats{i}.n_steps;
        x2 = data_consensus_binary_m2_results.stats{j,i}.n_steps;
        Hm2_bin(i,j) = bootstrap_mean(x1,x2,0);
        Hm2_bin_var(i,j) = bootstrap_var(x1,x2,0);
    end
end
if all(Hm2_bin(:)) && all(Hm2_bin_var(:))
    fprintf(' Pass\n')
else
    fprintf(' Fail\n')
    Hm2_bin
end
