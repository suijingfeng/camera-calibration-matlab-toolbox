%function calib_gui_normal,

cell_list = {};

%-------- Begin editable region -------------%

title_figure = 'Camera Calibration Toolbox';

clear fc cc kc KK;

kc = zeros(5, 1);
clearwin;

cell_list{1,1} = {'Read images', 'data_calib;'};
cell_list{1,2} = {'Extract grid corners', 'click_calib;'};
cell_list{1,3} = {'Calibration', 'go_calib_optim;'};
cell_list{1,4} = {'Show Extrinsic', 'ext_calib;'};
cell_list{2,1} = {'Reproject on images', 'reproject_calib;'};
cell_list{2,2} = {'Analyse error', 'analyse_error;'};
cell_list{2,3} = {'Recomp. corners', 'recomp_corner_calib;'};
cell_list{2,4} = {'Add/Suppress images', 'add_suppress;'};
cell_list{3,1} = {'Save', 'saving_calib;'};
cell_list{3,2} = {'Load', 'loading_calib;'};
cell_list{3,3} = {'Exit', 'disp(''Bye.''); close(1);'};
cell_list{3,4} = {'Comp. Extrinsic', 'extrinsic_computation;'};
cell_list{4,1} = {'Undistort image', 'undistort_image;'};
cell_list{4,2} = {'Export calib data', 'export_calib_data;'};
cell_list{4,3} = {'Show calib results', 'show_calib_results;'};
cell_list{4,4} = {'Smooth images','smooth_images;'};


show_window(cell_list, title_figure, 180, 20, 2, 'clean', 13);

%-------- End editable region -------------%

