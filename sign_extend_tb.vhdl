library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity sign_extend_tb is
end sign_extend_tb;

architecture behavioral of sign_extend_tb is
-- Declaration of the component to be instantiated
  component sign_extend
    port(in_4 : in  std_logic_vector(3 downto 0);
         out_8 : out std_logic_vector(7 downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal IN_4          : std_logic_vector(3 downto 0);
  signal OUT_8	   : std_logic_vector(7 downto 0);
begin
-- Component instantiation
  sign_extend0 : sign_extend port map(  in_4 => IN_4,
					out_8 => OUT_8);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the sign_extend
      IN_4   : std_logic_vector(3 downto 0);
-- Expected outputs of adder
      OUT_8   : std_logic_vector(7 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0000", "00000000"),
       ("0001", "00000001"),
       ("1111", "11111111"),
       ("1010", "11111010"));
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      IN_4 <= patterns(n).IN_4;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert OUT_8 = patterns(n).OUT_8
        report "bad output value s" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;