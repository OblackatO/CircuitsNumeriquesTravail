----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:46:52 10/01/2019 
-- Design Name: 
-- Module Name:    Carrefour_source - Behavioral 
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

ENTITY Carrefour_source IS
PORT(FPrA, FPrB_A, FPrB_G, FSec: OUT BIT_VECTOR(1 TO 3);
	Det_A, Det_B: IN BIT;
	clk, rst: IN BIT);

END Carrefour_source;

ARCHITECTURE Architec OF Carrefour_source IS
	SIGNAL cnt: INTEGER RANGE 0 TO 30;
	SIGNAL state: INTEGER RANGE 0 TO 10;

BEGIN
p: PROCESS(clk, rst) BEGIN
	IF rst = "1"
	THEN cnt <= 0;
		state <= 1;
		FPrA <= "010";
		FPrB_A <= "010";
		FPrB_G <= "010";
		FSec <= "010";
	ELSIF clk'event AND clk = "1"
	THEN CASE state IS
		WHEN 1 => IF cnt = 8
			THEN state <= 3;
				cnt <= 0;
				FPrA <= "100";
				FPrB_A <= "100";
				FPrB_G <= "100";
				FSec <= "100";
			ELSE cnt <= cnt + 1;
				state <= 2;
				FPrA <= "000";
				FPrB_A <= "000";
				FPrB_G <= "000";
				FSec <= "000";
			END IF;
		WHEN 2 => cnt <= cnt + 1;
			state <= 1;
			FPrA <= "010";
			FPrB_A <= "010";
			FPrB_G <= "010";
			FSec <= "010";
		WHEN 3 => state <= 4;
			FPrA <= "001";
			FPrB_A <= "001";
			FPrB_G <= "100";
			FSec <= "100";
		WHEN 4 =>
			IF cnt /= 30 THEN cnt <= cnt + 1;
			ELSIF cnt = 30 AND Det_A = 1 THEN
				state <= 5;
				FPrA <= "010";
				FPrB_A <= "001";
				FPrB_G <= "100";
				FSec <= "100";
				cnt <= 0;
			ELSIF cnt = 30 AND Det_B = 1 AND Det_A = 0 THEN
				state <= 9;
				FPrA <= "010";
				FPrB_A <= "010";
				FPrB_G <= "100";
				FSec <= "100";
				cnt <= 0;
			END IF;
		WHEN 5 => state <= 6;
			FPrA <= "100";
			FPrB_A <= "001";
			FPrB_G <= "001";
			FSec <= "100";
		WHEN 6 =>
			IF cnt /= 10 THEN cnt <= cnt +1;
			ELSIF (cnt = 10 OR Det_A = 0) AND Det_B = 0 THEN cnt <= 0;
				state <= 7;
				FPrA <= "100";
				FPrB_A <= "001";
				FPrB_G <= "010";
				FSec <= "100";
			ELSIF (cnt = 10 OR Det_A = 0) AND Det_B = 1 THEN cnt <= 0;
				state <= 8;
				FPrA <= "100";
				FPrB_A <= "010";
				FPrB_G <= "010";
				FSec <= "100";
			END IF;
		WHEN 7 =>  state <= 4;
			FPrA <= "001";
			FPrB_A <= "001";
			FPrB_G <= "100";
			FSec <= "100";
		WHEN 8 => state <= 10;
			FPrA <= "100";
			FPrB_A <= "100";
			FPrB_G <= "100";
			FSec <= "001";
		WHEN 9 => state <= 10;
			FPrA <= "100";
			FPrB_A <= "100";
			FPrB_G <= "100";
			FSec <= "001";
		WHEN 10 =>
			IF cnt /= 10 THEN cnt <= cnt +1;
			ELSIF cnt = 10 OR Det_B = 0 THEN state <= 11;
				cnt <= 0;
				FPrA <= "100";
				FPrB_A <= "100";
				FPrB_G <= "100";
				FSec <= "010";
			END IF;
		WHEN 11 =>  state <= 4;
			FPrA <= "001";
			FPrB_A <= "001";
			FPrB_G <= "100";
			FSec <= "100";
			
	END IF;
	
	
	
END process;
END Architect;

