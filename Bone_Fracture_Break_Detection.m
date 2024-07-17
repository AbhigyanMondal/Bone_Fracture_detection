addpath 'C:\Users\abhig\Downloads\'
img = imread('bone.jpg');

ImgBlurSigma = 2;
MinHoughPeakDistance = 5;
HoughConvolutionLength = 40;
HoughConvolutionDilate = 2;
BreakLineTolerance = 0.25;
breakPointDilate = 6;

img = (rgb2gray(img));
img = imfilter(img, fspecial('gaussian', 10, ImgBlurSigma), 'symmetric');

%canny edge detection
boneEdges = edge(img, 'canny');
boneEdges = bwmorph(boneEdges, 'close');
edgeRegs = regionprops(boneEdges, 'Area', 'PixelIdxList');
AreaList = sort(vertcat(edgeRegs.Area), 'descend');
edgeRegs(~ismember(vertcat(edgeRegs.Area), AreaList(1:2))) = [];
edgeImg = zeros(size(img, 1), size(img, 2));
edgeImg (vertcat(edgeRegs.PixelIdxList)) = 1;

[H, T, R ] = hough(edgeImg, 'RhoResolution',1,'Theta',-90:2:89.5);
maxHough = max(H, [], 1);
HoughThresh = (max(maxHough) - min(maxHough))/2 + min(maxHough);
[~, houghPeaks] = findpeaks(maxHough, 'MINPEAKHEIGHT', HoughThresh, 'MinPeakDistance', MinHoughPeakDistance);

figure(1)
plot(T, maxHough);
hold on
plot([min(T) max(T)], [HoughThresh, HoughThresh], 'r');
plot(T(houghPeaks), maxHough(houghPeaks), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
hold off
xlabel('Theta Value');
ylabel('Max Hough Transform');
legend({'Max Hough Transform', 'Hough Peak Threshold', 'Detected Peak'});

if numel(houghPeaks) > 1
    BreakStack = zeros(size(img, 1), size(img, 2), numel(houghPeaks));
    for m=1:numel(houghPeaks);
    brImg = abs(diff(BreakStack, 1, 3)) < BreakLineTolerance*max(BreakStack(:)) & edgeImg > 0;
    [BpY, BpX] = find(abs(diff(BreakStack, 1, 3)) < BreakLineTolerance*max(BreakStack(:)) & edgeImg > 0 );
    brImg = bwmorph(brImg, 'dilate', breakPointDilate);
    brReg = regionprops(brImg, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'Centroid');
    brReg(vertcat(brReg.Area) ~= max(vertcat(brReg.Area))) = [];

    brReg.EllipseCoords = zeros(100, 2);
    t = linspace(0, 2*pi, 100);
    brReg.EllipseCoords(:,1) = brReg.Centroid(1) + brReg.MajorAxisLength/2*cos(t - brReg.Orientation);
    brReg.EllipseCoords(:,2) = brReg.Centroid(2) + brReg.MinorAxisLength/2*sin(t - brReg.Orientation); 
    end
 
else
  brReg = [];

end

figure(2)
imshow(img)
