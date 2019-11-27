function out = test_link_neighborhood(Li, Lj, active, d1, d2)
wps = @(x)wraptosequence(x, [1 length(active)]);
out = ((not(xor(Li(wps(d1)), Lj(wps(d2)))) && all(active(wps([d1, d2])))) || ...
	any(~ active(wps([d1, d2]))));
end



