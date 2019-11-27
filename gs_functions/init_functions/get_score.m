function [link_list, score] = get_score(L, nagents)
%For a given pattern, it returns the local states that are desired, and also returns the value of all states.
%
% Mario Coppola, 2018

% All numbers that can be made with a byte, hence all combinations
link_list = dec2bin(1:255, 8) - '0';

score = zeros(1, size(link_list, 1));
for i = 1:size(link_list, 1)
    for j = 1:size(L, 1)
        s = 8 - sum(xor(link_list(i, :), L(j, :)));
        if s > score(i)
            score(i) = s; % Store maximum score
        end
    end
end
if nargin > 1
    del = sum(link_list, 2) > nagents - 1;
    link_list(del, :) = [];
    score(del) = [];
end

end
