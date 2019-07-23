# FPGA Mandelbrot Set on Digilent Basys3 Xilinx Artix 7 (Not finished)
Mandelbrot set visualization 

![picture](http://people.ece.cornell.edu/land/courses/ece5760/LABS/s2019/lab3_mandelbrot_rectangle.png)

I will try make Cornell University ECE 5760: Laboratory 3 Mandelbrot set visualization.
http://people.ece.cornell.edu/land/courses/ece5760/LABS/s2019/lab3_mandelbrot.html

Lectures:
* https://www.youtube.com/watch?v=7rIjuQZSby0
* https://www.youtube.com/watch?v=vxSoiG242OA&t=911s

## Math 

Calculations are performed using floating point

   | Sign | Exponent  | Mantissa |  
   | 1bit |   8bits   |  18bits  |

   2^0 => Exponent = 'd127 = 'h7f

   Mantissa = [ ( 1-2^(-126) ) ; 0.5 ]
   
   
