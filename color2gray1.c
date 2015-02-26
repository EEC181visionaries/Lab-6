// color2gray1.c
// converts rgb to grayscale using equation...
// gray = .21 * red + .72 * green + .07 * blue;

//#include <stdio.h>
//#include <string.h>

int main(void)
{
  volatile int * iRead_Data1 = (int *) 0x00000000; // input from read_data1 from Sdram_Control
  volatile int * iRead_Data2 = (int *) 0x00000000; // input from read_data2 from Sdram_Control
  volatile int * oRead_Data1 = (int *) 0x00000000; // output to read_data1 into VGA_Controller
  volatile int * oRead_Data2 = (int *) 0x00000000; // output to read_data2 into VGA_Controller
  
  int red, green, green_h, green_l, blue, gray;
  
  // Separate inputs into rgb
  red = *(iRead_Data2) & 1023; // red = iRead_Data2[9:0]
  green = (*(iRead_Data1) & 31744)/32 + (*(iRead_Data2) & 31744)/1024; // green = {iRead_Data1[14:10], iRead_Data2[14:10]}
  blue = *(iRead_Data1) & 1023;// blue = iRead_Data1[9:0]
  
  // Do the multiplication
  gray = .21 * red + .72 * green + .07 * blue;
  
  // Store into the output
  *(oRead_Data1) = ((gray & 992) * 32) + gray;  // {green[9:5], blue[9:0]}
  *(oRead_Data2) = ((gray & 31) * 1024) + gray; // {green[4:0], red[9:0]}
  
  return 0;
}
