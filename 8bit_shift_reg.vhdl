library ieee;
use ieee.std_logic_1164.all;

--shift register (8 bit)
--authors: Colby Banbury and Matt Stout
--description: uses two 4 bit shift registers in combination to create a 8 bit shift register


entity shift_reg_8bit is

  port (
    I     : in std_logic_vector(7 downto 0); --8 bit in
    sel    : in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
    I_SHIFT_IN : in std_logic;
    clk    : in std_logic;
    enable     : in std_logic;
    O     : out std_logic_vector(7 downto 0) --8 bit out
    );

end entity shift_reg_8bit;


architecture str of shift_reg_8bit is
  component shift_reg
    port(I          : in  std_logic_vector (3 downto 0);
         I_SHIFT_IN : in  std_logic;
         sel        : in  std_logic_vector(1 downto 0);
         clock      : in  std_logic;
         enable   : in  std_logic;
         O          : out std_logic_vector(3 downto 0)
         );
  end component;


  signal I_SHIFT0,I_SHIFT1 : std_logic;
  signal out0,out1: std_logic_vector(3 downto 0);
  
begin

  process (I_SHIFT_IN, out0, out1) is
  begin
    if (sel(1) = '1') then --shift left
    	I_SHIFT0 <= out1(0);
    	I_SHIFT1 <= I_SHIFT_IN;
    else
    	I_SHIFT0 <= I_SHIFT_IN;  --shift right
    	I_SHIFT1 <= out0(3);
    end if;
  end process;

  reg0: shift_reg port map(
    I => I(3 downto 0),
    sel => sel,
    clock => clk,
    enable => enable,
    I_SHIFT_IN => I_SHIFT0,
    O => out0
    );
  reg1: shift_reg port map(
    I => I(7 downto 4),
    sel => sel,
    clock => clk,
    enable => enable,
    I_SHIFT_IN => I_SHIFT1,
    O => out1
    );

  O(7 downto 4) <= out1;  --maping the two 4 bit outputs to the 8 bit output
  O(3 downto 0) <= out0;

end architecture str;