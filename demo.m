close all;
[iris1,mask1] = iris('data/001/R/S1001R01.jpg');
[iris2,mask2] = iris('data/001/R/S1001R07.jpg');

%save('codes.mat','iris1','iris2','mask1','mask2')
%load('codes.mat')

dist = smallest_distance(iris1,iris2,mask1,mask2)
