%% Script to analyze the results of the consensus task optimization
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2018

%% Initialize
init;

%% Set up input variables
datafolder = 'data_paper/consensus/'; % Where the final data will be stored
n_exp = 5;
save_figures = 1;
klist = 2:3;
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};

%%
%%%%%%%%%%%%%%%%%%%%%%%
%      CONSENSUS      %
%%%%%%%%%%%%%%%%%%%%%%%
fprintf('---- Starting Evaluation of Consensus task ---- \n');

%% Data evolution
% clear data_consensus_m2_evolutions data_consensus_m3_evolutions
data_consensus_m2_evolutions = cell(1,n_exp);
data_consensus_m3_evolutions = cell(1,n_exp);
nagents = [5 10 20];

fprintf('Loading evolution data\n');
for i = 1:n_exp
    fname_m2 = dir([datafolder,'evolutions_backup/consensus_m2_',num2str(i),'_*.mat']);
    fname_m3 = dir([datafolder,'evolutions_backup/consensus_m3_',num2str(i),'_*.mat']);
    data_consensus_m2_evolutions{i} = load(fname_m2.name);
    data_consensus_m3_evolutions{i} = load(fname_m3.name);
end

fprintf('Plotting evolution data\n');
plot_evolution(12,data_consensus_m2_evolutions,'data_consensus_m2_evolutions');
plot_evolution(13,data_consensus_m3_evolutions,'data_consensus_m3_evolutions');


%% Performance m = 2
fprintf('Plotting performance data for m = 2\n');
data_consensus_m2_baseline = load([datafolder,'evaluations/consensus_m2_baseline_5_10_20.mat']);
data_consensus_m2_results = load([datafolder,'evaluations/consensus_m2_results_5_10_20.mat']);
param = {'Normalization', 'probability'};
for kk = klist
    newfigure(kk+30,'',['consensus2_results_',num2str(nagents(kk))]);
    [ht, edges] = histcounts(data_consensus_m2_baseline.stats{kk}.n_steps, param{:});
    h0 = stairs(edges,[ht,0],'--');
    h0.Color = color{1};
    h0.LineWidth = 2;
    hold on
    for i = 1:5
        [ht, edges] = histcounts(data_consensus_m2_results.stats{i,kk}.n_steps, param{:});
        h{i} = stairs(edges,[ht,0]);
        h{i}.Color = color{i + 1};
    end
    hold off;
    
    hlegend = legend('$\mathrm{\Pi}_0$',...
        '$\mathrm{\Pi}_1^{(E1)}$',...
        '$\mathrm{\Pi}_1^{(E2)}$',...
        '$\mathrm{\Pi}_1^{(E3)}$',...
        '$\mathrm{\Pi}_1^{(E4)}$',...
        '$\mathrm{\Pi}_1^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    
    xlabel('Actions to completion');
    ylabel('Probability [-]');
end

%% Performance m = 3
fprintf('Plotting performance data for m = 3\n');
data_consensus_m3_baseline = load([datafolder,'evaluations/consensus_m3_baseline_5_10_20.mat']);
data_consensus_m3_results = load([datafolder,'evaluations/consensus_m3_results_5_10_20.mat']);
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
param = {'Normalization', 'probability'};
for kk = klist
    newfigure(kk+40,'',['consensus3_results_',num2str(nagents(kk))]);
    [ht, edges] = histcounts(data_consensus_m3_baseline.stats{kk}.n_steps, param{:});
    h0 = stairs(edges,[ht,0],'--');
    h0.Color = color{1};
    h0.LineWidth = 2;
    hold on
    for i = 1:5
        [ht, edges] = histcounts(data_consensus_m3_results.stats{i,kk}.n_steps, param{:});
        h{i} = stairs(edges,[ht,0]);
        h{i}.Color = color{i + 1};
        hold on
    end
    
    hold off;
    
    hlegend = legend('$\mathrm{\Pi}_0$',...
        '$\mathrm{\Pi}_1^{(E1)}$',...
        '$\mathrm{\Pi}_1^{(E2)}$',...
        '$\mathrm{\Pi}_1^{(E3)}$',...
        '$\mathrm{\Pi}_1^{(E4)}$',...
        '$\mathrm{\Pi}_1^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    xlabel('Actions to completion');
    ylabel('Probability [-]');
end

%%
%%%%%%%%%%%%%%%%%%%%%%%
%   CONSENSUS BINARY  %
%%%%%%%%%%%%%%%%%%%%%%%
fprintf('---- Starting Evaluation of Consensus task (binary variant) ---- \n');

%% Data evolution
data_consensus_binary_m2_evolutions = cell(1,n_exp);
nagents = [5 10 20];

fprintf('Loading evolution data\n');
for i = 1:n_exp
    fname_m2 = dir([datafolder,'evolutions/consensus_binary_m2_p0.3_',num2str(i),'_*.mat']);
    data_consensus_binary_m2_evolutions{i} = load(fname_m2.name);
end

fprintf('Plotting evolution data\n');
plot_evolution(11,data_consensus_binary_m2_evolutions,'data_consensus_binary_m2_evolutions');

%% Performance m = 2
fprintf('Plotting performance data for m = 2\n');
data_consensus_binary_m2_baseline = load([datafolder,'evaluations/consensus_binary_m2_baseline_5_10_20.mat']);
data_consensus_binary_m2_results = load([datafolder,'evaluations/consensus_binary_m2_p0.3_results_5_10_20.mat']);
param = {'Normalization', 'probability'};
for kk = klist
    newfigure(kk+20,'',['consensus_binary2_p0.3_results_',num2str(nagents(kk))]);

    [ht, edges] = histcounts(data_consensus_binary_m2_baseline.stats{kk}.n_steps, param{:});
    h0 = stairs(edges,[ht,0],'--');
    h0.Color = color{1};
    h0.LineWidth = 2;
    hold on
    for i = 1:5
        [ht, edges] = histcounts(data_consensus_binary_m2_results.stats{i,kk}.n_steps, param{:});
        h{i} = stairs(edges,[ht,0]);
        h{i}.Color = color{i + 1};
        hold on
    end
    
    hold off;
    
    hlegend = legend('$\mathrm{\Pi}_0$',...
        '$\mathrm{\Pi}_1^{(E1)}$',...
        '$\mathrm{\Pi}_1^{(E2)}$',...
        '$\mathrm{\Pi}_1^{(E3)}$',...
        '$\mathrm{\Pi}_1^{(E4)}$',...
        '$\mathrm{\Pi}_1^{(E5)}$',...
        'Location','NorthOutside','Orientation','Horizontal');
    hlegend.NumColumns = 4;

    xlabel('Actions to completion');
    ylabel('Probability [-]');
end

%% Save all figures
if save_figures
    fignums = [30:10:40]+klist';
    latex_printallfigures(get(0, 'Children'), '', 'paper_wide_half_toplegend', [12:13, fignums(:)']);

    fignums = 20+klist';
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [11, fignums(:)']);
end

%% Policy analysis m2
% pp = cell(1,5)
% for i = 1:5
%     pp{i} = [double(data_consensus_m2_evolutions{i}.s.states), data_consensus_m2_evolutions{i}.Q1];
%     [~,mm_p] = max(data_consensus_m2_evolutions{i}.Q1,[],2);
%     [~,mm_n] = max(data_consensus_m2_evolutions{i}.s.states(:,2:3),[],2);
%     del1 = data_consensus_m2_evolutions{i}.s.des;
%     del2 = find(pp{i}(:,2) == pp{i}(:,3));
%     del = union(del1,del2);
%     mm_p(del) = [];
%     mm_n(del) = [];
%     newfigure(i);plot(mm_n); hold on; plot(mm_p,'--');
% end
% 
% %% Policy analysis m3
% pp = cell(1,5)
% for i = 1
%     pp{i} = [double(data_consensus_m3_evolutions{i}.s.states), data_consensus_m3_evolutions{i}.Q1];
%     [~,mm_p] = max(data_consensus_m3_evolutions{i}.Q1,[],2);
%     [~,mm_n] = max(data_consensus_m3_evolutions{i}.s.states(:,2:4),[],2);
%     del1 = data_consensus_m3_evolutions{i}.s.des;
%     del2 = find(pp{i}(:,2) == pp{i}(:,3));
%     del3 = find(pp{i}(:,3) == pp{i}(:,4));
%     del4 = find(pp{i}(:,2) == pp{i}(:,4));
% 
%     del = unique([del1';del2;del3;del4]);
%     mm_p(del) = [];
%     mm_n(del) = [];
%     newfigure(i);plot(mm_n); hold on; plot(mm_p,'--');
%     pp_r{i} = pp{i};
%     pp_r{i}(del,:) = [];
% end


%% Performance m = 2
fprintf('Plotting performance data for m = 2\n');
data_consensus_m2_results = load([datafolder,'evaluations/consensus_m2_results_5_10_20.mat']);
data_consensus_binary_m2_results = load([datafolder,'evaluations/consensus_binary_m2_p0.3_results_5_10_20.mat']);
param = {'Normalization', 'probability'};
data = zeros(3,5,2);
for kk = 1:3
    newfigure(kk+86,'',['consensus2_results_',num2str(nagents(kk))]);
    hold on
    for i = 1:5
        [ht, edges] = histcounts(data_consensus_m2_results.stats{i,kk}.n_steps, param{:});
        data(kk,i,1) = mean(data_consensus_m2_results.stats{i,kk}.n_steps);
        h{i} = stairs(edges,[ht,0]);
        [ht, edges] = histcounts(data_consensus_binary_m2_results.stats{i,kk}.n_steps, param{:});
        data(kk,i,2) = mean(data_consensus_binary_m2_results.stats{i,kk}.n_steps);
        b{i} = stairs(edges,[ht,0],'--');
        h{i}.Color = 'r';
        b{i}.Color = 'k';
    end
    hold off;
    legend('Ordinary','Binary')
    xlabel('Actions to completion');
    ylabel('Probability [-]');
end
%% Policy comparisons

newfigure(2,'','policycomparison')
for i = 1:5
loglog(nagents,data(:,i,1),'k-o');
hold on
loglog(nagents,data(:,i,2),'r--o');
end
hold off
xlim([0 20])
ylabel('Mean cumulative actions to completion')
xlabel('Number of robots')
hlegend = legend('With neighborhood knowledge','Binary variant','Location','NorthOutside','Orientation','Horizontal');
hlegend.NumColumns =1;
grid on
grid minor

% 
newfigure(3,'','policycomparison_peragent')
for i = 1:5
plot(nagents,data(:,i,1)./nagents','k-o');
hold on
plot(nagents,data(:,i,2)./nagents','r--o');
end
hold off
xlim([0 20])
ylabel('Mean actions to completion per robot')
xlabel('Number of robots')
hlegend = legend('With neighborhood knowledge','Binary variant','Location','NorthOutside','Orientation','Horizontal');
hlegend.NumColumns =1;
grid on
grid minor

% Save all figures
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_square_fourth', [2, 3]);
end
