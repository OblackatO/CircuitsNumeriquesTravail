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
			write_read, ram_activation: OUT STD_LOGIC;
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
			write_read <= '0'; --0 to read ram, 1 to write
			ram_activation <= '1';
			address_register(1) <= "00000000";
			address_register(2) <= "00000000";
			address <= "0000000000000000";
		ELSIF clk'event AND clk = '1' THEN
			CASE state IS
				
				WHEN "001" =>
					seq_register(1) <= data_entry;
					--Soit on est dans les premiers jeux d'intructions, soit dans LD, ST ou JMP en mode addressage indirecte
					IF (data_entry(7) = '0' OR (data_entry(6) = '0' AND data_entry(5) = '0' ) ) THEN
						state <= "100";
						ram_activation <= '0';
						--Mode addressage indirect LD or ST
						IF data_entry(7) = '1' THEN
							-- LD
							IF data_entry(4 downto 3) = "00" THEN
								address <= regs(6) & regs(7);
								write_read <= '0';
								ram_activation <= '1';
							-- ST
							ELSIF data_entry(4 downto 3) = "01" THEN
								address <= regs(6) & regs(7);
								write_read <= '1';
								ram_activation <= '1';
							END IF;
						END IF;
					ELSE state <= "010";
						ram_activation <= '1';
						write_read <= '0';
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
					--On est en LD, ST ou JMP mode addressage mixte ou JMP mode relatif
					IF seq_register(1)(7) = '1' THEN	
						--mode addressage mixte
						IF seq_register(1)(6 downto 5) = "01" THEN
							state <= "100";
							--LD
							IF seq_register(1)(4 downto 3) = "00" THEN
								address <= data_entry & regs(7);
								ram_activation <= '1';
								write_read <= '0';
							--ST
							ELSIF seq_register(1)(4 downto 3) = "01" THEN
								address <= data_entry & regs(7);
								ram_activation <= '1';
								write_read <= '1';
							--JMP
							ELSIF seq_register(1)(4 downto 3) = "10" THEN
								ram_activation <= '0';
							END IF;
						--mode LD constante ou JMP relatif
						ELSIF seq_register(1)(6 downto 5) = "11" THEN
							state <= "100";
							ram_activation <= '0';
						ELSE state <= "011";
							ram_activation <= '1';
							write_read <= '0';
							IF address_register(1) = "11111111" THEN
								address_register(2) <= address_register(2) + "00000001";
								address <= address_register(2) + "00000001" & "00000000";
							ELSE
								address_register(1) <= address_register(1) + "00000001";
								address <= address_register(2) & address_register(1) + "00000001";
							END IF;
						END IF;
					END IF;
					
				WHEN "011" =>
					seq_register(3) <= data_entry;
					state <= "100";
					-- LD mode addressage directe
					IF seq_register(1)(4 downto 3) = "00" THEN
						address <= seq_register(2) & data_entry;
						ram_activation <= '1';
						write_read <= '0';
					-- ST mode addressage directe
					ELSIF seq_register(1)(4 downto 3) = "01" THEN
						address <= seq_register(2) & data_entry;
						ram_activation <= '1';
						write_read <= '1';
					-- JMP mode addressage directe
					ELSIF seq_register(1)(4 downto 3) = "10" THEN
						ram_activation <= '0';
					END IF;
					
				WHEN "100" =>
					state <= "001";
					ram_activation <= '1';
					write_read <= '0';
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
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)))) <= regs(to_integer(Unsigned(seq_register(1)(5 downto 3))));
							END IF;
						END IF;
					ELSIF seq_register(1)(7) = '1' THEN
						IF seq_register(1)(4) ='0' AND seq_register(1)(3)='0' THEN
							IF seq_register(1)(6) = '1' AND seq_register(1)(5) = '1' THEN
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)))) <= seq_register(2);
							ELSE
								regs(to_integer(Unsigned(seq_register(1)(2 downto 0)))) <= data_entry;
							END IF;
						
						ELSIF seq_register(1)(4) ='0' AND seq_register(1)(3)='1' THEN
							IF seq_register(1)(6) = '1' AND seq_register(1)(5) = '1' THEN
									-- not implemented
							ELSE 
								data_out <= regs(to_integer(Unsigned(seq_register(1)(2 downto 0))));
							END IF;
						
						ELSIF seq_register(1)(4) ='1' AND seq_register(1)(3)='0' THEN
							-- JMP
							IF flag_reg(to_integer(Unsigned(seq_register(1)(2 downto 0)))) = '1' THEN
								IF seq_register(1)(6 downto 5) = "01" THEN 		--mixte
									address_register(1) <= seq_register(2);
								ELSIF seq_register(1)(6 downto 5) = "10" THEN 	-- direct 10
									address_register(1) <= seq_register(2);
									address_register(2) <= seq_register(3);
								ELSIF seq_register(1)(6 downto 5) = "11" THEN 	-- relativ 11
									address_register(1) <= seq_register(2) + address_register(1);
								END IF;
							END IF;
						END IF;		
					END IF;
					ram_activation <= '1';
				WHEN OTHERS => null;
			END CASE;
		END IF;
   end PROCESS;
	
	
	
	alu : PROCESS(regs, seq_register)
			variable op1, op2, res: STD_LOGIC_VECTOR(8 downto 0);
		BEGIN
		op1(7 downto 0) := regs(1);
		op1(8) := regs(1)(7);
		op2(7 downto 0) := regs(2);
		op2(8) := regs(2)(7);
		CASE seq_register(1)(3 downto 0) IS
			WHEN "0000" => 
				-- ADD
				res := op1 + op2;
				flag_reg(7) <= res(8) xor res(7);
				flag_reg(6) <= res(8) xor op1(8) xor op2(8);
				regs(1) <= res;
			WHEN "0001" => 
				-- SUB
				res := op1 - op2;
				flag_reg(7) <= res(8) xor res(7);
				flag_reg(6) <= res(8) xor op1(8) xor op2(8);
				regs(1) <= res;
			WHEN "0010" => 
				-- CMP
				res := op1 - op2;
				flag_reg(7) <= res(8) xor res(7);
				flag_reg(6) <= res(8) xor op1(8) xor op2(8);
			WHEN "0011" =>
				-- AND
				res := op1 and op2;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
				regs(1) <= res;
			WHEN "0100" =>
				-- OR
				res := op1 or op2;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
				regs(1) <= res;
			WHEN "0101" =>
				-- XOR
				res := op1 xor op2;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
				regs(1) <= res;
			WHEN "0110" =>
				-- CPL 
				res := op1;
				res(7) := not op1(7);
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
				regs(1) <= res;
			WHEN "0111" =>
				-- NOT 
				res := not op1;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
				regs(1) <= res;
			WHEN "1000" =>
				--rotation R
				res := op1(0) & op1(8 downto 1);
				regs(1) <= res;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
			WHEN "1001" =>
				--rotation L
				res := op1(7 downto 0) & op1(8);
				regs(1) <= res;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
			WHEN "1010" =>
				--SHIFT RIGHT UNSIGNED
				res := '0' & op1(8 downto 1);
				regs(1) <= res;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
			WHEN "1011" =>
				--SHIFT RIGHT SIGNED
				res := op1(8) & op1(8 downto 1);
				regs(1) <= res;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
			WHEN "1100" =>
				--SHIFT LEFT
				res :=  op1(8 downto 1) & '0';
				regs(1) <= res;
				flag_reg(6) <= '0';
				flag_reg(7) <= '0';
			WHEN "1101" =>
			WHEN "1110" =>
			WHEN "1111" =>
			WHEN OTHERS => null;			
		END CASE;
		
		IF res = 0 THEN -- zero ou pas zero
		flag_reg(1) <= '1';
		flag_reg(2) <= '0';
		ELSE
			flag_reg(1) <= '0';
			flag_reg(2) <= '1';
		END IF;
		
		IF res(8) = '1' THEN -- positif et neg
			flag_reg(3) <= '0';
			flag_reg(4) <= '1';
		ELSE 
			flag_reg(3) <= '1';
			flag_reg(4) <= '0';
		END IF;
		
		IF res(0) = '0' THEN -- pair ou impair
			flag_reg(5) <= '1';
		ELSE
			flag_reg(5) <= '0';
		END IF;
	end process;
	
end Behavioral;

-- flag_reg
