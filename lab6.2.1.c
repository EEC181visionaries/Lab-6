#include <stdio.h>

#define SDRAM_READ_ADDR 0xFF200020
#define SDRAM_DATA1_ADDR 0xFF200040
#define SDRAM_DATA2_ADDR 0xFF200030
#define VGA_CTRL_CLK 0xFF200010
#define DDR3_ADDR 0x00100000
#define VGA_READ 0xFF200000

int main(void){

	volatile int * (sdram_read) = (int *) SDRAM_READ_ADDR;	//Output
	volatile int * (sdram_data1) = (int *) SDRAM_DATA1_ADDR;	//Input
	volatile int * (sdram_data2) = (int *) SDRAM_DATA2_ADDR;	//Input
	volatile int * (vga_ctrl_clk) = (int *) VGA_CTRL_CLK;	//Input
	volatile int * (ddr3) = (int *) DDR3_ADDR;	
	volatile int * (vga_read) = (int *) VGA_READ; //Input
	volatile int * write_block;
	
	int start = 0;


	printf("Press enter to start\n");
	fflush(stdin);
	getchar();

	write_block = DDR3_ADDR;
	while(!vga_read){}

	while(vga_read){
	//	printf("while\n");
		*(sdram_read) = 1;
		*(write_block) = *(sdram_data1);
		write_block++;
		*(write_block) = *(sdram_data2);
		write_block++;

		while((*(vga_ctrl_clk))){}
		while(!(*(vga_ctrl_clk))){}			
	}//while

	*(sdram_read) = 0;
	write_block = DDR3_ADDR;
	printf("Done\n");
	return 0;
}
