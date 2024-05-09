vec_uart_rw:
	echo \`define VCDDUMP > TestDef.v
	cp -r $@.v testvec.v
	iverilog TestTop.v -o $@.o -y ../rtl
	vvp $@.o
	rm $@.o	

GTK:
	export DISPLAY=:0
	gtkwave

