close all;
palmleaf1=imread("palmleaf1.pgm"); %Image Read
figure('name','Palmleaf1');
imshow(palmleaf1);                 %Image display
OptimumThreshold1=FindOtsuThreshold(palmleaf1);%Finding the otsu threshold
fprintf("\n\nOtsu Threshold for Palmleaf1 :%d",OptimumThreshold1);
ThresholdedImage=palmleaf1>OptimumThreshold1;%Thresholding
figure('name','Palmleaf1 Thresholded');
imshow(ThresholdedImage);%Image display
palmleaf2=imread("palmleaf2.pgm"); %Image Read
figure('name','Palmleaf2');
imshow(palmleaf2);                 %Image display
OptimumThreshold=FindOtsuThreshold(palmleaf2);%Finding the otsu threshold
fprintf("\n\nOtsu Threshold for Palmleaf2 :%d",mean(OptimumThreshold));
ThresholdedImage2=palmleaf2>OptimumThreshold(2);%Thresholding
figure('name','Palmleaf2 Thresholded');
imshow(ThresholdedImage2);%Image display




%Function to find the class mean
function [mean,NumberofPixels]=FindClassMean(Histogram,tstart,tstop)
NumberofPixels=sum(Histogram(tstart+1:tstop+1));%Finding the number of pixels in the given intensity range
i=tstart:tstop;
%Finding their mean
mean=sum(i.*Histogram(i+1));
mean=mean/NumberofPixels;
end

%Function to find the inter class variance
function sigmaBsqr=FindInterClassVariance(Histogram,t,TotalPixels,TotalMean)
%Declaring variables to store class mean and number of pixels in class
Uj=zeros(2);
Nj=zeros(2);
%Finding first class mean and number of pixels 
[Uj(1),Nj(1)]=FindClassMean(Histogram,0,t);
%Finding second class mean and number of pixels 
[Uj(2),Nj(2)]=FindClassMean(Histogram,t+1,255);
%Finding the between class variance
sigmaBsqr=0;
for i=1:2
    sigmaBsqr=sigmaBsqr+((Uj(i)-TotalMean)^2)*Nj(i)/TotalPixels;
end
end
%Function to find otsu threshold
function OptimumThreshold=FindOtsuThreshold(Image)
F=histcounts(Image,256);%Finding the histogram of image
%Finding total mean and number of pixels
[TotalMean,NumberofPixels]=FindClassMean(F,0,255);
sigmaBsqr=zeros(1,256);
%looping over all intensity values to find optimum threshold
for i=1:256
    %Finding the interclass variance for corresponding threshold values
    sigmaBsqr(i)=FindInterClassVariance(F,i-1,NumberofPixels,TotalMean);
end
%Finding the optimum threshold value which maximizes
%inter class variance
OptimumThreshold=find(sigmaBsqr==max(sigmaBsqr));
end
