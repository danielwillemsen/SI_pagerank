function [fitness, proof_outcome, c, tgs1, tgs1_a, tgs2, tgs3, gs1] = fitness_pattern_phase1(Q, s)
% fitness_pattern_phase1 tests the constraints elaborated in Phase 1.
% If the tests are successful and the constraints are respected,
% then the PageRank fitness is evaluated.
%
% Mario Coppola, 2018

fitness = inf; % Initialize fitness
proof_outcome = 0; % Initialize pass

% Define set of states that are active, static, and blocked
s.active = find(any(Q, 2));
s.static = s.states(~ any(Q, 2));
s.blocked = s.static(~ ismember(s.static, s.des));

% In the following routine, we check whether any new static states exist.
% If this is the case, then we also check whether it is possible to have them, according to the method in Appendix A
as = intersect(s.active, s.simplicial);
[to_exclude, ~] = find(and(sum(s.link_list, 2) == 7, any(s.link_list(:, [1, 3, 5, 7]) == 0, 2))); % states that locally become loops, which will collapse, but not captured here.
as(ismember(as, to_exclude)) = [];
staticcandidates = setdiff(s.static, s.static_0);
if ~ isempty(intersect(as, staticcandidates))
    return;
elseif ~ isempty(staticcandidates)
    pm_red = s.pm(staticcandidates, s.static); % direction_matrix
    pass = 0;
    while ~ all(pass)
        pass = zeros(1, numel(staticcandidates));
        for i = 1:numel(staticcandidates)
            dirscovered = unique(cell2mat(pm_red(i, :)));
            dirsneeded = find(s.link_list(staticcandidates(i), :));
            check = ismember(dirsneeded, dirscovered);
            if any(check == 0) % state unfulfilled by static neighors
                s.static = unique([s.static staticcandidates(i)]);
                staticcandidates(i) = [];
                pm_red = s.pm(staticcandidates, s.static);
                break;
            else
                c = 0; gs1 = 0; tgs1 = 0; tgs1_a = 0; tgs2 = 0; tgs3 = 0;
                pass(i) = 1; % Cannot be added to static
                return;
            end
        end
    end
else
    pass = zeros(1, numel(staticcandidates));
end

[proof_outcome, tgs1, tgs1_a, tgs2, tgs3] = localproof (Q, s);

% If the proof failed failed, just exit with all 0
if ~ proof_outcome
    c = 0; gs1 = 0; tgs1 = 0; tgs1_a = 0; tgs2 = 0; tgs3 = 0;
    return;
end

% Calculate fitness
[fitness, c, gs1] = fitness_pattern_centrality(Q, s, tgs1, tgs1_a, tgs2, tgs3);

end
