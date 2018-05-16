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

	signal sign_extend_out, sign_extend_out_exe, sign_extend_out_wb, write_data_in, reg_data_1, reg_data_2, adder_8bit_out, adder_8bit_a, adder_8bit_b, display_value_wb, display_value : std_logic_vector(7 downto 0) := "00000000";
	signal hold_reg_out, hold_reg_in: std_logic_vector(3 downto 0) := "0000";
	signal reg_decr: std_logic_vector(1 downto 0) := "11";
	signal dest_reg_exe, dest_reg_wb, reg1_exe, reg2_exe: std_logic_vector(1 downto 0) := "00";
	signal Hold, Disp, sub_id, sub_in : std_logic := '0';
	signal instruc_exe, instruc_wb : std_logic_vector(1 downto 0) := "00";
	signal b_or_d_exe, b_or_d_wb, jump_exe : std_logic := '0';

begin 

	sign_extend_0: sign_extend port map(
			in_4 => I(3 downto 0),
			out_8 => sign_extend_out
	);

	registers_0: registers port map(
		reg1 => I(3 downto 2),
		reg2 => I(1 downto 0),
		dest => dest_reg_wb,
		writeData => write_data_in,
		clk  => clock,
		hold => Hold,
		data1 => reg_data_1,
		data2 => reg_data_2
		);

	adder_8bit_0: adder_8bit port map(
		a => adder_8bit_a,
		b => adder_8bit_b,
		sub => sub_in,
		s => adder_8bit_out	--no need for over and underflow in this calculator
		);

	display_0: display port map(
		data => display_value,
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


	process(clock) is
	begin
		if(rising_edge(clock)) then --move along one clock cycle
			dest_reg_wb <= dest_reg_exe;
			dest_reg_exe <= I(5 downto 4);

			sign_extend_out_wb <= sign_extend_out_exe;
			sign_extend_out_exe <= sign_extend_out;

			jump_exe <= I(4);

			instruc_wb <= instruc_exe;
			instruc_exe <= I(7 downto 6);

			reg1_exe <= I(3 downto 2);
			reg2_exe <= I(1 downto 0);

			sub_in <= sub_id;
			sub_id <= I(6);

			b_or_d_wb <= b_or_d_exe;
			b_or_d_exe <= I(5);
			
		end if;
	end process;

	process(clock) is
	begin
		if(rising_edge(clock)) then
			if(reg1_exe = dest_reg_wb) then --data forwarding
				if(instruc_wb = "00") then
					adder_8bit_a <= sign_extend_out_wb;
					--assert false report "load pipeline for a" severity note;
				elsif(instruc_wb(1) = '1') then
					adder_8bit_a <= adder_8bit_out;
					--assert false report "add pipeline for a" severity note;
				else
					adder_8bit_a <= reg_data_1;
				end if;
			else
				adder_8bit_a <= reg_data_1;
			end if;

			if(reg2_exe = dest_reg_wb) then
				if(instruc_wb = "00") then
					adder_8bit_b <= sign_extend_out_wb;
					display_value_wb <= sign_extend_out_wb;
					--assert false report "load pipeline for b" severity note;
				elsif(instruc_wb(1) = '1') then
					adder_8bit_b <= adder_8bit_out;
					display_value_wb <= adder_8bit_out;
					--assert false report "add pipeline for b" severity note
				else
					adder_8bit_b <= reg_data_2;
					display_value_wb <= reg_data_2;
				end if;
			else
				adder_8bit_b <= reg_data_2;
				display_value_wb <= reg_data_2;
			end if;
		end if;
	end process;

	process(instruc_wb, sign_extend_out_wb, adder_8bit_out) is
	begin
		if (instruc_wb(1) = '0') then
			write_data_in <= sign_extend_out_wb;
		else
			write_data_in <= adder_8bit_out;
		end if;
	end process;

	process(instruc_wb, hold_reg_out) is
	begin
		if(instruc_wb = "01") then
			Hold <= '1';
		elsif(hold_reg_out /= "0000" and hold_reg_out /= "UUUU") then
			Hold <= '1';
		else
			Hold <= '0';
		end if;
	end process;

	process(instruc_wb, b_or_d_wb, hold_reg_out, write_data_in, adder_8bit_out, display_value_wb) is
	begin
		if(hold_reg_out /= "0000" and hold_reg_out /= "UUUU") then
			Disp <= '0';
		else
			Disp <= '1';
			if(instruc_wb = "00") then
				display_value <= write_data_in;
			elsif (instruc_wb(1) = '1' or (instruc_wb = "01" and b_or_d_wb = '0')) then
				display_value <= adder_8bit_out;
			elsif (instruc_wb = "01" and b_or_d_wb = '1') then
				display_value <= display_value_wb;
			end if;
		end if;
	end process;

	process(instruc_exe, b_or_d_exe, adder_8bit_out, jump_exe, hold_reg_out) is
	begin
			if(instruc_exe = "01" and b_or_d_exe = '0' and adder_8bit_out = "00000000" and hold_reg_out = "0000") then--beq?
				if(jump_exe = '1') then--jump 2
					hold_reg_in <= "0010";
				else
					hold_reg_in <= "0001";
				end if;
			elsif hold_reg_in = "UUUU" then
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
