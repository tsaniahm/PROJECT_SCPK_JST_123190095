clc; clear; close all;
 
folder = 'Citra uji';
filenames = dir(fullfile(folder, '*.jpg'));
images_total = numel(filenames);
 
test_input = zeros(6,images_total);
 
for n = 1:images_total
    full_name= fullfile(folder, filenames(n).name);
    Img = imread(full_name);
    Img = im2double(Img);
     
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
     
    Red = mean2(R);
    Green = mean2(G);
    Blue = mean2(B);
     
    % Ekstraksi Ciri Tekstur Filter Gabor
    I = (rgb2gray(Img));
    wavelength = 4;
    orientation = 90;
    [mag,phase] = imgaborfilt(I,wavelength,orientation);
     
    H = imhist(mag)';
    H = H/sum(H);
    I = (0:255)/255;
     
    Mean = mean2(mag);
    Entropy = -H*log2(H+eps)';
    Varian = (I-Mean).^2*H';
     
    % Pembentukan data uji
    test_input(1,n) = Red;
    test_input(2,n) = Green;
    test_input(3,n) = Blue;
    test_input(4,n) = Mean;
    test_input(5,n) = Entropy;
    test_input(6,n) = Varian;
end
 
% Pembentukan target uji
test_target = ones(1,images_total);
test_target(1:images_total/2) = 0;

load net
result = round(sim(net,test_input))
 
[m,n] = find(result==test_target);
accuracy = sum(m)/images_total*100