%gray = .21 * red + .72 * green + .07 * blue;
function [new_image original_image] = color2gray(image)
  original_image = image;
  [row, col, rgb] = size(image);
  new_image = uint8(zeros(row, col, rgb));
  
  % To display an image in gray scale, 
  %   set the rgb to the same values.
  
  for i = 1:row
      for j = 1:col
        new_image(i,j,1) = image(i,j,1)*.21 + ...
            image(i,j,2)*.72 + ...
            image(i,j,3)*.07;
        new_image(i,j,2) = new_image(i,j,1);
        new_image(i,j,3) = new_image(i,j,1); 
      end
  end
  new_image = uint8(new_image);
  
end
