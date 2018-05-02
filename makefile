CC = ghdl
DEPS = 4-1mux.o 4bit_adder.o 8bit_adder.o datapath.o dff.o display.o full_adder.o hold_reg.o registers.o shift_reg.o sign_extend.o

default: datapath_tb

all: datapath_tb registers_tb mux_tb adder_4bit_tb adder_8bit_tb shift_reg_tb_8bit display_tb shift_reg_tb sign_extend_tb

%.o: %.vhdl
	$(CC) -a $^

%_tb: %_tb.o %.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

datapath_%_tb: $(DEPS) cpu_%_tb.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

registers_tb: registers_tb.o registers.o 8bit_shift_reg.o shift_reg.o dff.o 4-1mux.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

shift_reg_tb: shift_reg.o shift_reg_tb.o dff.o 4-1mux.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

8bit_shift_reg_tb: 8bit_shift_reg.o 8bit_shift_reg_tb.o shift_reg.o dff.o 4-1mux.o

instruction_skip_tb: instruction_skip_tb.o instruction_skip.o shift_reg.o dff.o 4-1mux.o
	$(CC) -e $@
	$(CC) -r $@ --vcd=$@.vcd

clean:
	rm *.o *_tb *.cf *.vcd

