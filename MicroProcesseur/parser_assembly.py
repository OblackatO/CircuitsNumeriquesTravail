from typing import List

final_array: List[str] = []

commands_octets = {
    "MOV, ALU, LDind, STind" : "1",
    "LDmix, LDc, STmix, JMPmix, JMPrel" : "2",
    "LDdir, STdir, JMPdir" : "3"
}

translations = {
    "MOV": "00",
    "r(0)": "000",
    "r(1)": "001",
    "r(2)": "010",
    "r(3)": "011",
    "r(4)": "100",
    "r(5)": "101",
    "r(6)": "110",
    "r(7)": "111",
    #ALU
    "ALU" : "0100",
    "ADD" : "0000",
    "SUB" : "0001",
    "CMP" : "0010",
    "AND" : "0011",
    "OR" : "0100",
    "XOR" : "0101",
    "CPL" : "0110",
    "NOT" : "0111",
    "ROTR" : "1000",
    "ROTL" : "1001",
    "SHRU" : "1010",
    "SHRS" : "1011",
    "SHL" : "1100",
    #Loads
    "LDind" : "10000",
    "LDmix" : "10100",
    "LDdir" : "11000",
    "LDc" : "11100",
    #store
    "STind" : "10001",
    "STmix" : "10101",
    "STdir" : "11001",
    #jmp
    "JMPmix" : "10110",
    "JMPdir" : "11010",
    "JMPrel" : "11110",
    #flags for jump
    "Absolue" : "000",
    "Zero"  : "001",
    "Not Zero" : "010",
    "Negatif" : "011",
    "Positif" : "100",
    "Pair" : "101",
    "Carry" : "110",
    "Overflow" : "111"
}
"""
if flag5 alone, ignore, but look the address of the next instruction.

Make a tour to save flags, make another one to replace instructions binary .

if number alone in 3th position -> binary 1 byte .
if addr in 3th position -> binary 2 bytes.
"""

assembly_addrs = dict()
def main():
    assembly_code = open("bios2", "r")
    lines = assembly_code.readlines()
    current_index = 0
    for line in lines:
        if "flag" not in line:

