function mse = MSEcalc( ogimg,recimg )
%Calculate MSE between original image and reconstructed image
%inputs
%ogimg=the original image
%recimg=reconstructed image
%output
%mse=mean square error for each color

[rows, columns] = size(ogimg);

squaredErrorImage=cell(1,3);
mse=zeros(1,3);

for i=1:3
squaredErrorImage{i} = (double(ogimg(:,:,i)) - double(recimg(:,:,i))) .^ 2;
mse(i) = sum(sum(squaredErrorImage{i})) / (rows * columns);
end

end

