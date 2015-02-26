// gray = .21 * red + .72 * green + .07 * blue;

#include <stdio.h>
#include <string.h>

int main(void)
{
  volatile int * iRead_Data1 = (int *) 0x00000000; // input from read_data1
  volatile int * iRead_Data2 = (int *) 0x00000000; // input from read_data2
  volatile int * oRead_Data1 = (int *) 0x00000000; // output to read_data1
  volatile int * oRead_Data2 = (int *) 0x00000000; // output to read_data2
  
  int red, green, blue;
  
  // Separate inputs into rgb
  
  // Do the multiplication
  // Store into the output
  return 0;
}
