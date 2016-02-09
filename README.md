# Multi-functional-Digital-Clock
This are two versions of a multifunctional clock described in VHDL made for a school project! The first version (V1) is completly written in VHDL, the second version (V2) uses a picoblaze software microprocessor to replace some of the hardware. The code is meant for the Nexys 2 Spartan-3E FPGA Trainer Board in combination with a VGA screen, but can be adjusted for other field-programmable gate array boards...

##The multi-functional clock features:
* A time function which displays the time (format: HH:MM:SS)
* A date function which displays the date (fotmat: DD:MM:20JJ), includes leap year adjustment
* An alarm function that can set an alarm at a given time
* A chronometer function that tracks the time form a given moment (format: MM:SS:HH)
* A timer function which count down a given time period and sounds an alarm at the end (format: HH:MM:SS)
* A debouncer to debounce the buttons of the Nexys 2 board
* A clock divider function to divide the clock frequency of the Nexys 2 board
* Generic counters to use ass less hardware as possible!



