library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity datapath_tb is
end datapath_tb;

architecture behavioral of datapath_tb is
-- Declaration of the component to be instantiated
  component datapath
    port(I : in std_logic_vector(7 downto 0);
		clock: in std_logic;
		O: out std_logic_vector(7 downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal tb_I, tb_O          : std_logic_vector(7 downto 0);
  signal tb_clk : std_logic;
begin
-- Component instantiation
  datapath_0: datapath port map(I => tb_I,
  								clock => tb_clk,
  								O => tb_O);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the adder
      tb_I       : std_logic_vector(7 downto 0);
      tb_clk          : std_logic;
-- Expected outputs of adder
      tb_O : std_logic_vector(7 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (	("00001001",'0', "00000000"),--load in 1001 in reg 0
    	("00001001",'1', "00000000"),
    	("01100000",'0', "00000001"),--display (should be -7)
    	("01100000",'1', "00000001"),
    	("00001111",'0', "00000000"),--load in 1111 in reg 0
    	("00001111",'1', "00000000"),
    	("01100000",'0', "11111111"),--display(should be -1)
    	("01100000",'1', "11111111"),
    	("00010001",'0', "00000000"),--load in 0001 in reg 1
    	("00010001",'1', "00000000"),
    	("00000001",'0', "00000000"),--load in 0001 in reg 0
    	("00000001",'1', "00000000"),
    	("10100001",'0', "00000000"),--add reg0 and reg1 into reg2
    	("10100001",'1', "00000000"),
    	("01100010",'0', "11111111"),--display reg 2 (should be 2)
    	("01100010",'1', "11111111"),
    	("00011111",'0', "00000000"),--load in -1 in reg 1
    	("00011111",'1', "00000000"),
    	("00000001",'0', "00000000"),--load in 0001 in reg 0
    	("00000001",'1', "00000000"),
    	("10100001",'0', "00000000"),--add reg0 and reg1 into reg2
    	("10100001",'1', "00000000"),
    	("01100010",'0', "11111111"),--display reg 2 (should be 0)
    	("01100010",'1', "11111111"),
    	("00010010",'0', "00000000"),--load in 2 in reg 1
    	("00010010",'1', "00000000"),
    	("00000001",'0', "00000000"),--load in 1 in reg 0
    	("00000001",'1', "00000000"),
    	("11100001",'0', "00000000"),--subtract reg1 from reg0 into reg2
    	("11100001",'1', "00000000"),
    	("01100010",'0', "11111111"),--display reg 2 (should be -1)
    	("01100010",'1', "11111111"),
    	("01010000",'0', "00000000"),--beq on reg0 reg0
    	("01010000",'1', "00000000"),
		("01100010",'0', "11111111"),--display reg 2 (should skip)
    	("01100010",'1', "11111111"),
    	("01100010",'0', "11111111"),--display reg 2 (should skip)
    	("01100010",'1', "11111111"),
    	("01100000",'0', "11111111"),--display reg 0 (should be 1)
    	("01100000",'1', "11111111"),
    	("01010010",'0', "00000000"),--beq on reg0 reg2
    	("01010010",'1', "00000000"),
		("01100010",'0', "11111111"),--display reg 2 (should be -1)
    	("01100010",'1', "11111111"),
    	("01100010",'0', "11111111"),--display reg 2 (should be -1)
    	("01100010",'1', "11111111"),
    	("01100000",'0', "11111111"),--display reg 0 (should be 1)
    	("01100000",'1', "11111111")
       );
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      tb_I <= patterns(n).tb_I;
      tb_clk <= patterns(n).tb_clk;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
     --assert tb_O = patterns(n).tb_O
     	--report "bad output value O" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;