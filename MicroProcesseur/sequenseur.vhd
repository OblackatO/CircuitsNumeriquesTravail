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

entity CPU is
    PORT(clk, rst: IN STD_LOGIC;
			write_read: OUT STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
			data_out: OUT STD_LOGIC_VECTOR(7 downto 0);
         address: OUT STD_LOGIC_VECTOR(15 downto 0)
        );

    
end CPU;

architecture Behavioral of CPU is
	TYPE registre IS ARRAY (integer range <>) of STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL state: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL seq_register: registre(1 to 3); -- 1er place -- 2eme -- 3eme
	SIGNAL address_register: registre (2 DOWNTO 1); 
	SIGNAL regs: registre(1 to 8);
	SIGNAL alu_regs : registre(0 to 1);
	SIGNAL flag_reg :  STD_LOGIC_VECTOR(7 downto 0);
begin
   sequenceur : PROCESS(clk, rst) BEGIN
		IF rst = '0' THEN
			state <= "001";
			write_read <= '0';
			address_register(1) <= "00000000";
			address_register(2) <= "00000000";
			address <= "0000000000000000";
		ELSIF clk'event AND clk = '1' THEN
			CASE state IS
				WHEN "001" =>
					seq_register(1) <= data_entry;
					IF (data_entry(7) = '0' OR (data_entry(6) = '0' AND data_entry(5) = '0' ) ) THEN
						state <= "100";
						IF data_entry(7) = '1' AND (data_entry(4 downto 3) = "00" OR data_entry(4 downto 3) = "01") THEN
							-- addressage indirecte
							address <= regs(6) & regs(7);
						END IF;
					ELSE state <= "010";
						IF address_register(1) = "11111111" THEN
							address_register(2) <= address_register(2) + "00000001";
							address <= address_register(2) + "00000001" & "00000000";
						ELSE
							address_register(1) <= address_register(1) + "00000001";
							address <= address_register(2) & address_register(1) + "00000001";
						END IF;
					END IF;
				WHEN "010" =>
					seq_register(2) <= data_entry;
					IF seq_register(1)(7) = '1' AND ( (seq_register(1)(6) = '0' AND seq_register(1)(5) = '1') OR (seq_register(1)(6) = '1' AND seq_register(1)(5) = '1') ) THEN
						state <= "100";
						IF NOT (seq_register(1)(4) = '1' AND seq_register(1)(3) = '0') THEN
							-- addressage mixte
							address <= data_entry & regs(7);
						END IF;
					ELSE state <= "011";
						IF address_register(1) = "11111111" THEN
							address_register(2) <= address_register(2) + "00000001";
							address <= address_register(2) + "00000001" & "00000000";
						ELSE
							address_register(1) <= address_register(1) + "00000001";
							address <= address_register(2) & address_register(1) + "00000001";
						END IF;
					END IF;
				WHEN "011" =>
					seq_register(3) <= data_entry;
					state <= "100";
					IF NOT (seq_register(1)(4) = '1' AND seq_register(1)(3) = '0') THEN
						-- addressage directe 
						address <= seq_register(2) & data_entry;
					END IF;
				WHEN "100" =>
					state <= "001";
					IF address_register(1) = "11111111" THEN
						address_register(2) <= address_register(2) + "00000001";
						address <= address_register(2) + "00000001" & "00000000";
					ELSE
						address_register(1) <= address_register(1) + "00000001";
						address <= address_register(2) & address_register(1) + "00000001";
					END IF;
					
					IF seq_register(1)(7) = '0' THEN
						IF seq_register(1)(6) = '0' THEN
							IF to_integer(Unsigned(seq_register(1)(2 downto 0))) = to_integer(Unsigned(seq_register(1)(5 downto 3))) THEN
							 --Not implemented
							ELSE
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)))) <= regs(to_integer(Unsigned(seq_register(1)(5 downto 3))))
							END IF;
						ELSIF seq_register(1)(6) = '1' AND seq_register(1)(5) = '1' THEN
							IF seq_register(1)(4) = '1' THEN
								-- Write
								alu_regs(to_integer(Unsigned(seq_register(1)(3))  <= regs(to_integer(Unsigned(seq_register(1)(2 downto 0));
							ELSE
								-- Read
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)) <= alu_regs(to_integer(Unsigned(seq_register(1)(3))
							END IF;
                                       
					ELSIF seq_register(1)(7) = '1' THEN
						IF seq_register(1)(4) ='0' AND seq_register(1)(3)='0' THEN
							IF seq_register(1)(6) = '1' AND seq_register(1)(5) = '1' THEN
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)) <= seq_register(2);
							ELSE
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)) <= data_entry;
							END IF;
						
						ELSIF seq_register(1)(4) ='0' AND seq_register(1)(3)='1' THEN
							IF seq_register(1)(6) = '1' AND seq_register(1)(5) = '1' THEN
									-- not implemented
							ELSE 
								data_out <= regs(to_integer(Unsigned(seq_register(1)(2 downto 0));
							END IF;
						
						ELSIF seq_register(1)(4) ='1' AND seq_register(1)(3)='0' THEN
							-- JMP
							IF flag_reg(to_integer(Unsigned(seq_register(1)(2 downto 0)))) = '1' THEN
							END IF;
								
								
						
						END IF;
						
						
						
					END IF;
					--not implemented
				WHEN OTHERS => null;
			END CASE;
		END IF;
   end PROCESS;
	
	
	
	--alu : PROCESS() BEGIN
	
	--end process;
	
end Behavioral;

