clc
clear all
close all
img = imread('https://media.istockphoto.com/id/153091999/photo/x-ray-image-of-a-broken-lower-leg-isolated-on-black.jpg?s=612x612&w=0&k=20&c=2AY3G7j9BNkKZ_-X8As3Y6oJeOVm8gLKtJTS7iY0f7c=');
threshold = 100; 
binaryImg = img > threshold;
se = strel('disk', 5); 
binaryImg = imopen(binaryImg, se); 
bwLabel = bwlabel(binaryImg);
regionProps = regionprops(bwLabel, 'Area', 'Centroid', 'Orientation', 'MajorAxisLength', 'MinorAxisLength');
[~, idx] = max([regionProps.Area]);
centroid = regionProps(idx).Centroid;
orientation = regionProps(idx).Orientation;
majorAxis = regionProps(idx).MajorAxisLength / 2;
minorAxis = regionProps(idx).MinorAxisLength / 2;
t = linspace(0, 2 * pi, 100);
x = centroid(1) + majorAxis * cos(t);
y = centroid(2) + minorAxis * sin(t);
markedImg = img;
ellipseCoords = [x', y'];
markedImg = insertShape(markedImg, 'Polygon', ellipseCoords, 'LineWidth', 2, 'Color', 'red');
figure;
imshow(markedImg);
title('Broken Area Marked');