% calibration
clear all         % clears all variables from workspace
close all         % closes all figures
clc               % clears the command window


mypi=raspi;       % sets up the Raspberry Pi object
mask=uint8(zeros(1080, 1920,3)); % creates a black mask image with the size 1080x1920x3

% Draws red lines onto the mask image to indicate a scale 
mask(600:1080,639:641,1)=256;
mask(600:1080,719:721,1)=256;
mask(600:1080,799:801,1)=256;
mask(600:1080,879:881,1)=256;
mask(600:1080,959:961,1)=256;
mask(600:1080,1039:1041,1)=256;
mask(600:1080,1119:1121,1)=256;
mask(600:1080,1199:1201,1)=256;

% Sets up the camera board object with a resolution of 1920x1080 and a frame rate of 90 frames per second
cam=cameraboard(mypi, 'Resolution', '1920x1080','FrameRate',90)

% Continuously captures images from the camera and displays them with the mask applied
while 1
    image = snapshot(cam) + mask;
    imshow(image);
end


% image acqusition
clear all         % clears all variables from workspace
close all         % closes all figures
clc               % clears the command window

mypi=raspi;       % sets up the Raspberry Pi object

% Sets up the camera board object with a resolution of 1920x1080 and a frame rate of 90 frames per second
cam=cameraboard(mypi, 'Resolution', '1920x1080', 'FrameRate', 90)

% Displays a warning dialog to prompt the user to start recording calibration images
waitfor(warndlg('Calibration images are captured!'))

% Captures 10 calibration images and converts them to grayscale
for i=1:10
    cal=rgb2gray(snapshot(cam));
end

% Displays the last calibration image and prompts the user to select a region of interest
imshow(cal)
rectangle=drawrectangle('Label', 'ROI');
%Save corner positions of the selected area
p_horiz1=rectangle.Vertices(1);
p_horiz2=rectangle.Vertices(3);
p_verti1=rectangle.Vertices(5);
p_verti2=rectangle.Vertices(6);
close

% Displays a warning dialog to prompt the user to turn on the transducer
waitfor(warndlg('Turn on the Transducer!'))

% Continuously captures images from the camera and calculates the schlieren effect using the selected region of interest
x=1;
while 1
    image=rgb2gray(snapshot(cam));
    schliere=cal(p_verti1:p_verti2, p_horiz1:p_horiz2)-image(p_verti1:p_verti2, p_horiz1:p_horiz2);
    minimum=min(schliere, [], 'all');
    maximum=max(schliere, [], 'all');
    schliere=(schliere-minimum)*(((2^8)-1)/(maximum-minimum));
    aufnahme(:,:,x)=schliere;
    x=x