function time = get_endtime(log, time_column)
%get_endtime Extract the final time from a log, for a specified column
%
% Mario Coppola, 2018

time = zeros(1,numel(log));
for i = 1:numel(log)
    time(i) = log{i}(end,time_column);
end

end

