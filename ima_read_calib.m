% images_read : indicator of current readed image.

if ~exist('calib_name', 'var') || ~exist('format_image', 'var')
   data_calib;
   return;
end;

if ~exist('n_ima', 'var')
   check_directory;
   return;
end;

if n_ima ~= 0
    if ~exist('active_images', 'var')
        active_images = ones(1, n_ima);
    end;
    n_act = length(active_images);
    if n_act < n_ima
        active_images = [active_images ones(1,n_ima-n_act)];
    else
        if n_act > n_ima
            active_images = active_images(1:n_ima);
        end;
    end;
    
    ind_active = find(active_images);
    
    if prod(double(active_images == 0))
        disp('Error: There is no active image. Run Add/Suppress images to add images');
        return
    end;
    
    if exist('center_optim')
        center_optim = double(center_optim);
    end;
    if exist('est_alpha')
        est_alpha = double(est_alpha);
    end;
    if exist('est_dist')
        est_dist = double(est_dist);
    end;
    if exist('est_fc')
        est_fc = double(est_fc);
    end;
    if exist('est_aspect_ratio')
        est_aspect_ratio = double(est_aspect_ratio);
    end;
end;

images_read = active_images;

if exist('image_numbers', 'var')
   first_num = image_numbers(1);
end;

% Just to fix a minor bug:
if ~exist('first_num', 'var')
   first_num = image_numbers(1);
end;

image_numbers = first_num:n_ima-1+first_num;

no_image_file = 0;

i = 1;

while (i <= n_ima) % & (~no_image_file),
   if active_images(i)
       fprintf(1, 'Loading image %d...\n', i);
   
   if ~type_numbering
       number_ext = num2str(image_numbers(i));
   else
       number_ext = sprintf(['%.' num2str(N_slots) 'd'], image_numbers(i));
   end;
   	
   ima_name = [calib_name number_ext '.' format_image];
      
   if strcmp(format_image, 'pgm')
       Ii = double( loadpgm(ima_name) );
   elseif strcmp(format_image, 'ppm')
       Ii = double( loadppm(ima_name) );
   elseif strcmp(format_image, 'ras')
       Ii = readras(ima_name);
   else % png jpg
       Ii = double(imread(ima_name));
   end;

   if size(Ii, 3) > 1
       Ii = 0.299 * Ii(:,:,1) + 0.5870 * Ii(:,:,2) + 0.114 * Ii(:,:,3);
   end;
   
   eval(['I_' num2str(i) ' = Ii;']);
         
   else
       images_read(i) = 0;
   end;
   
   i = i+1;   
end;

ind_read = find(images_read);

if isempty(ind_read)
   fprintf(1,'\nWARNING! No image were read\n');
   no_image_file = 1;  
else
   fprintf(1,'\n');
   
   if size(I_1, 1) ~= 480
       small_calib_image = 1;
   else
       small_calib_image = 0;
   end;
   % size of the calibration image
   [Hcal, Wcal] = size(I_1);
   
   [ny, nx] = size(I_1);
   
   clickname = [];
   
   map = gray(256);
   disp('done');
end;

active_images = images_read;
