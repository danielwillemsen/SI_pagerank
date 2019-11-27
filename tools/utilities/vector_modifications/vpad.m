function y = vpad(vec, vector_length, pad_start, paddingnumber)
% Adds zero after the vector until a certain length is reached
%
% Developed by Mario Coppola, April 2015

if nargin < 3
    pad_start = 1;
    paddingnumber = 0;
end

y = vec;

if size(vec,1) == 1 % vertical
y = zeros(1,vector_length);
elseif size(vec,2) == 1 % horizontal
y = zeros(vector_length,1);
end

if nargin > 3
    if size(paddingnumber) == 1
        y = y + paddingnumber;
    else
        if length(paddingnumber) ~= vector_length
            error('You are padding with a vector but the size does not match the final desired size!');
        end
        y = paddingnumber;
    end
        
end

y(pad_start:(pad_start+length(vec)-1)) = vec;
