function show_window(cell_list, title_figure, x_size, y_size, ... 
                        gap_x, font_name, font_size)

if ~exist('cell_list', 'var')
    error('No description of the functions');
end;

if ~exist('title_figure', 'var')
    title_figure = 'Camera Calibration Toolbox';
end;

if ~exist('x_size', 'var')
    x_size = 85;
end;
if ~exist('y_size', 'var')
    y_size = 14;
end;
if ~exist('gap_x', 'var')
    gap_x = 0;
end;
if ~exist('font_name', 'var')
    font_name = 'clean';
end;
if ~exist('font_size', 'var')
    font_size = 8;
end;

figure(1);
% set to points before getting position
set(1, 'Units', 'Points');
pos = get(1, 'Position');

[n_row, n_col] = size(cell_list);

fig_size_x = x_size*n_col+(n_col+1)*gap_x;
fig_size_y = y_size*n_row+(n_row+1)*gap_x;

pos(1)=pos(1)+round(pos(3)/2)-round(fig_size_x/2);
pos(2)=pos(2)+round(pos(4)/2)-round(fig_size_y/2);

set(1, 'Units','points', ...
	'BackingStore','off', ...
	'Color',[0.8 0.8 0.8], ...
	'MenuBar','none', ...
	'Resize','off', ...
	'Name',title_figure, ...
'Position',[pos(1) pos(2) fig_size_x fig_size_y], ...
'NumberTitle','off'); %,'WindowButtonMotionFcn',['figure(' num2str(fig_number) ');']);

h_mat = zeros(n_row,n_col);

posx = zeros(n_row,n_col);
posy = zeros(n_row,n_col);

for i=n_row:-1:1
   for j = n_col:-1:1
      posx(i,j) = gap_x+(j-1)*(x_size+gap_x);
      posy(i,j) = fig_size_y - i*(gap_x+y_size);
   end;
end;

for i=n_row:-1:1
    for j = n_col:-1:1
        if ~isempty(cell_list{i,j})
            if ~isempty(cell_list{i,j}{1}) && ~isempty(cell_list{i,j}{2})
                h_mat(i,j) = uicontrol('Parent',1 , ...
                    'Units','points', ...
                    'Callback',cell_list{i,j}{2}, ...
                    'ListboxTop',0, ...
                    'Position',[posx(i,j)  posy(i,j)  x_size   y_size], ...
                    'String',cell_list{i,j}{1}, ...
                    'fontsize',font_size,...
                    'fontname',font_name,...
                    'Tag','Pushbutton1');
            end;
        end;
    end;
end;

%------ END PROTECTED REGION ----------------%
