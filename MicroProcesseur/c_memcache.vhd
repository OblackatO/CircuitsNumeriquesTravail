----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:36 11/12/2019 
-- Design Name: 
-- Module Name:    c_memcache - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity c_memcache is
	PORT(clk, write_read_cpu, cache_activation: IN STD_LOGIC;
		 data_cpu_entry: IN STD_LOGIC_VECTOR(7 downto 0);
		 data_cpu_exit: OUT STD_LOGIC_VECTOR(7 downto 0);
		 address_cpu: IN STD_LOGIC_VECTOR(15 downto 0);
		 ack_cpu : OUT STD_LOGIC;
		);
end c_memcache;

architecture Behavioral of c_memcache is
	type MEMORY is array (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
	type ADDRESSE is array (integer range <>) of STD_LOGIC_VECTOR(15 downto 0);
		SIGNAL cache_data : MEMORY(0 to 15);
		SIGNAL cache_addr : ADRESSE(0 to 15);


begin -- processes

    write : PROCESS(clk) BEGIN
            IF clk'event and clk = '1' then  
                IF write_read_cpu = '1' AND cache_activation = '1' then 
                   for I in 0 to 15 loop
						if address_cpu = cache_addr(I) THEN
						end if;
                end if;
            end if;
    end PROCESS;

end Behavioral;

