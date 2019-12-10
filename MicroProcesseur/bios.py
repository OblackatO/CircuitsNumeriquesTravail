"""
"""

registre6 = 0
registre7 = 0

r = input("c?:")

while r != 'n':
    print("store LSB dans 251")
    print("store MSB dans 250")
    print("load registre6_registre7")
    print("store value dans 252")
    print("load 254")
    print("store switch dans 253")
    print("load 255")
    res = input("value_bit:")
    if res == "0000 0000":
        continue
    if res == "1000 0000":
        print("inc registre6") 
    elif res == "0100 0000":
        print("dec registre6")
    elif res == "0010 0000":
        print("inc registre7")
    elif res == "0001 0000":
        print("dec registre7")
    elif res == "0000 1000":
        print("load 254")
        print("store switch state registre6_registre7")
    elif res ==  "0000 0100":
        print("jmp  256")
    while True:
        res2 = input("res2:")
        print("load 255")
        if res2 == "0000 0000":
            break
        else:
            continue 
    r = input("c?:")
