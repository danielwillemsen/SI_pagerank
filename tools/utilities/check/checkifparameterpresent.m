function [ y ] = checkifparameterpresent(cellarray,name,default,type)
% checkifparameterpresent Checks if a parameter has been specified when
% calling a function. This function is to be used inside other functions,
% it acts as a parser to know what variables have been specified.
% Example usage:
% 
% title = checkifparameterpresent(varargin,'Title','defaulttitle','string')
%
% It basically looks at all cells within varargin to find one that has
% "Title" in it, after which the next cell will be the title. If that is
% not found, then 'defaulttitle' will be used. If something is found but it
% is not a string, it will return an error.
% You can check whether inputs are 'string', 'number', or 'array'
% 
% Mario Coppola, 2016

b = find(ismember(cellarray(1:2:end),name));
if ~isempty(b)
    
    if strcmp(type,'string')
        if ischar(cellarray{2*b})
            y = cellarray{2*b};
        else
            error('Specified input must be of correct type')
        end
    
    elseif strcmp(type,'number') || strcmp(type,'array')
        if isnumeric(cellarray{2*b})
            y = cellarray{2*b};
        else
            error('Specified input must be of correct type')
        end
    elseif strcmp(type,'cell')
        if iscell(cellarray{2*b})
            y = cellarray{2*b};
        else
            error('Specified input must be of correct type')
        end
    else
        error('Speficify a what type to expect')
    end
    
else
    y = default;
end

end

