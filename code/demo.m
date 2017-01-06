output_dir_root = '../results';
output_dir1 = strcat(output_dir_root, '/image1');
output_dir2 = strcat(output_dir_root, '/image2');

[stat, mess] = rmdir(output_dir_root,'s');
mkdir(output_dir_root);
mkdir(output_dir1);
mkdir(output_dir2);

image1 = '../dataset/001/L/S1001L01.jpg';
image2 = '../dataset/002/L/S1002L02r.jpg';

[iris1, mask1] = iris(image1, output_dir1);
[iris2, mask2] = iris(image2, output_dir2);

dist = smallest_distance(iris1, iris2, mask1, mask2)
