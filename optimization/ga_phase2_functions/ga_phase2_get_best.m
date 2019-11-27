function Qopt = ga_phase2_get_best(populationhistory, Q, mode, Qidx, n)
% ga_phase2_get_best extracts the most fit Policy for a Phase 2 evolution
% Note: the last generation will always have the best performing member because we carry the elite.
%
% Mario Coppola, 2018

if strcmp(mode, 'max')
    [~, bestelement_index] = max(populationhistory{end}.score);
elseif strcmp(mode, 'min')
    [~, bestelement_index] = min(populationhistory{end}.score);
end

if nargin < 5
    n = numel(populationhistory);
end

best_probabilities = populationhistory{n}.population(bestelement_index, :);
Qopt = double(Q);
Qopt(Qidx) = best_probabilities;

end
