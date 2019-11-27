%% Script to analyze the results of the evolutions using PageRank for the aggregation task
%
% Used in the paper:
% "The PageRank Algorithm as a Method to Optimize Swarm Behavior through Local Analysis"
% Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.
%
% Mario Coppola, 2019

init;

%%
clc
p1 = 0.3:0.1:1.0;
p2 = 0.3:0.1:1.0;
aw = 30;
c = permn(p1,2);

nruns = 50;
nagents = 10;
fileID = fopen('../phdwork/swarmulator/script.sh','w');
makeline = 'make clean && make -j ';
for i = 1:numel(aw)
    for j = 1:size(c,1)
        fprintf(fileID,makeline);
        fprintf(fileID,'IP1=%2.2f IP2=%2.2f IAW=%i\n',c(j,1),c(j,2),aw(i));
        fprintf(fileID,'cd scripts \n');
        fprintf(fileID,'./run_n_simulations.sh %d %d \n',nruns,nagents);
        fprintf(fileID,'cd ../logs \n');
        fprintf(fileID,'mv batchtest* aggregation_log_%2.2f_%2.2f_%d\n',c(j,1),c(j,2),aw(i));
        fprintf(fileID,'cd .. \n');
    end
end
fclose(fileID);
disp('Done')