proc clock {} {
	isim force add clk 1
	run 20 ns
	isim force add clk 0
	run 20 ns
}

proc reset {} {
	isim force add det_a 0
	isim force add det_b 0
	#isim force add fpra "000"
	#isim force add fprb_a "000"
	#isim force add fprb_g "000"
	#isim force add fsec "000"
	#isim force add cnt 0
	#isim force add state 1
	run 200 ns
	isim force add rst 1
	run 20 ns
	isim force add rst 0
	run 20 ns
}

reset

for {set i 0} {$i < 10} {incr i} {
	clock
}
for {set i 0} {$i < 33} {incr i} {
	clock
}
isim force add det_a 1
clock
clock 
for {set i 0} {$i < 5} {incr i} {
	clock
}
isim force add det_a 0
for {set i 0} {$i < 10} {incr i} {
	clock
}