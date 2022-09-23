% K-means clustering on the two input images (car.ppm and flower.png) for K = 3 clusters.
close all;
car=imread("car.ppm");                       %Image read
figure('name','Car');
imshow(car);                                 %image display
flower=imread("flower.png");                 %Image read
figure('name','Flower');
imshow(flower);                              %image display
%%%K-means clustering with Given initial cluster means%%%
%Initializing cluster means%
C1init=[255 0 0];
C2init=[0 0 0];
C3init=[255 255 255];
%Finding the Kmeans clusters and mean
[C1Group,C2Group,C3Group,C1,C2,C3]=FindKmeans(car,C1init,C2init,C3init,5);
%visualize the output of k-means clustering, replace
%each pixels in the input image with the cluster center it belongs
CarKmeans=VisualizeImage(car,C1Group,C2Group,C3Group,C1,C2,C3);
figure('name','Car Kmeans with given cluster mean');
imshow(uint8(CarKmeans));                       %Image Display
%Finding the Kmeans clusters and mean
[C1Group,C2Group,C3Group,C1init,C2init,C3init]=FindKmeans(flower,C1init,C2init,C3init,5);
%visualize the output of k-means clustering, replace
%each pixels in the input image with the cluster center it belongs
FlowerKmeans=VisualizeImage(flower,C1Group,C2Group,C3Group,C1init,C2init,C3init);
figure('name','Flower Kmeans with given cluster mean');
imshow(uint8(FlowerKmeans));                    %Image Display
%%%Initializing variable to store
%%%30 cost and outputs
[row,col,d]=size(car);
CarRandomKmeans=zeros(row,col,d,30);
[row,col,d]=size(flower);
flowerRandomKmeans=zeros(row,col,d,30);
DistCar=zeros(1,30);
Distflower=zeros(1,30);
%%%K-means clustering using random initialization of cluster means%%

for i=1:30
%random initialization of cluster means  
C1init=randi([0 255],1,3);
C2init=randi([0 255],1,3);
C3init=randi([0 255],1,3);
%Finding the Kmeans clusters and mean car.ppm
[C1Group,C2Group,C3Group,C1,C2,C3]=FindKmeans(car,C1init,C2init,C3init,5);
%visualize the output of k-means clustering, replace
%each pixels in the input image with the cluster center it belongs
CarRandomKmeans(:,:,:,i)=VisualizeImage(car,C1Group,C2Group,C3Group,C1,C2,C3);
%Finding cost corresponding to the output of k-means clustering
DistCar(i)=sum((CarRandomKmeans(:,:,:,i) - double(car)) .^ 2,'all');
%Finding the Kmeans clusters and mean for flower.png
[C1Group,C2Group,C3Group,C1,C2,C3]=FindKmeans(flower,C1init,C2init,C3init,5);
%visualize the output of k-means clustering, replace
%each pixels in the input image with the cluster center it belongs
flowerRandomKmeans(:,:,:,i)=VisualizeImage(flower,C1Group,C2Group,C3Group,C1,C2,C3);
%Finding cost corresponding to the output of k-means clustering
Distflower(i)=sum((flowerRandomKmeans(:,:,:,i) - double(flower)) .^ 2,'all');
end
% finding the output corresponding to the lowest Cost for flower
[M,I]=min(Distflower);
figure('name','Flower Min C value Kmeans');
imshow(uint8(flowerRandomKmeans(:,:,:,I)));
% finding the output corresponding to the Highest Cost for flower
[M,I]=max(Distflower);
figure('name','Flower Max C value Kmeans');
imshow(uint8(flowerRandomKmeans(:,:,:,I)));
% finding the output corresponding to the lowest Cost for Car
[M,I]=min(DistCar);
figure('name','Car Min C value Kmeans');
imshow(uint8(CarRandomKmeans(:,:,:,I)));
% finding the output corresponding to the Highest Cost for car
[M,I]=max(DistCar);
figure('name','Car Max C value Kmeans');
imshow(uint8(CarRandomKmeans(:,:,:,I)));







function KmeanOut=VisualizeImage(Image,C1Group,C2Group,C3Group,C1init,C2init,C3init)
KmeanOut=zeros(size(Image));
%%%replacing each pixels in the input image with the cluster center it belongs to
[m,l]=size(C1Group); %Finding the number of elements in the group
for i=1:l
    KmeanOut(C1Group(1,i),C1Group(2,i),:)=C1init;
end
[m,l]=size(C2Group); %Finding the number of elements in the group
for i=1:l
    KmeanOut(C2Group(1,i),C2Group(2,i),:)=C2init;
end
[m,l]=size(C3Group); %Finding the number of elements in the group
for i=1:l
    KmeanOut(C3Group(1,i),C3Group(2,i),:)=C3init;
end
end

function [C1Group,C2Group,C3Group,C1init,C2init,C3init]=FindKmeans(Image,C1init,C2init,C3init,iter)
[row,col,d]=size(Image);
for iteration=1:iter
    %declaring variable to store the cluster cordinates
    C1Group=[];
    C2Group=[];
    C3Group=[];
    %declaring variable to store the number of pixels in each cluster 
    numberOfGrp1=0;
    numberOfGrp2=0;
    numberOfGrp3=0;
    for i=1:row
        for j=1:col
        %Finding the Euclidean distance
         Xi=double([Image(i,j,1),Image(i,j,2),Image(i,j,3)]);
         Dist1=sum((Xi - C1init) .^ 2);
         Dist2=sum((Xi - C2init) .^ 2);
         Dist3=sum((Xi - C3init) .^ 2);
         %finding the minimum distance and grouping
         if(Dist1==min([Dist1,Dist2,Dist3]))
            numberOfGrp1 = numberOfGrp1 + 1;
            C1Group(1,numberOfGrp1)=i;
            C1Group(2,numberOfGrp1)=j;
  
         end
         if(Dist2==min([Dist1,Dist2,Dist3]))
            numberOfGrp2 = numberOfGrp2 + 1;
            C2Group(1,numberOfGrp2)=i;
            C2Group(2,numberOfGrp2)=j;
         end
        if(Dist3==min([Dist1,Dist2,Dist3]))
            numberOfGrp3 = numberOfGrp3 + 1;
            C3Group(1,numberOfGrp3)=i;
            C3Group(2,numberOfGrp3)=j;
            
        end
        end
    end
%Finding the cluster mean
% if any cluster turned out to be empty, use only the non-empty clusters

if size(C1Group)==0
    C1init=[0,0,0];
else
    C1init=FindMeanValues(Image,C1Group);
end
    
if size(C2Group)==0
    C2init=[0,0,0];
else
    C2init=FindMeanValues(Image,C2Group);
end
    
if size(C3Group)==0
    C3init=[0,0,0];
else
    C3init=FindMeanValues(Image,C3Group);
end

end
end

%Function to find the mean of cluster
function meanValue=FindMeanValues(Image,Group)

M1=mean(Image(Group(1,:),Group(2,:),1),'all');
M2=mean(Image(Group(1,:),Group(2,:),2),'all');
M3=mean(Image(Group(1,:),Group(2,:),3),'all');
meanValue=[M1,M2,M3];
end
      
        
        
