transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/anuki/OneDrive\ -\ University\ of\ Moratuwa/Documents/Anuki/Campus/Semester\ 4/EN2111\ Electronic\ Circuit\ Design/lab4 {C:/Users/anuki/OneDrive - University of Moratuwa/Documents/Anuki/Campus/Semester 4/EN2111 Electronic Circuit Design/lab4/transmitter.sv}
vlog -sv -work work +incdir+C:/Users/anuki/OneDrive\ -\ University\ of\ Moratuwa/Documents/Anuki/Campus/Semester\ 4/EN2111\ Electronic\ Circuit\ Design/lab4 {C:/Users/anuki/OneDrive - University of Moratuwa/Documents/Anuki/Campus/Semester 4/EN2111 Electronic Circuit Design/lab4/receiver.sv}
vlog -sv -work work +incdir+C:/Users/anuki/OneDrive\ -\ University\ of\ Moratuwa/Documents/Anuki/Campus/Semester\ 4/EN2111\ Electronic\ Circuit\ Design/lab4 {C:/Users/anuki/OneDrive - University of Moratuwa/Documents/Anuki/Campus/Semester 4/EN2111 Electronic Circuit Design/lab4/uart.sv}
vlog -sv -work work +incdir+C:/Users/anuki/OneDrive\ -\ University\ of\ Moratuwa/Documents/Anuki/Campus/Semester\ 4/EN2111\ Electronic\ Circuit\ Design/lab4 {C:/Users/anuki/OneDrive - University of Moratuwa/Documents/Anuki/Campus/Semester 4/EN2111 Electronic Circuit Design/lab4/testbench.sv}
vlog -sv -work work +incdir+C:/Users/anuki/OneDrive\ -\ University\ of\ Moratuwa/Documents/Anuki/Campus/Semester\ 4/EN2111\ Electronic\ Circuit\ Design/lab4 {C:/Users/anuki/OneDrive - University of Moratuwa/Documents/Anuki/Campus/Semester 4/EN2111 Electronic Circuit Design/lab4/binary_to_7seg.sv}

