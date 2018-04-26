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
	signal o0, o1, o2, o3	: std_logic_vector(7 downto 0);

begin

	process(hold, dest) is --if hold is zero none of the registers update, otherwise dest decides
	begin
		if (hold = '1') then
			slct0 <= "00"; 
			slct1 <= "00";
			slct2 <= "00";
			slct3 <= "00";
		elsif (dest = "00") then
			slct0 <= "11";
			slct1 <= "00";
			slct2 <= "00";
			slct3 <= "00";
		elsif (dest = "01") then
			slct0 <= "00";
			slct1 <= "11";
			slct2 <= "00";
			slct3 <= "00";
		elsif (dest = "10") then
			slct0 <= "00";
			slct1 <= "00";
			slct2 <= "11";
			slct3 <= "00";
		else
			slct0 <= "00";
			slct1 <= "00";
			slct2 <= "00";
			slct3 <= "11";
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

	process (o0, o1, o2, o3) is --change the data1 based on reg1
	begin
		if (reg1 = "00") then
			data1 <= o0;
		elsif (reg1 = "01") then
			data1 <= o1;
		elsif (reg1 = "10") then
			data1 <= o2;
		else
			data1 <= o3;
		end if;
		if (reg2 = "00") then
			data2 <= o0;
		elsif (reg2 = "01") then
			data2 <= o1;
		elsif (reg2 = "10") then
			data2 <= o2;
		else
			data2 <= o3;
		end if;
	end process;

end architecture regs;