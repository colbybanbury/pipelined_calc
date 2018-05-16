library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--display (8 bit)
--authors: Colby Banbury and Matt Stout
--description: displays the input 8 bit binary value in decimal
--inputs: data, disp
--output: none

entity display is
	port (
		data : in std_logic_vector(7 downto 0);
		disp     : in std_logic;
		clk : in std_logic
	);

end entity display;


architecture disp of display is
begin

	process(clk) is
	begin
		if rising_edge(clk) then
			if(disp = '0' or data = "UUUUUUUU") then
				report "nop";
			else
				report "value: " & integer'image(to_integer(signed(data))) severity note;
			end if;
		end if;
	end process;

end architecture disp;
