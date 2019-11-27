function log = readlogs(files, columns)
%readlogs reads a series of logs from a folder

for i = 1:size(files,1)
    filename = [files(i).folder,'/',files(i).name];
    fileID   = fopen(filename,'r');
    if fileID ~= -1
        log{i} = fscanf(fileID,'%f',[columns Inf])';
        if isempty(log{i})
            error(['File ',filename, 'is empty']);
        end
    else
        error(['File ',filename, 'not found']);
    end
end

end