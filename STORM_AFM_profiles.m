%% AFM STORM profiles analysis

% the aim of this script is to analyze and compare the basket height,
% measured by AFM, and Tpr signal, measured by dSTORM. This shouls help
% show the correlation between both.
% -----

clear all
close all
clc



% load and show images
cd('/Users/christine/Documents/Data/AFM/STORM-AFM_Tpr/Profiles')
name = 'qi2_NPC5'; 
afm = imread(strcat(name,'_afm.tif'));
fluo = imread(strcat(name,'_fluo.tif'));


% Manually define NPC center
figure
imshow(afm)

h=drawpoint;    
xo=h.Position(1); 
yo=h.Position(2);

close

% define length of profile, and binning
px=10;        % px size in nm
L=251;          % length of the profile
w=round(L/2); 
bin = 25;       % nb of points on the profile


% Choose angle for line drawing and show
alpha = 0;
[xi,yi,x,Profile_afm]=intensityPlot(afm,xo,yo,alpha,w,bin,px);
[xi,yi,x,Profile_fluo]=intensityPlot(fluo,xo,yo,alpha,w,bin,px);


figure 
subplot(1,3,1)
imshow(afm)
hold on
plot(xi,yi)
hold off

subplot(1,3,2)
imshow(fluo)
hold on
plot(xi,yi)
hold off

subplot(1,3,3)
plot(x,Profile_afm, 'k')
hold on
plot(x,Profile_fluo, 'g')
hold off


% save profiles and x
data=[x;Profile_afm';Profile_fluo'];
T=table(data);
writetable(T,strcat(name,'_xi',num2str(xi),'_yi',num2str(yi),'_alpha',num2str(alpha),'.txt'))

