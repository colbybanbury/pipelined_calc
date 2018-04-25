library ieee;
use ieee.std_logic_1164.all;

--4 bit adder
--authors: Colby Banbury and Matt Stout
--description: combines 4 full adders. controls for over and underflow


entity adder_4bit is

	port(	a: in std_logic_vector(3 downto 0); --4 bit a, b and out
		b: in std_logic_vector(3 downto 0);
		sub: in std_logic; --subtraction flag
		s: out std_logic_vector(3 downto 0);
		over: out std_logic;
		under: out std_logic
	);

end entity adder_4bit;

architecture behav of adder_4bit is

	component full_adder

		port(	a: in std_logic;
			b: in std_logic;
			cin: in std_logic;
			sum: out std_logic;
			cout: out std_logic
		);

	end component;

	signal subB0, subB1, subB2, subB3, c1, c2, c3, c4, s3_signal: std_logic;

	begin

	subB0 <= b(0) xor sub;	--change b to the negative (2s compliment) value when subtracting
	subB1 <= b(1) xor sub;
	subB2 <= b(2) xor sub;
	subB3 <= b(3) xor sub;

	fa0: full_adder port map(	a => a(0),
					b => subB0,
					cin => sub,
					sum => s(0),
					cout => c1);

	fa1: full_adder port map(	a => a(1),
					b => subB1,
					cin => c1,
					sum => s(1),
					cout => c2);

	fa2: full_adder port map(	a => a(2),
					b => subB2,
					cin => c2,
					sum => s(2),
					cout => c3);

	fa3: full_adder port map(	a => a(3),
					b => subB3,
					cin => c3,
					sum => s3_signal,
					cout => c4);

	under <= (not s3_signal and c4 and a(3) and subB3); --shows over or underflow
	over <= (not a(3) and not b(3)) and s3_signal;
	s(3) <= s3_signal; 

end behav;