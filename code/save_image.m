function save_image(image, name)
  global CUR_DIR;
  file_name = strcat(CUR_DIR, '/', name, '.jpg');
  imwrite(image, file_name);
end
