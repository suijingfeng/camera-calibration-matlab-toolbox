%% This script lets the user enter the name of the images base name, numbering scheme,...
% and looks in the direcory and checks if the images are there.
% (c) Jean-Yves Bouguet - Dec. 27th, 1999
% (c) Sui Jingfeng -Agu. 2nd, 2017

% calib_name: raw image name
% Nl : number of raw images
% length_name: length of prefix of raw image name
% l: list of image name
% Checks that there are some images in the directory:



haves = 0;

dir;


calib_name = input('Basename camera calibration images (without number nor suffix): ', 's');
if isempty(calib_name)
    calib_name = 'img';
end

format_image = input('Image format: (b=bmp, p=pgm, j=jpg, m=ppm, n=png) ', 's');
if isempty(format_image)
    format_image = 'png';
end

switch lower(format_image)
    case 'm'
        format_image = 'ppm';
    case 'b'
        format_image = 'bmp';
    case 'p'
        format_image = 'pgm';
    case 'j'
        format_image = 'jpg';
    case 'g'
        format_image = 'jpeg';
    case 'n'
        format_image = 'png';
    otherwise
        fprintf(2, '%s image format is not support.\n', format_image);
        return;
end


name_format = [calib_name '*' format_image];
l_pic = dir(name_format);

haves = size(l_pic, 1);
if haves < 1
    fprintf(2, 'No %s image in this directory, ', name_format);
    fprintf(2, 'Change directory and try again.\n');
end


%% checks if the 'calib_name-****.format_image' images are there.
ind_valid = [];
loc_extension = [];
length_name = size(calib_name, 2);
Nima_valid = 0; % is valid ?

for pp = 1:haves
    filenamepp = l_pic(pp).name;
    if isempty(calib_name)
        iii = 1;
    else
        iii = strfind(filenamepp, calib_name);
    end
    % get image extension and string number
    loc_ext = strfind(filenamepp, format_image);
    string_num = filenamepp(length_name+1 : loc_ext-2);

    if ~isempty(iii) && ~isempty(loc_ext)
        Nima_valid = Nima_valid + 1;
        ind_valid = [ind_valid pp];
        loc_extension = [loc_extension loc_ext];
    end
end

%%
if (Nima_valid > 0)
    % Get all the string numbers:    
    string_length = zeros(1, Nima_valid);
    indices =  zeros(1,Nima_valid);

    for ppp = 1:Nima_valid
        name = l_pic(ind_valid(ppp)).name;
        string_num = name(length_name+1:loc_extension(ppp) - 2);
        string_length(ppp) = size(string_num,2);
        indices(ppp) = str2num(string_num);
    end

    % Number of images...
    first_num = min(indices);
    n_ima = max(indices) - first_num + 1;

    if min(string_length) == max(string_length)
        N_slots = min(string_length);
        type_numbering = 1;    
    else      
        N_slots = 1;
        type_numbering = 0;       
    end
end  

image_numbers = first_num:n_ima-1+first_num;
%By default, all the images are active for calibration:
active_images = ones(1, n_ima);

% Reading images
ima_read_calib; 
    
% Show all the calibration images:
if ~isempty(ind_read)
    mosaic;
end

