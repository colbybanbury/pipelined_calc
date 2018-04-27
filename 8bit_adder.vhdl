library ieee;
use ieee.std_logic_1164.all;

--8 bit adder
--authors: Colby Banbury and Matt Stout
--description: combines 8 full adders. controls for over and underflow


entity adder_8bit is

	port(	
		a: in std_logic_vector(7 downto 0);
		b: in std_logic_vector(7 downto 0);
		sub: in std_logic;
		s: out std_logic_vector(7 downto 0);
		over: out std_logic;
		under: out std_logic
	);

end entity adder_8bit;

architecture behav of adder_8bit is

	component full_adder

		port(	a: in std_logic;
			b: in std_logic;
			cin: in std_logic;
			sum: out std_logic;
			cout: out std_logic
		);

	end component;

	signal subB0, subB1, subB2, subB3, subB4, subB5, subB6, subB7, c1, c2, c3, c4, c5, c6, c7, c8, sig_bit: std_logic;

	begin

	subB0 <= b(0) xor sub;
	subB1 <= b(1) xor sub;
	subB2 <= b(2) xor sub;
	subB3 <= b(3) xor sub;
	subB4 <= b(4) xor sub;
	subB5 <= b(5) xor sub;
	subB6 <= b(6) xor sub;
	subB7 <= b(7) xor sub;

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
					sum => s(3),
					cout => c4);

	fa4: full_adder port map(	a => a(4),
					b => subB4,
					cin => c4,
					sum => s(4),
					cout => c5);

	fa5: full_adder port map(	a => a(5),
					b => subB5,
					cin => c5,
					sum => s(5),
					cout => c6);

	fa6: full_adder port map(	a => a(6),
					b => subB6,
					cin => c6,
					sum => s(6),
					cout => c7);

	fa7: full_adder port map(	a => a(7),
					b => subB7,
					cin => c7,
					sum => sig_bit,
					cout => c8);

	under <= (not sig_bit and c8 and a(7) and subB7);
	over <= (not a(7) and not b(7)) and sig_bit;
	s(7) <= sig_bit; 

end behav;
	