library ieee;
use ieee.std_logic_1164.all;

--4 to 1 multiplex
--Authors: Colby Banbury and Matt Stout
--takes the signals of 4 inputs and encodes them to a single output singnal
--   using a 2 bit selector 

entity mux is
  generic(size : integer);

  port( A    : in  std_logic_vector(size downto 0); --different inputs
        B    : in  std_logic_vector(size downto 0); --Can be of arbitrary size
        C    : in  std_logic_vector(size downto 0);
        D    : in  std_logic_vector(size downto 0);
        S    : in std_logic_vector(1 downto 0); --selectors
        O : out std_logic_vector(size downto 0));--outputs
end mux;

architecture func of mux is
begin
  process (A,B,C,D,S) is
  begin
--We chose to do more direct input output maping (instead of a more acurate circuit representation)
--for the sake of clarity
    if (S = "00") then
      O <= A;
    elsif (S = "01") then
      O <= B;
    elsif (S = "10") then
      O <= C;
    else
      O <= D;
    end if;
  end process;
end func;
