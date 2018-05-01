library ieee;
use ieee.std_logic_1164.all;

--registers (8 bit)
--authors: Colby Banbury and Matt Stout
--description: 4 registers
--inputs: reg1, reg2, dest, write data, clock, hold
--output: data1, data2

entity registers is
	port (
		reg1     : in std_logic_vector(1 downto 0);
		reg2    : in std_logic_vector(1 downto 0);
		dest : in std_logic_vector(1 downto 0);
		writeData : in std_logic_vector(7 downto 0);
		clk    : in std_logic;
		hold     : in std_logic;
		data1	: out std_logic_vector(7 downto 0); --8 bit out
		data2	: out std_logic_vector(7 downto 0) --8 bit out
	);

end entity registers;

architecture regs of registers is
  component shift_reg_8bit
	port (
		I     : in std_logic_vector(7 downto 0); --8 bit in
		sel    : in std_logic_vector(1 downto 0); --00:hold; 01: shift left; 10: shift right; 11: load
		I_SHIFT_IN : in std_logic;
		clk    : in std_logic;
		enable     : in std_logic;
		O     : out std_logic_vector(7 downto 0) --8 bit out
    );
  end component;

	signal slct0, slct1, slct2, slct3	:	std_logic_vector(1 downto 0);
	signal o0, o1, o2, o3, checkout1, checkout2	: std_logic_vector(7 downto 0);

begin

	process(hold, dest) is --if hold is zero none of the registers update, otherwise dest decides
	begin

			slct0 <= "00"; 
			slct1 <= "00";
			slct2 <= "00";
			slct3 <= "00";

		if (hold = '0') then
			case dest is
				when "00"	=> slct0 <= "11";
				when "01"	=> slct1 <= "11";
				when "10"	=> slct2 <= "11";
				when "11"	=> slct3 <= "11";
				when others => slct0 <= "11";
			end case;
		end if;
	end process;


register0: shift_reg_8bit port map(
	I => writeData,
	sel => slct0,
	I_SHIFT_IN => '0',
	clk => clk,
	enable => '1',
	O => o0
	);
register1: shift_reg_8bit port map(
	I => writeData,
	sel => slct1,
	I_SHIFT_IN => '0',
	clk => clk,
	enable => '1',
	O => o1
	);
register2: shift_reg_8bit port map(
	I => writeData,
	sel => slct2,
	I_SHIFT_IN => '0',
	clk => clk,
	enable => '1',
	O => o2
	);
register3: shift_reg_8bit port map(
	I => writeData,
	sel => slct3,
	I_SHIFT_IN => '0',
	clk => clk,
	enable => '1',
	O => o3
	);

	process (o0, o1, o2, o3, reg1) is --change the checkout1 based on reg1
	begin
		case reg1 is
			when "00"	=> checkout1 <= o0;
			when "01"	=> checkout1 <= o1;
			when "10"	=> checkout1 <= o2;
			when "11"	=> checkout1 <= o3;
			when others => checkout1 <= o0;
		end case;
	end process;

	process (o0, o1, o2, o3, reg2) is --change the checkout2 based on reg1
	begin
		case reg2 is
			when "00"	=> checkout2 <= o0;
			when "01"	=> checkout2 <= o1;
			when "10"	=> checkout2 <= o2;
			when "11"	=> checkout2 <= o3;
			when others => checkout2 <= o0;
		end case;
	end process;

	process(checkout1) is
	begin
		if(checkout1 = "UUUUUUUU") then
			data1 <= "00000000";
		else
			data1 <= checkout1;
		end if;
	end process;

	process(checkout2) is
	begin
		if (checkout2 = "UUUUUUUU") then
			data2 <= "00000000";
		else
			data2 <= checkout2;
		end if;
	end process;
	
end architecture regs;
