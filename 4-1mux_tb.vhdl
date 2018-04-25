library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity mux_tb is
end mux_tb;

architecture behavioral of mux_tb is
-- Declaration of the component to be instantiated
  component mux
    generic(size : integer := 1);

  port( A    : in  std_logic_vector(size downto 0); --different inputs
        B    : in  std_logic_vector(size downto 0); --Can be of arbitrary size
        C    : in  std_logic_vector(size downto 0);
        D    : in  std_logic_vector(size downto 0);
        S    : in std_logic_vector(1 downto 0); --selectors
        O : out std_logic_vector(size downto 0));--outputs
  end component;
-- Specifies which entity is bound with the component
  signal s                 : std_logic_vector(1 downto 0);
  signal i0, i1, i2, i3, o : std_logic_vector(1 downto 0);
begin
-- Component instantiation
  mux0 : mux port map(S => s,
                          A    => i0,
                          B    => i1,
                          C    => i2,
                          D    => i3,
                          O => o);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the mux
      i0, i1, i2, i3 : std_logic_vector(1 downto 0);
      s              : std_logic_vector(1 downto 0);
-- Expected outputs of mux      
      o              : std_logic_vector(1 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00", "01", "10", "11", "00", "00"),
       ("00", "01", "10", "11", "01", "01"),
       ("00", "01", "10", "11", "10", "10"),
       ("00", "01", "10", "11", "11", "11"));
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      s  <= patterns(n).s;
      i0 <= patterns(n).i0;
      i1 <= patterns(n).i1;
      i2 <= patterns(n).i2;
      i3 <= patterns(n).i3;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert o = patterns(n).o
        report "bad output value" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;
