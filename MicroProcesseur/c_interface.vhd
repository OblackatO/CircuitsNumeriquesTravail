----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:34 12/03/2019 
-- Design Name: 
-- Module Name:    c_interface - Behavioral 
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

entity c_interface is
    PORT(clk, rst: IN STD_LOGIC;
			data_entry: IN STD_LOGIC_VECTOR(31 downto 0);
			input_data: OUT STD_LOGIC_VECTOR(15 downto 0);

			physical_buttons: IN STD_LOGIC_VECTOR(0 to 4);
			physical_switchs: IN STD_LOGIC_VECTOR(0 to 7);
			physical_segment: OUT STD_LOGIC_VECTOR(0 to 7);
			physical_segment_activation: OUT STD_LOGIC_VECTOR(0 to 3)
			
			
        );
end c_interface;

architecture Behavioral of c_interface is
	SIGNAL clk_counter:  STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL button_maj, maj_delay:  STD_LOGIC;
	SIGNAL clk_button:  STD_LOGIC;
	SIGNAL button_state: STD_LOGIC_VECTOR(0 to 4);
	SIGNAL switch_state: STD_LOGIC_VECTOR(0 to 7);
	SIGNAL segment_digit: STD_LOGIC_VECTOR(0 to 7);
	
begin

	clock_counter : PROCESS(clk, rst) BEGIN
		IF rst = '0' THEN
			clk_counter <= 0;
		ELSIF clk'event AND clk = '1' THEN
			clk_counter <= clk_counter + 1;
			clk_button <= clk_counter(15);
		END IF;		
	END PROCESS;
	
		buttons_manager : PROCESS(rst, clk_button) BEGIN
		IF rst = '0' THEN
			button_maj <= 0;
		ELSIF clk_button'event AND clk_button = '1' THEN
			button_state <= physical_buttons;
			switch_state <= physical_switchs;
			IF maj_delay = '0' AND button_state(4) = 1 THEN
				button_maj <= not button_maj;
			END IF;
			
		END IF;		
	END PROCESS;
	
	display_selector : PROCESS(clk_counter, button_maj, data_entry)
		variable data_to_display:  STD_LOGIC_VECTOR(15 downto 0);
	BEGIN
		--data selection
		CASE button_maj IS
			WHEN '0' =>
				data_to_display := data_entry(31 downto 16);
			WHEN '1' =>
				data_to_display := data_entry(15 downto 0);
			WHEN OTHERS => null;
		END CASE;
		
		--segment(digit) selection
		CASE clk_counter(1 downto 0) IS
			WHEN "00" =>
				physical_segment_activation <= "0111";
				segment_digit <= data_to_display(15 downto 8);
			WHEN "01" =>
				physical_segment_activation <= "1011";
				segment_digit <= data_to_display(7 downto 0);
			WHEN "10" =>
				physical_segment_activation <= "1101";
				segment_digit <= data_to_display(15 downto 8);
			WHEN "11" =>
				physical_segment_activation <= "1110";
				segment_digit <= data_to_display(7 downto 0);
			WHEN OTHERS => null;
		END CASE;	
	END PROCESS;
	
	segment_encoder : PROCESS(button_maj, segment_digit, physical_segment_activation) BEGIN
		--display maj point
		IF physical_segment_activation = "1110" AND button_maj = '1' THEN
			physical_segment(7) <= '1';
		ELSE
			physical_segment(7) <= '0';
		END IF;
		
		CASE segment_digit IS
			WHEN 0 => physical_segment(6 downto 0) <= "1111110";
			WHEN 1 => physical_segment(6 downto 0) <= "0110000";
			WHEN 2 => physical_segment(6 downto 0) <= "1101101";
			WHEN 3 => physical_segment(6 downto 0) <= "1111001";
			WHEN 4 => physical_segment(6 downto 0) <= "0110011";
			WHEN 5 => physical_segment(6 downto 0) <= "1011011";
			WHEN 6 => physical_segment(6 downto 0) <= "1011111";
			WHEN 7 => physical_segment(6 downto 0) <= "1110000";
			WHEN 8 => physical_segment(6 downto 0) <= "1111111";
			WHEN 9 => physical_segment(6 downto 0) <= "1111011";
			WHEN 10 => physical_segment(6 downto 0) <= "1110111";
			WHEN 11 => physical_segment(6 downto 0) <= "0011111";
			WHEN 12 => physical_segment(6 downto 0) <= "1001110";
			WHEN 13 => physical_segment(6 downto 0) <= "0111101";
			WHEN 14 => physical_segment(6 downto 0) <= "1001111";
			WHEN 15 => physical_segment(6 downto 0) <= "1000111";
			WHEN OTHERS => NULL;
		END CASE;
		
		
	END PROCESS;


end Behavioral;

