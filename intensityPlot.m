%% creates an intensity profile from image I
%% centered at position (xo,yo), along angle a
%% through a distance 2l (in nm), px is the pixel size in nm
%% bin is the number of bins along the segment 2l
%% (ideally, bin should be odd)
%% outputs are: x=x values for intensity plot (in pixels)
%% [xi,yi] is the segment on which the intensity profile is measured
%% Profile is a vector with the intensity values at each x value

function [xi,yi,x,Profile]=intensityPlot(I,xo,yo,a,l,bin,px)

C=[];
Profile=[];


xi=[(xo-(l/px)*cos(a)) (xo+(l/px)*cos(a))];
yi=[(yo-(l/px)*sin(a)) (yo+(l/px)*sin(a))];
     
    c=improfile(I,xi,yi,bin);
        
cmax=nanmax(c); 
cmin=nanmin(nonzeros(c));

%Profile=(c-cmin)/(cmax-cmin); 
Profile=c;

 x=-1*l:2*l/(bin-1):l;