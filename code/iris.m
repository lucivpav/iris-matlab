function [iris_code, mask_code] = iris(eye_file, output_dir)
  eye_file
  global CUR_DIR;
  CUR_DIR = output_dir;

  eye_image = imread(eye_file);
  [circles, eyelids] = segment(eye_image);
  save(strcat(CUR_DIR, '/', 'segment.mat'), 'circles', 'eyelids');

  % compute iris code
  [image, rect] = project(eye_image, circles);
  save_image(image, 'iris_project');
  iris_code = feature_extraction(rect);
  save_image(iris_code, 'iris_code');

  % compute mask
  mask_image = mask(eye_image, circles, eyelids);
  [image, mask_rect] = project(mask_image, circles);
  save_image(image, 'mask_project');
  mask_code = feature_extraction(mask_rect);
  save_image(mask_code, 'mask_code');
end
