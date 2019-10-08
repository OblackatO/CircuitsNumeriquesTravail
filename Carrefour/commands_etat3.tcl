run 200 ns
isim force add rst 1
run 20 ns
isim force add rst 0
run 20 ns
for {set i 0} {$i < 10} {incr i} {
	isim force add clk 1
	run 20 ns
	isim force add clk 0
	run 20 ns
}
