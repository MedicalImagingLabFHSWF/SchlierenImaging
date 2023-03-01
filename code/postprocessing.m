clear all
close all
clc
pic=imread("../resources/test_2.png");

BW = imbinarize(im2gray(pic));
% Get rid of white border
BWConv = bwconvhull(~BW);
BW = BW & BWConv;
% get region centers and major axis, and orientation
stats = regionprops('table',BW,'BoundingBox');
% Compute length/width ratio
stats.LenWdRatio = stats.BoundingBox(:,3) ./ stats.BoundingBox(:,4);
% Set threshold and determine which objects
% are greater than the threshold. 
thresh = 0.7;%round(mean(stats.LenWdRatio)); 
stats.isGreater = stats.LenWdRatio > thresh; 
% Show bounding box for objects that met the threshold

figure()
h = imshow(BW); 
axis on
hold on
% Plot red rectangles around accepted objects
%arrayfun(@(i)rectangle('Position',stats.BoundingBox(i,:),'EdgeColor','r'), find(stats.isGreater)); 
% Plot yellow rectangles around rejected objects
arrayfun(@(i)rectangle('Position',stats.BoundingBox(i,:),'EdgeColor','black','FaceColor','black'), find(~stats.isGreater));
xlabel('colum')
ylabel('row')
%https://de.mathworks.com/matlabcentral/answers/486087-remove-specific-objects-from-an-image
%(modified)
