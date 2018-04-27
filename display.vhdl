library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--display (8 bit)
--authors: Colby Banbury and Matt Stout
--description: displays the input 8 bit binary value in decimal
--inputs: data, hold
--output: none

entity display is
	port (
		data : in std_logic_vector(7 downto 0);
		hold     : in std_logic := '1'
	);

end entity display;


architecture disp of display is
begin

	process(hold, data) is
	begin
		if(hold = '1') then
			report "0000";
		else
			report integer'image(to_integer(signed(data)));
		end if;
	end process;

end architecture disp;
