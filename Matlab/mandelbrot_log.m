%
% Source:
% http://people.ece.cornell.edu/land/courses/ece5760/LABS/s2019/lab3_mandelbrot.html
%
clear all
figure(1); clf;

termination = 100;
x = linspace(-1.45, -1.3, 640); %[-2,1]
y = linspace(-0.07, 0.07, 480); %[-1,1]

x_index = 1:length(x) ;
y_index = 1:length(y) ;
img = zeros(length(y),length(x));


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
colormap(summer)

