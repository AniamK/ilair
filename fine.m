function [center,radius] = fine(imageData)
%clear;
%clc;
%imageData = imread('./image/R.jpg');
%imshow(imageData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% fill NIR
%imageData = imcomplement(imageData);
%imageData = imfill(imageData,'holes');
%imageData = imcomplement(imageData);
%imshow(imageData);% show image after fill NIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ci,cp,out] = thresh(imageData,110,160);
imshow(out);
center = [ci(1),ci(2)];
radius = ci(3);
end