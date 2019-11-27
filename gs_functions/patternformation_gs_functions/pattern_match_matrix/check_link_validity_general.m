function [valid] = check_link_validity_general(Li, Lj, d, varargin)

active = checkifparameterpresent(varargin, 'active', ones(size(Li)), 'number');

da = @(x, y)desired_and_active(x, active, y);
tln = @(d1, d2)test_link_neighborhood(Li, Lj, active, d1, d2);
valid = 0;

if da(Li, d) && da(Lj, d + 4) % Links are active and desired, or inactive
    if ~check_iseven(d) %% Horizontal/Vertical link
        if tln(d + 1, d + 4 - 2) && tln(d - 1, d + 4 + 2) && tln(d + 2, d + 4 - 1) && tln(d - 2, d + 4 + 1)
            valid = 1;
        end
    else % Diagonal link
        if tln(d + 1, d + 4 - 1) && tln(d - 1, d + 4 + 1)
            valid = 1;
        end
    end
end

end
