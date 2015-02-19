#include <stdio.h>
#include <string.h>

#define INPUT_LENGTH 80

int main()
{
  volatile int * reg = (int *) 0xFF200000;
  
  int start_flag = 0, stop_flag = 0;
  char input[INPUT_LENGTH];
  
  while(1)
  {
    printf('Please enter on, off, or check to change or view the status of the camera: ');
    fgets(input, INPUT_LENGTH, stdin);
    
    if (strcmp(input, 'on')||strcmp(input, 'on')||strcmp(input, 'on'))
    {
      
    }
  }
}
