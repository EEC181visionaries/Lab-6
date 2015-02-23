#include <stdio.h>

#define START_CAM_ADDRESS 0xFF200000	// 0x00000000

int main(void)
{
	int i = 0;
	volatile int *start_cam = (int*) START_CAM_ADDRESS;
	
	while(1)
	{
		printf("press to start...\n");
		fflush(stdin);
		getchar();
		*start_cam = 1;

		printf("press to stop...\n");
		fflush(stdin);
		getchar();
		*start_cam = 0;

		for ( i=0; i< 99999; i++)
		{
		}
	}

	

	return 0;
}
