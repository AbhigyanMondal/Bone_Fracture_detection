%input X-Ray Image
addpath 'C:\Users\abhig\Downloads\'
I = imread('bone.jpg');
%pre-processing
grayimage = rgb2gray(I);
ad = imadjust(grayimage);
filtered = imnoise(ad,'gaussian');
%Image Segmentation
%A strel object represents a flat morphological structure
SE = strel('disk',3);
erosion = imerode(filtered, SE);
%Erosion removes small objects, separates overlapping objects, and shrinks object boundaries, while dilation expands object boundaries, fills small gaps, and merges overlapping objects.
dilation = imdilate(filtered, SE);
diff = dilation-erosion;
gradient_image = filtered-diff;
SE2 = strel('diamond', 3);
new_dilation = imdilate(gradient_image, SE2);

handles.axes1 = axes;
axes(handles.axes1);
subplot(2,2,1)
imshow(I);
title('input images')
c = edge(new_dilation, 'sobel');
handles.axes2 = axes;
axes (handles.axes2);
subplot(2,2,2)
imshow(c);
title('sobel')

c2 = edge(new_dilation, 'prewitt');
handles.axes3 = axes;
axes (handles.axes3);
subplot(2,2,3)
imshow(c2);
title('prewitt')

c3 = edge(new_dilation, 'canny',0.2);

handles.axes4 = axes;
axes (handles.axes4);
subplot(2,2,4)
imshow(c3);
title('canny')


