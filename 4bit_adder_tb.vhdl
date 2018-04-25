library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity adder_4bit_tb is
end adder_4bit_tb;

architecture behavioral of adder_4bit_tb is
-- Declaration of the component to be instantiated
  component adder_4bit
    port(a     : in  std_logic_vector(3 downto 0);
         b     : in  std_logic_vector(3 downto 0);
         sub   : in  std_logic;
         s     : out std_logic_vector(3 downto 0);
         over  : out std_logic;
         under : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal tb_a, tb_b, tb_s          : std_logic_vector(3 downto 0);
  signal tb_sub, tb_over, tb_under : std_logic;
begin
-- Component instantiation
  adder0 : adder_4bit port map(a     => tb_a,
                                b     => tb_b,
                                s     => tb_s,
                                sub   => tb_sub,
                                over  => tb_over,
                                under => tb_under);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the adder
      tb_a, tb_b        : std_logic_vector(3 downto 0);
      tb_sub          : std_logic;
-- Expected outputs of adder
      tb_s            : std_logic_vector(3 downto 0);
      tb_over, tb_under : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0001", "0001", '0', "0010", '0', '0'),
       ("0001", "1111", '0', "0000", '0', '0'),
       ("1111", "1111", '0', "1110", '0', '0'),
       ("0001", "0001", '1', "0000", '0', '0'),
       ("1111", "0001", '1', "1110", '0', '0'),
       ("1111", "1111", '1', "0000", '0', '0'),
       ("0111", "0001", '0', "1000", '1', '0'),
       ("1001", "0010", '1', "0111", '0', '1'));
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