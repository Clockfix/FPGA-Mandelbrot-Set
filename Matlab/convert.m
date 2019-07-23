%% converting decimal to binary floting point
%
%   | Sign | Exponent  | Mantissa |  
%   | 1bit |   8bits   |  18bits  |
%
%   2^0 => Exponent = 'd127 = 'h7f
%
%   Mantissa = [ ( 1-2^(-126) ) ; 0.5 ]
%   
%
clear all;
x = -780*680 * 0.5^1; % number to convert
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exponent = 127;
%
% calculating exponent and mantissa
%
x_new = abs(x);
while (x_new >= 1 && exponent <255 && exponent >0)
   x_new = x_new / 2;
   exponent = exponent + 1;
end
while (x_new < 0.5 && exponent <255 && exponent >0) 
   x_new = x_new * 2;
   exponent = exponent -1;
end
% covertin x and exponent to fixed point number
disp( ' ' )
print = ['Converting decimal number ' , num2str(x) , ' to floting point number:'];
disp( print );
if (x < 0) 
    print = ['-'];
else
    print = [' '];
end 
print = [ '           ' , print , num2str(x_new) , '*2^' ,  num2str(exponent - 127)];
disp( print );
% if number are out of boundaries pront overflow
if (exponent == 255 || exponent == 0)
    disp( ' ' );
    disp( '************overflow*************' );
    disp( ' ' );
end
%% Convering to binary
% Sign
if (x < 0 ) 
    string_bin = ['1'];
else
    string_bin = ['0'];
end
% Exponent
exp_ufi = ufi(exponent,8,0);
temp = [exp_ufi.bin];
for n=7:-1:0
    string_bin = [string_bin, temp(end-n)];
end
% Mantissa
x_ufi = ufi(x_new,19,18);
temp = [x_ufi.bin];
for n=17:-1:0
    string_bin = [string_bin, temp(end-n)];
end
string_hex = dec2hex(bin2dec(string_bin),7);
%% printing out result
disp( ' ' );
print = [ ' 27`b_ = ' , string_bin];
disp( print );
print = [ ' 27`h_ = ' , string_hex];
disp( print );
disp( ' ' );