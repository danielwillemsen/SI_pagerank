function out = desired_and_active(link,active,d)
wps = @(x)wraptosequence(x, [1 length(active)]);
% out = (and(link(wps(d)),active(wps(d))) || ~active(wps(d)) );
out = and(link(wps(d)),active(wps(d)));
end