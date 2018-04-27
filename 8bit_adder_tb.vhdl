library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity adder_8bit_tb is
end adder_8bit_tb;

architecture behavioral of adder_8bit_tb is
-- Declaration of the component to be instantiated
  component adder_8bit
    port(a     : in  std_logic_vector(7 downto 0);
         b     : in  std_logic_vector(7 downto 0);
         sub   : in  std_logic;
         s     : out std_logic_vector(7 downto 0);
         over  : out std_logic;
         under : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal tb_a, tb_b, tb_s          : std_logic_vector(7 downto 0);
  signal tb_sub, tb_over, tb_under : std_logic;
begin
-- Component instantiation
  adder0 : adder_8bit port map(a     => tb_a,
                                b     => tb_b,
                                s     => tb_s,
                                sub   => tb_sub,
                                over  => tb_over,
                                under => tb_under);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the adder
      tb_a, tb_b        : std_logic_vector(7 downto 0);
      tb_sub          : std_logic;
-- Expected outputs of adder
      tb_s            : std_logic_vector(7 downto 0);
      tb_over, tb_under : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000001", "00000001", '0', "00000010", '0', '0'),
       ("00000001", "11111111", '0', "00000000", '0', '0'),
       ("11111111", "11111111", '0', "11111110", '0', '0'),
       ("00000001", "00000001", '1', "00000000", '0', '0'),
       ("11111111", "00000001", '1', "11111110", '0', '0'),
       ("11111111", "11111111", '1', "00000000", '0', '0'),
       ("00000111", "00000001", '0', "00001000", '0', '0'),
       ("11111001", "00000010", '1', "11110111", '0', '0'));
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      tb_a <= patterns(n).tb_a;
      tb_b <= patterns(n).tb_b;
      tb_sub <= patterns(n).tb_sub;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert tb_s = patterns(n).tb_s
        report "bad output value s" severity error;
      assert tb_over = patterns(n).tb_over
        report "bad output value o" severity error;
      assert tb_under = patterns(n).tb_under
        report "bad output value u" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;