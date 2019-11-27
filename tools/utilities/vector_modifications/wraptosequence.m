function [ x ] = wraptosequence( x, n )

while any(x > max(n))
    overflowpositions = x > max(n);
    x = x - overflowpositions * max(n);
end

while any(x < min(n))
    overflowpositions = x < min(n);
    x = x + overflowpositions * max(n);
end

end

