#include <stdio.h>
#include <string.h>

#define INPUT_LENGTH 80

int main()
{
  volatile int * reg = (int *) 0xFF200000;
  
  int on_flag = 0;
  char input[INPUT_LENGTH];
  
  while(1)
  {
    printf("Please enter \"on\", \"off\", or \"check\" to change or view the status of the camera: ");
    fgets(input, INPUT_LENGTH, stdin);
    
    if (!(strcmp(input, "on\n"))||!(strcmp(input, "On\n"))||!(strcmp(input, "ON\n")))
    {
      on_flag = 1;
      //*(reg) = 1;  // on?
      printf("Camera Status: On\n");
    } // if on
    else if (!(strcmp(input, "off\n"))||!(strcmp(input, "Off\n"))||!(strcmp(input, "OFF\n")))
    {
      on_flag = 0;
      //*(reg) = 0;  // off?
       printf("Camera Status: Off\n");
    } // if off
    else if (!(strcmp(input, "check\n"))||!(strcmp(input, "Check\n"))||!(strcmp(input, "CHECK\n")))
    {
      if (on_flag)
         printf("Camera Status: On\n");
      else
         printf("Camera Status: Off\n");
    } // if check
    else
      printf("Invalid input.\n");
  }
  return 0;
}
