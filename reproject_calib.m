%% Reproject the patterns on the images, and compute the pixel errors:
% Color code for each image:
colors = 'brgkcm';

if ~exist('n_ima','var') && ~exist('fc', 'var')
   fprintf(1,'No calibration data available.\n');
   return;
end;

if ~exist('nx', 'var') && ~exist('ny', 'var')
    fprintf(1,'WARNING: No image size (nx, ny) available.');
    return;
end;

%check_active_images;

if ~exist(['omc_' num2str(ind_active(1)) ], 'var')
   fprintf(1,'Need to calibrate or load Calib_Results.mat file before showing image reprojection\n');
   return;
end;


if ~exist(['I_' num2str(ind_active(1)) ]', 'var')
    n_ima_save = n_ima;
	active_images_save = active_images;
	ima_read_calib;
	n_ima = n_ima_save;
	active_images = active_images_save;
	check_active_images;
end;


if length(ind_active) > 1
   ima_numbers = input('Number(s) of image to show ([] = all images) = ');
else
   ima_numbers = [];
end;


if isempty(ima_numbers)
   ima_proc = 1:n_ima;
else
   ima_proc = ima_numbers;
end;


figure(5);
set(5, 'color',[1 1 1], 'Name', 'Reprojection error (in pixel)', ...
       'NumberTitle','off');


for kk = ima_proc %1:n_ima,
   if exist(['y_' num2str(kk)], 'var') && active_images(kk) ... 
           && eval(['~isnan(y_' num2str(kk) '(1,1))'])
       eval(['plot(ex_' num2str(kk) '(1, :), ex_' num2str(kk) '(2, :),''' colors(rem(kk-1,6)+1) '+'');']);
       hold on;
   end;
end;

hold off;
axis('equal');
xlabel('x');
ylabel('y');
drawnow;

no_grid = 0;

for kk = ima_proc
    if exist(['y_' num2str(kk)], 'var')
        if active_images(kk) && eval(['~isnan(y_' num2str(kk) '(1,1))'])
            
            if exist(['I_' num2str(kk)], 'var')
                eval(['I = I_' num2str(kk) ';']);
            else
                I = 255*ones(ny,nx);
            end;
            
            figure(5+kk);
            image(I);
            colormap(gray(256));
            hold on;
            
            if ~no_grid
                
                eval(['x_kk = x_' num2str(kk) ';']);
                
                N_kk = size(x_kk,2);
                
                if ~exist(['n_sq_x_' num2str(kk)], 'var') || ...
                   ~exist(['n_sq_y_' num2str(kk)], 'var')
                    no_grid = 1;
                end;
                
                if ~no_grid
                    eval(['n_sq_x = n_sq_x_' num2str(kk) ';']);
                    eval(['n_sq_y = n_sq_y_' num2str(kk) ';']);
                    if (N_kk ~= ((n_sq_x+1)*(n_sq_y+1)))
                        no_grid = 1;
                    end;
                end;
            end;
            
            if ~no_grid
                
                % plot more things on the figure (to help the user):
                Nx = n_sq_x+1;
                Ny = n_sq_y+1;
                
                ind_ori = (Ny - 1) * Nx + 1;
                ind_X = Nx*Ny;
                ind_Y = 1;
                ind_XY = Nx;
                
                xo = x_kk(1,ind_ori);
                yo = x_kk(2,ind_ori);
                
                xX = x_kk(1,ind_X);
                yX = x_kk(2,ind_X);
                
                xY = x_kk(1,ind_Y);
                yY = x_kk(2,ind_Y);
                
                xXY = x_kk(1,ind_XY);
                yXY = x_kk(2,ind_XY);
                
                uu = cross(cross([xo;yo;1],[xXY;yXY;1]),cross([xX;yX;1],[xY;yY;1]));
                xc = uu(1)/uu(3);
                yc = uu(2)/uu(3);                
                
                bbb = cross(cross([xo;yo;1],[xY;yY;1]),cross([xX;yX;1],[xXY;yXY;1]));
                uu = cross(cross([xo;yo;1],[xX;yX;1]),cross([xc;yc;1],bbb));
                xXc = uu(1)/uu(3);
                yXc = uu(2)/uu(3);
                
                bbb = cross(cross([xo;yo;1],[xX;yX;1]),cross([xY;yY;1],[xXY;yXY;1]));
                uu = cross(cross([xo;yo;1],[xY;yY;1]),cross([xc;yc;1],bbb));
                xYc = uu(1)/uu(3);
                yYc = uu(2)/uu(3);
                
                uX = [xXc - xc;yXc - yc];
                uY = [xYc - xc;yYc - yc];
                uO = [xo - xc;yo - yc];
                
                uX = uX / norm(uX);
                uY = uY / norm(uY);
                uO = uO / norm(uO);
                
                delta = 30;

                plot([xo;xX]+1,[yo;yX]+1,'g-','linewidth',2);
                plot([xo;xY]+1,[yo;yY]+1,'g-','linewidth',2);
                text(xXc + delta * uX(1) +1 ,yXc + delta * uX(2)+1,'X','color','g','Fontsize',14);
                text(xYc + delta * uY(1)+1 ,yYc + delta * uY(2)+1,'Y','color','g','Fontsize',14,'HorizontalAlignment','center');
                text(xo + delta * uO(1) +1,yo + delta * uO(2)+1,'O','color','g','Fontsize',14);

            end;

            
            %title(['Image ' num2str(kk) ' - Image points (+) and reprojected grid points (o)']);
            eval(['plot(x_' num2str(kk) '(1,:)+1,x_' num2str(kk) '(2,:)+1,''r+'');']);
            eval(['plot(y_' num2str(kk) '(1,:)+1,y_' num2str(kk) '(2,:)+1,''' colors(rem(kk-1,6)+1) 'o'');']);
            eval(['quiver(y_' num2str(kk) '(1,:)+1,y_' num2str(kk) '(2,:)+1,ex_' num2str(kk) '(1,:),ex_' num2str(kk) '(2,:),1,''' colors(rem(kk-1,6)+1) ''');']); 
            %zoom on;
            %axis([1 nx 1 ny]);
            hold off;
            %drawnow;
            set(5+kk,'color',[1 1 1]);
            set(5+kk,'Name',num2str(kk),'NumberTitle','off');
            axis normal
        end;
    end;
end;

err_std = std(ex')';
fprintf(1,'Pixel error: [%3.5f   %3.5f] (all active images)\n\n', err_std); 