----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:28 10/15/2019 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    PORT(clk, write_read, activation: IN STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
         data_exit: OUT STD_LOGIC_VECTOR(7 downto 0);
         address: IN STD_LOGIC_VECTOR(15 downto 0);
			
			interface_exit: OUT STD_LOGIC_VECTOR(31 downto 0);
			interface_entry: IN STD_LOGIC_VECTOR(15 downto 0)
        );

    
end RAM;

architecture Behavioral of RAM is
    type MEMORY is array (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL ramMemory : MEMORY(0 to 1023 );
    SIGNAL bios : MEMORY(0 to 249);
	 SIGNAL interface_display : MEMORY(250 to 253);
	 SIGNAL read_only_memory: MEMORY(0 to 255);
begin

	read_only_memory(0 to 249) <= bios;
	 -- 0 to 249: bios
	 
	 -- 250: MSB addresse
	 -- 251: LSB addresse
	 -- 252: current RAM value
	 -- 253: dip switch value
	 
	 --to MSB & LSB & current RAM value & dip switch value
	 
	 -- 254: DIP switch state
	 -- 255: buttons state
	 
	 -- to DIP switch state & buttons state

    write_memory : PROCESS(clk) BEGIN
				IF clk'event and clk = '1' then
					IF address(15 downto 8) /= "00000000" THEN				
						IF write_read = '1' AND activation = '1' then 
							ramMemory(to_integer(Unsigned(address))) <= data_entry;
						end if;
					END IF;
            end if;
    end PROCESS;
	 
	 --change Values to be 
	  write_interface_output : PROCESS(clk) BEGIN
			IF clk'event and clk = '1' then  
				IF write_read = '1' AND activation = '1' then
					IF address(15 downto 8) = "00000000" THEN
						IF address(7 downto 0) = "11111101" OR address(7 downto 0) = "11111100" OR address(7 downto 0) = "11111011" OR address(7 downto 0) = "11111010" THEN
							interface_display(to_integer(Unsigned(address(7 downto 0)))) <= data_entry;
						end if;
					end if;
				end if;
				
				interface_exit <= interface_display(250) & interface_display(251) & interface_display(252) & interface_display(253);
				
			end if;
    end PROCESS;
	 
	
	
	update_read_only_memory : PROCESS(interface_display, interface_entry) BEGIN
			read_only_memory(250 to 255) <= interface_display & interface_entry;
	end PROCESS;
	
	--interface_display & interface_entry ===>>> Check if a new array is created or if bits are changed
	


	read_memory : PROCESS(write_read, address) BEGIN
		IF write_read = '0' AND activation = '1' then
			IF address(15 downto 8) /= "00000000" THEN
				data_exit <= ramMemory(to_integer(Unsigned(address)));
			ELSE 
				data_exit <= read_only_memory(to_integer(Unsigned(address(7 downto 0))));
			END IF;
		ELSE data_exit <= "ZZZZZZZZ";
		end if;
	end PROCESS;
	 
	 
	 
	 
	 bios(0 to 12) <= (
"11100110",
"00000000",
"11100111",
"00000000",
"11001111",
"00000000",
"11111011",
"11001110",
"00000000",
"11111010",
"10000101",
"11001101",
"00000000",
"11111100",
"11000101",
"00000000",
"11111110",
"11001101",
"00000000",
"11111101",
"11000101",
"00000000",
"11111111",
"11100001",
"00000000",
"00101000",
"01000010",
"11010001",
"10000000",
"00000000",
"11100001",
"10000000",
"01000010",
"11010010",
"10110000",
"00000000",
"00110000",
"11100001",
"11111111",
"01000000",
"00000110",
"11010000",
"11100010",
"00000000",
"00101000",
"11100001",
"01000000",
"01000010",
"11010010",
"11101100",
"00000000",
"00110000",
"11100001",
"11111111",
"01000001",
"00000110",
"11010000",
"11100010",
"00000000",
"00101000",
"11100001",
"00100000",
"01000010",
"11010010",
"10010100",
"00000000",
"00111000",
"11100001",
"11111111",
"01000000",
"00000111",
"11010000",
"11100010",
"00000000",
"00101000",
"11100001",
"00010000",
"01000010",
"11010010",
"10110010",
"00000000",
"00111000",
"11100001",
"11111111",
"01000001",
"00000111",
"11010000",
"11100010",
"00000000",
"00101000",
"11100001",
"00001000",
"01000010",
"11010010",
"11001110",
"00000000",
"11000100",
"00000000",
"11111110",
"10001100",
"11010000",
"11100010",
"00000000",
"00101000",
"11100001",
"00000100",
"01000010",
"11010010",
"11100010",
"00000000",
"11010000",
"00000001",
"00000000",
"11000101",
"00000000",
"11111111",
"00101000",
"11100001",
"00000000",
"01000010",
"11010001",
"10000000",
"00000000",
"11010000",
"11100010",
"00000000"
);

	 
end Behavioral;

