Firstly, I would like to thank you for considering my processor.
This readme file will explain the conventions that I have followed in my file structure and
filenames. 

1) All the verilog source will be in 
	./or1200_cpu

2) Inside the or1200_cpu directory, these are the naming conventions I have 
   followed
	- tb_<PROJECT_NAME>.v => It is the test bench for a certain project
                                 indicated by <PROJECT_NAME> 
                                 (for example: tb_or1200_cpu.v => test bench for
                                 or1200_cpu module).
    	- <PROJECT_NAME>.sc   => Synthesis script in synopsys
        - COMPILE_SCRIPT      => This is used to compile in the cadence verilog 
                                 compiler.
	- .synopsys_dc.setup  => This is the setup file for the synopsys
				 design_analyzer software


3) All the waveforms for different relevant modules are given in the 
   ./Wave_Forms_For_The_Whole_Thing/ directory
   
   Inside this directory there is another directory that gives you the results
   when the modules are tested seperately.

   Please note that all the waveforms are of the Postscript module that is read
   using the ghostview software that can be downloaded from 
   http://www.cs.wisc.edu/~ghost/ (I am not sure if there are any others but
	this is the one I used)

4) ./Work/ directory is the directory that is used by model sim to store its
   binary when I compiled it using it.

5) I have followed the same conventions as OpenRISC to name my files.
