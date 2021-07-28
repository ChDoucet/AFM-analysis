%%% This script is a test to planefit crops from AFM images.
% This is inspired from George Stanley program, available on Github. This
% was published (Life Science Alliances, 2019).
% 

clear all
close all
clc

%%%=== Load folder
InputFolder         ='/Users/christine/Documents/Data/AFM/Full NPC databank/2um/2um_crop2';

%%%=== Scripts folder
ScriptFolder        = '/Users/christine/Documents/Git/AFM-analysis' ;

%%%=== Input image
name                ='2020-06-19-15h10-O_2um.tiff_crop';

%%%=== Enter crop size and radial bin sizes ===%%%
CropSize_px         = 33 ;
w = round(CropSize_px/2) + 1 ;
CropSize_nm         = 250 ;       % usually go 200 nm for NPCs
zscale              = 150/255 ;      % converts grey level into height (in nm)

%%%=== Load image
cd(InputFolder)
I=imread(strcat(name,'.tif'));
Im=zscale.*double(I);



%% with the cropped image, planefit the top of the pore and bring to
    % 40nm (such that all pores are at the same height for rotational
    % averaging).
    
    cd(ScriptFolder)
    
    % transform to XYZ array for plane fitting
    [XYZ_array_1] = ImageFlatteningFuncs.Matrix_to_Nx3array(Im);

    % for plane fitting, take the top 50% of the data
    BinWidth_nm = 0.1; % the smaller the value the more accurate the XYZ indexing. 0.1nm should be fine.
    Plane_fit_mask_1 = 0.50;
    greater_than_1   = 1;
    % create new XYZ array of only bottom 50% of data
    [XYZ_array_for_plane_fit_1, ~] = ImageFlatteningFuncs.XYZarray_indexed_by_percentage_height(XYZ_array_1, BinWidth_nm, Plane_fit_mask_1, greater_than_1);

    % find the plane of the indexed bottom 50% of height data
    [plane_1] = ImageFlatteningFuncs.PlaneFit_XYZarray(Im, XYZ_array_for_plane_fit_1);
    % subtract plane from data. This operation also brings the rim of the
    % pore to height_rim_pore_nm (usually set to 35 nm).
    height_rim_pore_nm = 35;
    heightdata_cropped_nm = (Im - plane_1) + height_rim_pore_nm;
    
    
    %% Show effect of this operation
    x0=[1,CropSize_px]; y0=[w,w];
      
    figure
    subplot(2,2,1)
    imshow(Im)
    hold on
    plot(x0,y0,'--r')
    hold off
    
    
    subplot(2,2,2)
    imshow(mat2gray(heightdata_cropped_nm))
     hold on
    plot(x0,y0,'--r')
    hold off
    
    
    x=-16:16;
    y_original = improfile(Im, x0,y0);
    y_flatten = improfile(heightdata_cropped_nm,x0,y0);
    
    subplot(2,2,3)
    plot(x,y_original)
    
    subplot(2,2,4)
    plot(x,y_flatten)
    
    