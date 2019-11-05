----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:15 10/29/2019 
-- Design Name: 
-- Module Name:    sequenseur - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SEQUENSEUR is
    PORT(clk, rst: IN STD_LOGIC;
			write_read: OUT STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
         address: OUT STD_LOGIC_VECTOR(15 downto 0)
        );

    
end SEQUENSEUR;

architecture Behavioral of SEQUENSEUR is
	TYPE registre IS ARRAY (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL state: INTEGER RANGE 1 TO 4;
	SIGNAL seq_register: registre(1 to 3);
	SIGNAL address_register: registre (2 DOWNTO 1);
begin
   seq : PROCESS(clk, rst) BEGIN
		IF rst = '1' THEN
			state <= 1;
			address_register(1) <= "00000000";
			address_register(2) <= "00000000";
			address <= address_register(2) & address_register(1);
		ELSIF clk'event AND clk = '1' THEN
			CASE state IS
				WHEN 1 =>
					seq_register(1) <= data_entry;
					IF (seq_register(1)(7) = '0' OR (seq_register(1)(6) = '0' AND seq_register(1)(5) = '0' )) THEN
						state <= 4;
					ELSE state <= 2;
						address_register(1) <= address_register(1) + "00000001";
						IF address_register(1) = "00000000" THEN
							address_register(2) <= address_register(2) + "00000001";
						END IF;
						address <= address_register(2) & address_register(1);
					END IF;
				WHEN 2 =>
					seq_register(2) <= data_entry;
					IF seq_register(1)(7) = '1' AND ( (seq_register(1)(6) = '0' AND seq_register(1)(5) = '1') OR (seq_register(1)(6) = '1' AND seq_register(1)(5) = '1') ) THEN
						state <= 4;
					ELSE state <= 3;
						address_register(1) <= address_register(1) + "00000001";
						IF address_register(1) = "00000000" THEN
							address_register(2) <= address_register(2) + "00000001";
						END IF;
						address <= address_register(2) & address_register(1);
					END IF;
				WHEN 3 =>
					seq_register(3) <= data_entry;
					state <= 4;
				WHEN 4 =>
					state <= 1;
					address_register(1) <= address_register(1) + "00000001";
					IF address_register(1) = "00000000" THEN
						address_register(2) <= address_register(2) + "00000001";
					END IF;
					
					--not implemented
					address <= address_register(2) & address_register(1);
				WHEN OTHERS => null;
			END CASE;
		END IF;
   end PROCESS;
end Behavioral;

