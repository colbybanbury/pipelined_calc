library ieee;
use ieee.std_logic_1164.all;

--testbench for the display file

--nor ports
entity display_tb is
end display_tb;

architecture behav of display_tb is

	component display
		port (
			data : in std_logic_vector(7 downto 0);
			disp     : in std_logic;
			clk	:in std_logic
			);
	end component;

	signal DATA : std_logic_vector(7 downto 0);
	signal DISP, CLK : std_logic;

begin
	
	display_0 : display port map(
						data => DATA,
						disp => DISP,
						clk => CLK
						);

	process
		type pattern_type is record
		--inputs
			DATA : std_logic_vector(7 downto 0);
			DISP : std_logic;
			CLK : std_logic;
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
		(
			("11111111", '0', '0'),--displays 0000 because disp is off
			("11111111", '0', '1'),--displays 0000 because disp is off
			("11111111", '1', '0'),--displays -1
			("11111111", '1', '1'),--displays -1
			("01111111", '1', '0'),--displays 127
			("01111111", '1', '1'),--displays 127
			("01111111", '1', '0'),--doesn't display because nothing has changed
			("01111111", '1', '1'),--doesn't display because nothing has changed
			("11111111", '0', '0'),--displays 0000
			("11111111", '0', '1')--displays 0000
		);

		begin
	--  Check each pattern
	    for n in patterns'range loop
		--  Set the inputs
			DATA <= patterns(n).DATA;
			DISP <= patterns(n).DISP;
			CLK <= patterns(n).CLK;

			wait for 1 ns;
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end behav;