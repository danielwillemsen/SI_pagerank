function [selected] = rand_from_vector(vector, n_elements, probabilities)

if nargin < 2
    n_elements = 1;
end

if nargin == 3 && sum(probabilities)==1
    p = cumsum([0; probabilities(1:end-1).'; 1+1e3*eps]);
    [~,a] = histc(rand,p);
    selected = vector(a);
else
    if length(vector) > 1
        selected = randsample(vector, n_elements);
    else
        selected = vector;
    end
end

end