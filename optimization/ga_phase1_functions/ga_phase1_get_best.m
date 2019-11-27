function best = ga_phase1_get_best(populationhistory, mode, n)
% ga_phase1_get_best extracts the most fit genome for a Phase 1 evolution
% Note: the last generation will always have the best performing member because we carry the elite.
%
% Mario Coppola, 2018

if strcmp(mode, 'max')
    [~, bestelement_index] = max(populationhistory{end}.score);
elseif strcmp(mode, 'min')
    [~, bestelement_index] = min(populationhistory{end}.score);
end

if nargin < 3
    n = numel(populationhistory);
end

best = populationhistory{n}.Q{bestelement_index};

end
