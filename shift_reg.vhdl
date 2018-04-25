library ieee;
use ieee.std_logic_1164.all;

--shift register (4 bit)
--authors: Colby Banbury and Matt Stout
--description: does 1 of 4 operations (hold, shift_left, shift_right, or load)
	--hold keeps the same value in the register
	--shift left places a new value (I_SHIFT_IN) in the left most bit and shifts the others left
	--shift right places a new value (I_SHIFT_IN) in the right most bit and shifts the others right
	--load places a totally new value (I) into the register

entity shift_reg is
port(	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0)
);
end shift_reg;

architecture behav of shift_reg is
	component mux
	    generic(size : integer := 3);
		  port( A    : in  std_logic_vector(size downto 0); --different inputs
		        B    : in  std_logic_vector(size downto 0); --Currently of size 4
		        C    : in  std_logic_vector(size downto 0);
		        D    : in  std_logic_vector(size downto 0);
		        S    : in std_logic_vector(1 downto 0); --selectors
		        O : out std_logic_vector(size downto 0));--outputs
  	end component;

	component dff is
		port(
      	clk : in std_logic;
      	en  : in std_logic;
      	d : in std_logic;
      	q : out std_logic
      	);
  	end component;


  signal hold, l_shf, r_shf, tmp, res : std_logic_vector (3 downto 0);

begin

  l_shf(0) <= I_SHIFT_IN;
  l_shf(1) <= hold(0);
  l_shf(2) <= hold(1);
  l_shf(3) <= hold(2);

  r_shf(0) <= hold(1);
  r_shf(1) <= hold(2);
  r_shf(2) <= hold(3);
  r_shf(3) <= I_SHIFT_IN;

  process (tmp, enable) is
  begin
    for i in 0 to 3 loop
      res(i) <= enable and tmp(i); --tmp is the value from the previous iteration
    end loop;
  end process;

  DFFS :
  for i in 0 to 3 generate --create 4 d flip flops 
    DFFX : dff port map
      (clock, enable, res(i), hold(i));
  end generate DFFS;

  mux0 : mux port map(S => sel,
                          A    => hold,
                          B    => l_shf,
                          C    => r_shf,
                          D    => I,
                          O => tmp);

  process (hold, enable)
  begin
    for i in 0 to 3 loop
      O(i) <= enable and hold(i); --when enable is off '0000' is output
    end loop;
  end process;

end behav;

