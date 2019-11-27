function H = bootstrap_var(x1,x2,makeplot)
%bootstrap_var runs a bootstrap test using the ratio in variances as the reference statistic
%
% Mario Coppola, 2019

n1 = length(x1);
n2 = length(x2);
nReps = 10000;
alpha = .05;        %alpha value

myStatistic = @(x1,x2) var(x1)/var(x2);
sampStat = myStatistic(x1,x2);
bootstrapStat = zeros(nReps,1);
for i=1:nReps
    sampX1 = x1(ceil(rand(n1,1)*n1));
    sampX2 = x2(ceil(rand(n2,1)*n2));
    bootstrapStat(i) = myStatistic(sampX1,sampX2);
end

CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);

%Hypothesis test: Does the confidence interval cover zero?
H = CI(1)>0 | CI(2)<0;

if makeplot
    newfigure(3)
    xx = min(bootstrapStat):.01:max(bootstrapStat);
    hist(bootstrapStat,xx);
    hold on
    ylim = get(gca,'YLim');
    plot(sampStat*[1,1],ylim,'y-','LineWidth',2);
    plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
    plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
    plot([0,0],ylim,'b-','LineWidth',2);
    xlabel('Difference between means');
end
end

