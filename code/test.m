function test()
  generate();
  same_person();
  different_person();
  evaluate();
end

% generates iris and mask codes from dataset
function generate()
  max_people = 2;
  max_images_per_person = 3;

  [stat, mess] = rmdir('../results','s');
  mkdir('../results');
  mkdir('../results/data');

  people = dir('../dataset');

  % '.' and '..' folders have to be excluded

  for i=3:min(size(people,1), max_people+2)
    person_dir = people(i,:).name;
    mkdir(strcat('../results/data/',person_dir));
    eyes = dir(strcat('../dataset/',person_dir));
    for j=3:size(eyes,1)
      eye_dir = strcat(person_dir,'/',eyes(j,:).name);
      mkdir(strcat('../results/data/',eye_dir));
      images = dir(strcat('../dataset/',eye_dir));

      if size(images,1) < 3
        continue;
      end

      for k=3:min(size(images,1)-1, max_images_per_person+2)
        image_dir = strcat(eye_dir,'/',images(k,:).name);
        output_dir = strcat('../results/data/',image_dir);
        output_dir = output_dir(1:size(output_dir,2)-4);
        mkdir(output_dir);
        image = strcat('../dataset/',image_dir);

        [iris_code, mask_code] = iris(image, output_dir);
        save(strcat(output_dir,'/iris.mat'), 'iris_code', 'mask_code');
      end
    end
  end
end

% compares irises of same person
function same_person()
  max_people = Inf;
  max_images_per_person = Inf;

  fileID = fopen('../results/same_person.txt','w');
  people = dir('../results/data/');
  for i=3:min(size(people,1), max_people+2)
    person_dir = people(i,:).name;
    eyes = dir(strcat('../results/data/',person_dir));
    for j=3:size(eyes,1)
      eye_dir = strcat(person_dir,'/',eyes(j,:).name);
      images = dir(strcat('../results/data/',eye_dir));
      if size(images,1) < 3
        continue;
      end

      image1 = images(3,:).name;
      load(strcat('../results/data/',eye_dir,'/',image1,'/iris.mat'));
      iris1 = iris_code;
      mask1 = mask_code;
      for k=3:min(size(images,1)-1, max_images_per_person+2)
        image2 = images(k+1,:).name;
        load(strcat('../results/data/',eye_dir,'/',image2,'/iris.mat'));
        iris2 = iris_code;
        mask2 = mask_code;

        dist = smallest_distance(iris1,iris2,mask1,mask2);
        fprintf(fileID,'%s %s %f\n',image1,image2,dist);

        image1 = image2;
        iris1 = iris2;
        mask1 = mask2;
      end
    end
  end
  fclose(fileID);
end

% compares irises of different people
function different_person()
  fileID = fopen('../results/different_person.txt','w');
  people = dir('../results/data');

  for i=3:size(people,1)-1
    person_dir = people(i,:).name;
    eyes = dir(strcat('../results/data/',person_dir));
    for j=3:size(eyes,1)
      eye_dir = strcat(person_dir,'/',eyes(j,:).name);
      image_files = dir(strcat('../results/data/',eye_dir));
      if size(image_files,1) < 3
        continue;
      end

      for k=3:size(image_files,1)
        image1 = image_files(k,:).name;
        load(strcat('../results/data/',eye_dir,'/',image1,'/iris.mat'));
        iris1 = iris_code;
        mask1 = mask_code;

        folder = strcat('../results/data/',people(i+1,:).name);
        [iris_codes,mask_codes,n,m,images] = get_person_irises(folder);

	for l=1:size(iris_codes,1)/n
	  image2 = images{l};
	  iris2 = iris_codes((l-1)*n+1:l*n,:);
	  mask2 = mask_codes((l-1)*m+1:l*m,:);
          dist = smallest_distance(iris1,iris2,iris1,mask2);
          fprintf(fileID,'%s %s %f\n',image1,image2,dist);
	end
      end
    end
  end
  fclose(fileID);
end

% folder - path to person data
% iris_codes - vertical concatenation of iris codes
% mask_codes - vertical concatenation of mask codes
% n - vertical size of one iris_code
% m - vertical size of one mask_code
% images - cell array of image names
function [iris_codes,mask_codes,n,m,images] = get_person_irises(folder)
  iris_codes = [];
  mask_codes = [];
  images = {};
  n = 0;
  m = 0;

  eyes = dir(folder);
  for j=3:size(eyes,1)
    eye_dir = strcat(folder,'/',eyes(j,:).name);
    image_files = dir(eye_dir);
    if size(image_files,1) < 3
      continue;
    end

    for k=3:size(image_files,1)
      image = image_files(k,:).name;
      load(strcat(eye_dir,'/',image,'/iris.mat'));
      n = size(iris_code,1);
      m = size(mask_code,1);
      iris_codes = [iris_codes; iris_code];
      mask_codes = [mask_codes; mask_code];
      images{end+1} = image;
    end
  end
end

% evaluates test results
function evaluate()
  % TODO
end
