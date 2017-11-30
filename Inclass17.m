%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 
%% IMPORT FILES

%GB comments
1. 100
2. 100
overall 100


img1= imread('img1.tif');
img2=imread('img2.tif');
imshow(imadjust(img1));
figure; imshow(imadjust(img2));

%% PIXEL VALUE METHOD
diffs = zeros(100,100); 
for ov1 = 1:200
    for ov2 = 1:200
        
    pix1 =img1 ((end-ov1):end,(end-ov2):end);
    pix2 = img2(1:(1+ov1),1:(1+ov2)); 
    
    diffs(ov1,ov2) = sum(sum(abs(pix1-pix2)))/(ov1*ov2);
    
    %diffs(ov1) = sum(sum(abs(pix1-pix2)))/ov1;
    end
    
end 
figure; plot(diffs); 
minMatrix = min(diffs(:));
%find right overlap value
[overlapx, overlapy] = find(diffs ==minMatrix);
%199 looks promising
overlapx = 199;
overlapy = 199;
img2_align = [zeros(800, size(img2,2) - overlapy+1), img2];
img2_align = [zeros(size(img2,1)-overlapx+1, size(img2_align,2)) ; img2_align]
imshowpair(img1, img2_align); 
% OMG this worked!

%%FOURIER TRANSFORM
img1ft = fft2(img1); img2ft = fft2(img2); 
[nr, nc] = size(img2ft);
CC = ifft2(img1ft.*conj(img2ft));
CCabs = abs(CC);
figure; imshow(CCabs, []); 

[row_shift, col_shift] = find(CCabs == max(CCabs(:)));
Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1); 
Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
row_shift = Nr(row_shift);
col_shift = Nc(col_shift); 
img_shift = zeros(size(img2)+[row_shift,col_shift]);
%x1 = size(img2,1);
%x2 = size(img2,2);
imshift = [zeros(size(img2,1), size(img2,2) - col_shift), img2];
imshift = [zeros(size(img1,1) - row_shift, size(imshift,2)); imshift];
figure
imshowpair(img1, imshift)
% The code fails. 


