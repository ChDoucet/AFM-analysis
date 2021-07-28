% This script is an adaptation from the script I initially wrote to analyze
% STED images. Pixel sizes (px) and height color scale (zscale) have to be manually
% entered before running the program.


close all
clear all
clc

ScriptFolder = '/Users/christine/Documents/Git/AFM-analysis' ;

%% Get titles and define parameters

cd('/Users/christine/Documents/Data/AFM/Full NPC databank/raw_data')
conditions = {'1um';'1.5um';'2um';'2.5um';'3um';'4um'};

px=7.81;                  % pixel size in nm
L=251;                  % size of the ROI in nm
l=round(L/px)/2;
zscale = 150/255;         % conversion from grey levels to nm

for k=3:3
    folder=conditions{k};
    [num,txt,raw]=xlsread('FileProperties.xlsx',folder);
    n=length(txt);
    
    NPC_Profile=[];
cd('/Users/christine/Documents/Data/AFM/Full NPC databank/2um/2um_crop2')


mkdir('bin20_Flatten')
    for i=1:n
        i
        cd('/Users/christine/Documents/Data/AFM/Full NPC databank/2um/2um_crop2')
        name=txt{i}
        
        I=zscale.*double(imread(strcat(name, '_crop.tif')));
        
        cd(ScriptFolder)
        [XYZ_array_1] = ImageFlatteningFuncs.Matrix_to_Nx3array(I);

    % for plane fitting, take the top 50% of the data
    BinWidth_nm = 0.1; % the smaller the value the more accurate the XYZ indexing. 0.1nm should be fine.
    Plane_fit_mask_1 = 0.50;
    greater_than_1   = 1;
    % create new XYZ array of only bottom 50% of data
    [XYZ_array_for_plane_fit_1, ~] = ImageFlatteningFuncs.XYZarray_indexed_by_percentage_height(XYZ_array_1, BinWidth_nm, Plane_fit_mask_1, greater_than_1);

    % find the plane of the indexed bottom 50% of height data
    [plane_1] = ImageFlatteningFuncs.PlaneFit_XYZarray(I, XYZ_array_for_plane_fit_1);
    % subtract plane from data. This operation also brings the rim of the
    % pore to height_rim_pore_nm (usually set to 35 nm).
    height_rim_pore_nm = 35;
    Iflat = (I - plane_1) + height_rim_pore_nm;
        
        cd(ScriptFolder)
        
        % define parameters
        w=round(L/2);
        bin=25;             % binning of the intensity profile
        
        NPC_Prof=[];
        
        xo=l+1; yo=l+1;
        
        
        figure(i)
        subplot(2,2,1)
        imshow(I)
        hold on
        plot(xo,yo,'.r')
        hold off
        
        subplot(2,2,3)
        imshow(I)
        
        
        b=0;
        for a=0:pi/20:39*pi/20      %
            b=b+1;
            [xi,yi,x,Profile_a1]=intensityPlot(Iflat,xo,yo,a,w,bin,px);
            
            NPC_Prof=[NPC_Prof; Profile_a1'];
            
            
            cmap=jet(40);
            
            figure(i)
            subplot(2,2,3)
            hold on
            plot(xi,yi,'Color',cmap(b,:))
            hold off
            
            subplot(2,2,[2,4])
            hold on
            plot(x,Profile_a1','Color',cmap(b,:));
            hold off
            %}
            
        end
        
        NPC_Profile_j=nanmean(NPC_Prof);
        
        figure(i)
        subplot(2,2,[2,4])
        hold on
        plot(x,NPC_Profile_j,'Color','k','LineWidth',2)
        hold off
        
        cd('/Users/christine/Documents/Data/AFM/Full NPC databank/2um/2um_crop2/bin20_Flatten')
        saveas(gca,strcat('2um_',num2str(i),'_2pi.fig'),'fig');
        saveas(gca,strcat('2um_',num2str(i),'_2pi.tif'),'tiff');
        saveas(gca,strcat('2um_',num2str(i),'_2pi.jpg'),'jpeg')
        close
        
        %}
        
        figure(n+1)
        hold on
        plot(x,NPC_Profile_j)
        hold off
        
        NPC_Profile=[NPC_Profile; NPC_Profile_j];
    end
    
    mean_Profile=nanmean(NPC_Profile);
    std_Profile=nanstd(NPC_Profile);
    
    figure(n+1)
    hold on
    plot(x,mean_Profile,'Color','k','LineWidth',2)
    hold off
    
    cd('/Users/christine/Documents/Data/AFM/Full NPC databank/2um/2um_crop2/bin20_Flatten')
    saveas(gca,'2um_NPCs_2pi.tif','tiff');
    saveas(gca,'2um_NPCs_2pi.jpg','jpeg');
    
    T=table(NPC_Profile);
    writetable(T, 'NPC_Profiles_2um_2pi.txt');
    MP=table(mean_Profile);
    writetable(MP,'Mean_NPC_2um_2pi.txt');
    
    SP=table(std_Profile);
    writetable(SP,'Std_NPC_2um_2pi.txt')
    
    X=table(x);
    writetable(X,'ProfileCoordinates_2pi.txt')
    
    
    
    
end

