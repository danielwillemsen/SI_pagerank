%% Script to analyze the results of the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

%% Initialize
init;

%% Parameters
data_read_folder = 'data_paper/evaluation_times/';
file_end_name = '_time_vect.mat';
save_figures = 1;

behaviors = {'aggregation','consensus_binary','patternformation_lineNE','patternformation'};
fignum = [1 2];
data = cell(1,numel(behaviors));
for i = 1:numel(behaviors)
    fprintf('Reading behavior %d: %s\n',i,behaviors{i});
    data{i} = load([data_read_folder,behaviors{i},file_end_name]);
end

%%
clear s se d dm ds
markers = {'s-','x-','o-','+-','^.'};
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
newfigure(fignum(1),'','evaluationtime_all');
for i = 1:3
    bname = [behaviors{i},'_time_vect'];
    d{i}=data{i}.(bname);
    
    ds{i}=std(d{i},1);
    dm{i}=mean(d{i},1);
    if i < 3
        for j = 1:numel( data{i}.s )
            s{i}(j) = size(data{i}.s{j}.gs1.Nodes,1); % Fix to this with new results
        end
    else
        s{i} = [36, 92, 162, 218, 246, 254, 255];
        s{i} = vpad(s{i},size(dm{i},2),1,255);
    end
    plot(s{i},dm{i},markers{i},'color',color{i},'Markersize',10)
    hold on
end

xlim([0 300])
ylim([0 0.35])
legend('Aggregation','Consensus (binary)', 'Pattern formation', 'Location', 'NorthWest')
xlabel('$|{\mathcal{S}}|$');
ylabel('$\bar{t}_{ev}$ [s]');

%% Pattern
clear s d dm ds
markers = {'s-','p','d','^','o'};
color = {[0 0 0], [1 0 0], [0 0.5 0], [0 0 1], [1 0.5 0], [0.75, 0, 0.75]};
newfigure(fignum(2),'','evaluationtime_patterns');
for i = 3:4     
    bname = [behaviors{i},'_time_vect'];
    d{i}=data{i}.(bname);
    
    ds{i}=std(d{i},1);
    dm{i}=mean(d{i},1);
    for j = 1:numel( data{i}.s )
        s{i}(j) = data{i}.s{j}.n_agents;
    end
    if i == 3
        plot(s{i},dm{i},markers{1},'color',color{1},'Markersize',10)
    elseif i == 4
        for j = 1:4
            h = scatter(s{i}(j),dm{i}(j),120,'filled','Marker',markers{1+j},'MarkerFaceColor',color{1+j});%,'Markersize',10);
        end
    end
    hold on
end

legend('Line','Triangle 4','Hexagon', 'Triangle 9', 'T','Location','SouthEast')
xlabel('Number of robots');
ylabel('$\bar{t}_{ev}$ [s]');

%%
if save_figures
    latex_printallfigures(get(0, 'Children'), '', 'paper_wide_half', fignum);
end