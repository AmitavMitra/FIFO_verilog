# FIFO_verilog
A basic implementation of different types of FIFO buffers (synchronous, asynchronous and circular).

Simulated in ModelSim

To compile use ```vlog <filename.v>``` in the transcript. 
To use multiple files just add file names with a space between each consecutive file name.

To simulate use ```vsim -voptargs=+acc <modulename>``` for gui simulation
and ```vsim -c -voptargs=+acc <modulename>``` for cli simulation.
