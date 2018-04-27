library ieee;
use ieee.std_logic_1164.all;

--testbench for the registers file

--nor ports
entity registers_tb is
end registers_tb;

architecture behav of registers_tb is

	component registers
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
	end component;

	signal REG1, REG2, DEST : std_logic_vector(1 downto 0);
	signal CLK, HOLD : std_logic;
	signal WRITEDATA, DATA1, DATA2 : std_logic_vector(7 downto 0);

begin
	
	registers_0 : registers port map(
							reg1 => REG1,
							reg2 => REG2,
							dest => DEST,
							writeData => WRITEDATA,
							clk => CLK,
							hold => HOLD,
							data1 => DATA1,
							data2 => DATA2
							);
	process
		type pattern_type is record
		--inputs
			REG1, REG2, DEST : std_logic_vector(1 downto 0);
			WRITEDATA: std_logic_vector(7 downto 0);
			CLK, HOLD : std_logic;
		--outputs
			DATA1, DATA2 : std_logic_vector(7 downto 0);
		end record;

		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
		(	--reg1,reg2, dest, writedata,  clk,hold,   data1,    data2 
			("00", "00", "00", "00000010", '0', '0', "UUUUUUUU", "UUUUUUUU"),--1ns
			("00", "00", "00", "00000001", '0', '1', "UUUUUUUU", "UUUUUUUU"),--hold
			("00", "00", "00", "00000001", '1', '1', "UUUUUUUU", "UUUUUUUU"),--hold
			("00", "00", "00", "00000100", '0', '0', "UUUUUUUU", "UUUUUUUU"),--clk 0
			("00", "00", "10", "00000001", '1', '1', "00000100", "00000100"),--5ns
			("00", "00", "00", "00000001", '0', '0', "00000100", "00000100"), --clk0 should read reg1 and sets reg0
			("00", "00", "00", "00000001", '1', '1', "00000001", "00000001"), --clk1 should read reg1
			("00", "00", "00", "00000001", '0', '1', "00000001", "00000001"),--hold
			("00", "01", "01", "00010000", '1', '1', "00000001", "UUUUUUUU"),
			("00", "01", "01", "00010000", '0', '0', "00000001", "UUUUUUUU"),-- 10ns
			("00", "01", "10", "00000001", '1', '1', "00000001", "00010000"),
			("01", "10", "00", "00000001", '0', '1', "00010000", "UUUUUUUU")

			);
	begin
	--  Check each pattern
    for n in patterns'range loop
	--  Set the inputs
		Reg1 <= patterns(n).Reg1;
		Reg2 <= patterns(n).Reg2;
		DEST <= patterns(n).DEST;
		CLK <= patterns(n).CLK;
		HOLD <= patterns(n).HOLD;
		WRITEDATA <= patterns(n).WRITEDATA;

		wait for 1 ns;

	--check outputs
		assert DATA1 = patterns(n).DATA1
			report "bad output value" severity error; 
		assert DATA2 = patterns(n).DATA2
			report "bad output value" severity error;
		end loop;
		assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation
    wait;
  end process;
end behav;


