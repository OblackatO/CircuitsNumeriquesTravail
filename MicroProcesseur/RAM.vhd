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
         address: IN STD_LOGIC_VECTOR(15 downto 0)
        );

    
end RAM;

architecture Behavioral of RAM is
    type MEMORY is array (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL mem_r, mem_w : MEMORY(0 to 1024-1 );
    SIGNAL bios : MEMORY(0 to 255);
begin
    mem_r(256 to 1023) <= mem_w(256 to 1023);
    mem_r(0 to 255) <= bios;
    read : PROCESS(write_read, mem_r, address) BEGIN
            IF write_read = '0' AND activation = '1' then  
                data_exit <= mem_r(to_integer(Unsigned(address)));
            ELSE data_exit <= "ZZZZZZZZ";
            end if;
    end PROCESS;

    write : PROCESS(clk) BEGIN
            IF clk'event and clk = '1' then  
                IF write_read = '1' AND activation = '1' then 
                    mem_w(to_integer(Unsigned(address))) <= data_entry;
                end if;
            end if;
    end PROCESS;
	 
	 bios(0 to 5) <= ("00000000",
					"10100000", "00111010",
					"11010000", "10100110","00110000");
	 
end Behavioral;

