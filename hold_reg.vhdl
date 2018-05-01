library ieee;
use ieee.std_logic_1164.all;

--hold register (4 bit)
--authors: Colby Banbury and Matt Stout
--description: special 4 bit register that holds the skip value

entity hold_reg is
port(	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0)
);
end hold_reg;

architecture behav of hold_reg is
   component shift_reg
    port(I          : in  std_logic_vector (3 downto 0);
         I_SHIFT_IN : in  std_logic;
         sel        : in  std_logic_vector(1 downto 0);
         clock      : in  std_logic;
         enable   : in  std_logic;
         O          : out std_logic_vector(3 downto 0)
         );
  end component;

  signal temp_0 : std_logic_vector(3 downto 0);

  begin

  	reg_holder: shift_reg port map(
    I => I,
    sel => sel,
    clock => clock,
    enable => enable,
    I_SHIFT_IN => I_SHIFT_IN,
    O => temp_0
    );

    process(temp_0) is
    begin
    	if(temp_0 = "UUUU") then
    		O <= "0000";
    	elsif(temp_0 = "0000") then
			O <= temp_0;
    	else
    		O <= temp_0;
    	end if;
    end process;


  end architecture behav;