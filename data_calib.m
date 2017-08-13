%% This script alets the user enter the name of the images 
% base name, numbering scheme,...
% Checks that there are some images in the directory:

l_bmp = dir('*bmp');
s_bmp = size(l_bmp,1);
l_tif = dir('*tif');
s_tif = size(l_tif,1);
l_pgm = dir('*pgm');
s_pgm = size(l_pgm,1);
l_ppm = dir('*ppm');
s_ppm = size(l_ppm,1);
l_jpg = dir('*jpg');
s_jpg = size(l_jpg,1);
l_jpeg = dir('*jpeg');
s_jpeg = size(l_jpeg,1);
l_png = dir('*png');
s_png = size(l_png,1);

s_tot = s_bmp + s_tif + s_pgm + s_jpg + s_ppm + s_jpeg + s_png;

if s_tot < 1
   fprintf(1, 'No image in this directory in either, bmp, tif, pgm, ppm, png or jpg format. Change directory and try again.\n');
   return;
end;


% IF yes, display the directory content:
dir;

Nima_valid = 0;

while (Nima_valid==0)
    calib_name = input('Basename camera calibration images (without number nor suffix): ','s');
    format_image = '0';
    while format_image == '0'
        format_image = input('Image format: (b=bmp, p=pgm, j=jpg, m=ppm, n=png) ', 's');
   
        switch lower(format_image(1))
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
                disp('Invalid image format');
                format_image = '0'; 
            % Ask for format once again
        end;
   end;
   check_directory;
end;

if (Nima_valid~=0)
    % Reading images
    ima_read_calib; 
    % may be launched from the toolbox itself
    % Show all the calibration images:
    
    if ~isempty(ind_read)    
        mosaic;
    end;
end;

