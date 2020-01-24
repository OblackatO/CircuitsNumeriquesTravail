import sys
from typing import List


class AssemblyParser:

    """
    Has all the functions necessary for the conversion
    from assembly to binary.
    """
    COMMANDS_OCTETS = {
        1 : "MOV, ALU, LDind, STind",
        2 : "LDmix, LDc, STmix, JMPmix, JMPrel",
        3 : "LDdir, STdir, JMPdir",
    }

    TRANSLATIONS = {
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
        "NotZero" : "010",
        "Negatif" : "011",
        "Positif" : "100",
        "Pair" : "101",
        "Carry" : "110",
        "Overflow" : "111"
    }

    TRANSLATIONS_KEYS = list()

    INSTRUCTIONS_ByAddr_NUMBER = dict()
    FLAGS = dict()

    def __init__(self, instructions_file_path:str):
        """
        instrctions_file_path: FULL path to the file with 
        the assembly instructions.
        """
        self.instructions_file_path = instructions_file_path
        self.TRANSLATIONS_KEYS = self.TRANSLATIONS.keys()

    def GetFlagsAdrresses(self):
        """
        Gets the addresses for each flag, and puts the instructions which are not "flagx"
        in its corresponding index in self.INSTRUCTIONS_ByAddr_NUMBER.
        """
        assembly_code = open(self.instructions_file_path, "r")
        lines = assembly_code.readlines()
        assembly_code.close()
        current_index = 0
        for line in lines:
            result = ''.join([i for i in line if not i.isdigit()]).strip()
            if result == "flag":
                self.FLAGS[line.strip()] = current_index
            else:
                line_mod = line.split(" ")
                for word in line_mod:
                    if word != " " or word != "":
                        if word.strip() in self.TRANSLATIONS_KEYS:
                            self.INSTRUCTIONS_ByAddr_NUMBER[current_index] = line_mod
                            result = self._IncreaseIndex(instruction=word.strip())
                            if result == 0:
                                raise Exception("\nError: {}on line:{}".format(line, lines.index(line)+1))
                            current_index += result
                            break

    def _IncreaseIndex(self, instruction:str) -> int:
        """
        instruction: The instruction to analyze.
        Searches how many bytes some instruction should have in total.
        """
        for key in self.COMMANDS_OCTETS:
            if instruction.strip() in self.COMMANDS_OCTETS[key]:
                return key
        return 0

    def Show_Flags_InstructionsByAddrNum(self) -> str:
        """
        returns the value of self.FLAGS, self.INSTRUCTIONS_ByAddr_NUMBER, as a string.
        """
        return "Flags: {} \nInstructionsByAddr: {}".format(self.FLAGS, self.INSTRUCTIONS_ByAddr_NUMBER)

    def ConvertToBinary(self):
        """
        Converts to binary INSTRUCTIONS_ByAddr_NUMBER && FLAGS
        giving the final result as binary.

        NOTE: this is not yet the format to input in VHDL.
        """
        final_bytes_array = list()
        for instruction_addr in self.INSTRUCTIONS_ByAddr_NUMBER:
            #print("Instruction addr: {}".format(instruction_addr))
            supposed_total_bytes = 0
            binary_instruction = ""
            for token in self.INSTRUCTIONS_ByAddr_NUMBER[instruction_addr]:
                if token.strip() == "":
                    continue
                #print("token: {}".format(token))
                result = ''.join([i for i in token if not i.isdigit()]).strip()
                binary_instruction_length = 0
                if "addr" in token or "flag" in token:
                    binary_instruction_length = len(binary_instruction)
                if result == "flag":
                    temp_res = self._ConvertTokenToBinary(token.strip(), supposed_total_bytes,  binary_instruction_length)
                    binary_instruction += temp_res['binary_instruction_data']
                    #print("bin instruction after adding on flag condition:\n{}".format(binary_instruction))
                else:
                    temp_res = self._ConvertTokenToBinary(token, supposed_total_bytes,  binary_instruction_length)
                    if "supposed_total_bytes" in temp_res.keys():
                        supposed_total_bytes += temp_res['supposed_total_bytes']
                        #print("supposed total bytes: {}".format(supposed_total_bytes))
                    binary_instruction += temp_res['binary_instruction_data']
            if supposed_total_bytes*8 != len(binary_instruction):
                print("[CRITICAL>]Total nb of bits does not match for:\n".format(self.INSTRUCTIONS_ByAddr_NUMBER[instruction_addr]))
                print("Binary_string: {}".format(binary_instruction))
                print("Supposed bytes: {} -- len(binary_instructions): {}".format(supposed_total_bytes, len(binary_instruction)))
                sys.exit()
            final_bytes_array.append(binary_instruction)
            supposed_total_bytes = 0
            binary_instruction = ""
        return final_bytes_array

    def _ConvertTokenToBinary(self, token:str, supposed_total_bytes:int=1, bin_instruction_length:int=0):
        """
        Converts some token of some instruction to binary, e.g:
        instruction: STdir r(7) addr(251)
        This function will receive each token on the instruction above and 
        return its binary value.
        """
        token = token.strip()
        if token in self.TRANSLATIONS_KEYS and supposed_total_bytes == 0:
            return {"supposed_total_bytes":self._IncreaseIndex(token), 
                    "binary_instruction_data":self.TRANSLATIONS[token]
                    }
        elif token in self.TRANSLATIONS_KEYS:
            return {"binary_instruction_data":self.TRANSLATIONS[token]}
        elif token == "0":
            return {"binary_instruction_data":"00000000"}
        elif token == "1":
            return {"binary_instruction_data":"11111111"}
        elif "addr" in token:
            result = ""
            token = token.replace("addr(", "").replace(")", "")
            bin_result = str(format(int(token), 'b'))
           #print("len_bin result: {}".format(len(bin_result)))
            pad_length = supposed_total_bytes*8 - (bin_instruction_length + len(bin_result))
            if pad_length != 0:
                #print("pad_length on addr condition: {}".format(pad_length))
                for x in range(0,pad_length):
                    result += '0'
            result += bin_result
            #print("token: {} addr in bin: {}".format(token, result))
            return {"binary_instruction_data":result}
        elif "\"" in token:
            res = token.strip().replace("\"", "")
            #print("returning res:".format(res))
            return {"binary_instruction_data":res}
        elif "flag" in token:
            result = ""
            bin_result = str(format(self.FLAGS[token], 'b'))
            pad_length = supposed_total_bytes*8 - (bin_instruction_length + len(bin_result))
            result += bin_result
            if pad_length != 0:
                #print("pad_length on flag condition: {}".format(pad_length))
                for x in range(0,pad_length):
                    result += '0'
            return {"binary_instruction_data":result}

    def InitTranslationFlow(self):
        """
        Calls all the necessary functions to 
        get the final output to input in VHDL.
        """
        self.GetFlagsAdrresses()
        #print("Converting FLAGS && INSTRUCTIONSByAddre to binary")
        #print(self.Show_Flags_InstructionsByAddrNum())
        #print(self.ConvertToBinary())
        self.ConvertToVHDLInput(self.ConvertToBinary())

    def ConvertToVHDLInput(self, to_convert:List[str]):
        """
        Converts an array of bits to 8-bit elements:
            [
                "8-bit",
                "8-bit",
                "..."
            ]
        This will be the final output to input in VHDL.
        """
        converted_array = list()
        for element in to_convert:
            if len(element) == 8: 
                converted_array.append(element)
            elif len(element)/8 == 2:
                converted_array.append(element[0:8])
                converted_array.append(element[8:16])
            elif len(element)/8 == 3:
                converted_array.append(element[0:8])
                converted_array.append(element[8:16])
                converted_array.append(element[16:24])
            elif len(element)/8 == 4:
                converted_array.append(element[0:8])
                converted_array.append(element[8:16])
                converted_array.append(element[16:24])
                converted_array.append(element[24:32])
        print("[")
        for element in converted_array:
            print("\"{},\"".format(element))
        print("]")
        print("[>]Copy&Paste the string above in VHDL.")
