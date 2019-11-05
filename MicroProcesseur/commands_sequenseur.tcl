proc clock {} {
	isim force add clk 1
	run 20 ns
	isim force add clk 0
	run 20 ns
}

proc reset {} {
	run 500 ns
    isim force add rst 1
		clock
		isim force add rst 0
}

reset

clock
clock
clock
clock
clock


for {set i 0} {$i < 800} {incr i} {
	clock
}
