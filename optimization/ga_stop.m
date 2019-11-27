function stop_flag = ga_stop(generation,generations_max)
% ga_stop holds the relevant implementation for the stop criteria of the ga.
% In our case, we just stop at a chosen generation. 
%
% Mario Coppola, 2018

stop_flag = 0;
if generation >= generations_max
    stop_flag = 1;
    fprintf('\nStop criteria reached.\n')
end

end
