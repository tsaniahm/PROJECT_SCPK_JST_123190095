clc; clear; close all; warning off all;
 
folder = 'Citra latih';
filenames = dir(fullfile(folder, '*.jpg'));
images_total = numel(filenames);
 
train_input = zeros(6,images_total);
 
for i = 1:images_total
    full_name= fullfile(folder, filenames(i).name);
    Img = imread(full_name);
    Img = im2double(Img);
     
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
     
    Red = mean2(R);
    Geen = mean2(G);
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
     
    % Pembentukan data latih
    train_input(1,i) = Red;
    train_input(2,i) = Geen;
    train_input(3,i) = Blue;
    train_input(4,i) = Mean;
    train_input(5,i) = Entropy;
    train_input(6,i) = Varian;
end

% Pembentukan target latih
train_target = ones(1,images_total);
train_target(1:images_total/2) = 0;

% Pembentukan neural network dan training
net = newp(train_input,train_target);
[net,tr,E] = train(net,train_input,train_target);
 
save net net
 
% Hasil identifikasi
result = round(sim(net,train_input))
[m,i] = find(result==train_target);
accuracy = sum(m)/images_total*100