library ieee;
use ieee.std_logic_1164.all;

--datapath
--authors: Colby Banbury and Matt Stout
--description: controls the overall datapath of the calculator

entity datapath is
	
	port(
		I : in std_logic_vector(7 downto 0);
		clock: in std_logic;
		O: out std_logic_vector(7 downto 0) --output of 8 bit adder for testing
	);

end entity datapath;

architecture behav of datapath is
	component registers
		port(
			reg1     : in std_logic_vector(1 downto 0);
			reg2    : in std_logic_vector(1 downto 0);
			dest : in std_logic_vector(1 downto 0);
			writeData : in std_logic_vector(7 downto 0);
			clk    : in std_logic;
			hold     : in std_logic;
			data1	: out std_logic_vector(7 downto 0); --8 bit out
			data2	: out std_logic_vector(7 downto 0) --8 bit out
		);
	end component;

	component hold_reg
	    port(
	    	I          : in  std_logic_vector (3 downto 0);
	        I_SHIFT_IN : in  std_logic;
	        sel        : in  std_logic_vector(1 downto 0);
	        clock      : in  std_logic;
	        enable   : in  std_logic;
	        O          : out std_logic_vector(3 downto 0)
        );
  	end component;

  	component adder_8bit
		port(	
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			sub: in std_logic;
			s: out std_logic_vector(7 downto 0);
			over: out std_logic;
			under: out std_logic
		);
	end component;

	component display
		port (
			data : in std_logic_vector(7 downto 0);
			disp     : in std_logic;
			clk : in std_logic
		);
	end component;

	component sign_extend is
		port(
			in_4: in std_logic_vector (3 downto 0);
			out_8: out std_logic_vector (7 downto 0)
		);
	end component;

	signal sign_extend_out, write_data_in, adder_8bit_out, reg_data_1, reg_data_2 : std_logic_vector(7 downto 0);
	signal hold_reg_out, hold_reg_in: std_logic_vector(3 downto 0) := "0000";
	signal reg_decr: std_logic_vector(1 downto 0) := "11";
	signal Hold, Disp : std_logic;

begin 

	sign_extend_0: sign_extend port map(
			in_4 => I(3 downto 0),
			out_8 => sign_extend_out
	);

	registers_0: registers port map(
		reg1 => I(3 downto 2),
		reg2 => I(1 downto 0),
		dest => I(5 downto 4),
		writeData => write_data_in,
		clk  => clock,
		hold => Hold,
		data1 => reg_data_1,
		data2 => reg_data_2
		);

	adder_8bit_0: adder_8bit port map(
		a => reg_data_1,
		b => reg_data_2,
		sub => I(6),
		s => adder_8bit_out	--no need for over and underflow in this calculator
		);

	display_0: display port map(
		data => reg_data_2,
		disp => Disp,
		clk => clock
		);

	hold_reg_0: hold_reg port map(
		I => hold_reg_in,
	    I_SHIFT_IN => '0',
	    sel => reg_decr,
	    clock => clock,
	    enable => '1',
	    O => hold_reg_out
		);


	process(sign_extend_out, I(7), adder_8bit_out) is
	begin
		if (I(7) = '0') then
			write_data_in <= sign_extend_out;
		else
			write_data_in <= adder_8bit_out;
		end if;
	end process;

	process(I(7 downto 6), hold_reg_out) is
	begin
		if(I(7 downto 6) = "01") then
			Hold <= '1';
		elsif(hold_reg_out /= "0000" and hold_reg_out /= "UUUU") then
			Hold <= '1';
		else
			Hold <= '0';
		end if;
	end process;

	process(I(7 downto 5), hold_reg_out) is
	begin
		if(hold_reg_out /= "0000" and hold_reg_out /= "UUUU") then
			Disp <= '0';
		elsif(I(7 downto 5) = "011") then
			Disp <= '1';
		else
			Disp <= '0';
		end if;
	end process;

	process(I(7 downto 5), adder_8bit_out, I(4), hold_reg_out) is
	begin
			if(I(7 downto 5) = "010" and adder_8bit_out = "00000000" and hold_reg_out = "0000") then--beq?
				if(I(4) = '1') then--jump 2
					hold_reg_in <= "0010";
				else
					hold_reg_in <= "0001";
				end if;
			else
				hold_reg_in <= "0000";
			end if;
	end process;

	process(hold_reg_out, clock) is
	begin
		if(hold_reg_out /= "0000") then
			reg_decr <= "10";
		else
			
			reg_decr <= "11";
		end if;
	end process;

	process(reg_data_2) is
	begin
		O <= adder_8bit_out;
	end process;


end behav;
