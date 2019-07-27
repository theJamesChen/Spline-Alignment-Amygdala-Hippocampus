function l = read_txt_landmarks(filename)

% open the file
fid = fopen(filename,'rt');

% you can ignore the first line (size of data) because matlab get's it
% automatically
line = fgetl(fid);

% read the data
l = reshape( fscanf(fid,'%f %f %f\n') , 3, [])';

% close the file
fclose(fid);