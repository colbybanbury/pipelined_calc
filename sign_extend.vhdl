library ieee;
use ieee.std_logic_1164.all;


entity sign_extend is
	
	port(	in_4: in std_logic_vector (3 downto 0);
		out_8: out std_logic_vector (7 downto 0)
	);

end entity sign_extend;

architecture behav of sign_extend is

begin

	process (in_4) is
	begin
          out_8(0) <= in_4(0);
          out_8(1) <= in_4(1);
          out_8(2) <= in_4(2);
          for i in 3 to 7 loop
            out_8(i) <= in_4(3);
          end loop;
	end process;


end behav;
	