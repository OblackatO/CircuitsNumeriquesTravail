proc clock {} {
	isim force add clk 1
	run 20 ns
	isim force add clk 0
	run 20 ns
}

proc reset {} {
	run 500 ns
    isim force add write_read 0
    isim force add address 0
    isim force add data_entry  0
}

reset
isim force add write_read 1
isim force add address "1"
isim force add data_entry "3"
clock
isim force add write_read 0
clock
isim force add write_read 1
isim force add address "42"
isim force add data_entry "98"
clock
isim force add write_read 0
clock
isim force add address 1
isim force add write_read 0
clock


#for {set i 0} {$i < 10} {incr i} {
#	clock
#}

