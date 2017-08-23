-- TODO: Implement in project. Problem: `'config' is not compiled in library xil_defaultlib`

library  ieee;
use ieee.std_logic_1164.all;

package Config is
	constant C_ADC_RESOLUTION   	: INTEGER := 10;
	constant C_PEAK_TIME_RESOLUTION : INTEGER := 8;
	constant C_CB_DATA_WIDTH		: INTEGER := 10;
	constant C_CB_SIZE				: INTEGER := 20;
	constant C_CB_COUNTER_BITS		: INTEGER := 8;
end package Config;

