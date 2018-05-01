function [center,radius] = findPupil(imageData)
% imageData is a iris image
% center
% radius

[rows, columns] = size(imageData);
for i=1:rows
    for j=1:columns
        if(imageData(i,j)>150)
            imageData(i,j) = 115;
        elseif(imageData(i,j)<100)
            imageData(i,j) = 50;
        else
            imageData(i,j)= 85;
        end
    end
end

imageData = imcomplement(imageData);
imageData = imfill(imageData,'holes');
imageData = imcomplement(imageData);

level =graythresh(imageData); % histogram analysis
imageData=im2bw(imageData, level);

Rmin = 30; %Define the radius range.
Rmax = 65; %Define the radius range.
[center, radius] = imfindcircles(imageData,[Rmin Rmax],'ObjectPolarity','dark');
%Find all the bright circles in the image within the radius range.
%Find all the dark circles in the image within the radius range.
end