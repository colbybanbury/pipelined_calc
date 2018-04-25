library ieee;
use ieee.std_logic_1164.all;

--full adder
--authors: Colby Banbury and Matt Stout
--description: 1 bit adder with carry in and carry out

entity full_adder is
	
	port(	a: in std_logic;
		b: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
	);

end entity full_adder;

architecture behav of full_adder is

begin
	sum <= a xor b xor cin;
	cout <= (a and b) or (cin and a) or (cin and b);

end behav;