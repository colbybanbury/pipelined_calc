CC = ghdl
DEPS = 8bit_shift_reg.o 4-1mux.o 4bit_adder.o 8bit_adder.o datapath.o dff.o display.o full_adder.o hold_reg.o registers.o shift_reg.o sign_extend.o

default: datapath_tb

%.o: %.vhdl
	$(CC) -a $^

datapath_tb: $(DEPS) datapath_tb.o
	$(CC) -e datapath_tb
	$(CC) -r datapath_tb --vcd=$@.vcd

clean:
	rm *.o *_tb *.cf *.vcd

