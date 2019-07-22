%
%
% Clar figure 1 and workspace
clear all
%figure(1); clf;
% Image size
columns = 320;
rows = 240;
% Terminate after n cycles
termination = 1000;

x = linspace(-2, 2, columns); %[-2,1]
y = linspace(-1.5, 1.5, rows); %[-1,1]
%
% make blank(white) matrix
x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = ones(length(y),length(x));

for k=x_index
    for j=y_index
        z = 0;
        n = 0;
        c = x(k)+ y(j)*i ;%complex number
        while (abs(z)<2 && n<termination)
            z = z^2 + c;
            n = n + 1;
        end
        img(j,k) = fix(log2(n));
    end
end

imagesc(img)
imwrite(img,'mandelbrot.jpeg','JPEG');


