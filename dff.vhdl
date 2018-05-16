library ieee;
use ieee.STD_LOGIC_1164.all;

--dff (aka d type flip flop)
--authors: colby banbury and matt stout
--description: waits for rising edge and then passes the input to the output
--              if enable is on

entity dff is
  port(
      clk : in std_logic;--clock
      en  : in std_logic;--enable
      d : in std_logic;--input
      q : out std_logic--output
      );
end entity dff;

architecture Behavioral of dff is

signal reg_val : std_logic;

begin
  process (clk) is
  begin
    if rising_edge(clk) and (en = '1') then
      reg_val <= d;
    elsif falling_edge(clk) then
      q <= reg_val;
    end if;
  end process;
end architecture Behavioral;