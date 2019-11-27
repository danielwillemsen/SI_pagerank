function make_folder(data_write_folder)
% save_to_folder saves data to a folder and generates the folder if it doesn't exist
%
% Mario Coppola, 2019

if ~ exist(data_write_folder, 'dir')
    mkdir(data_write_folder);
end

end