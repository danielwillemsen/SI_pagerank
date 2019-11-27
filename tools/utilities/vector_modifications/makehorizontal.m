function [ varargout ] = makehorizontal( varargin )
%makehorizontal Takes in vectors as arguments and ensures that they are all
%horizontal, otherwise it turns them around
%
% Developed by Mario Coppola, October 2015

if nargout > nargin
    error('Make sure number of function inputs matches number of function outputs')
end

varargout = varargin;

for i = 1:nargin
    
    if any(size(varargin{i})==1) % Only vectors
        if size(varargin{i},1) ~= 1
            varargout{i} = varargin{i}';
        else varargout{i} = varargin{i};
        end
    end
    
end

end