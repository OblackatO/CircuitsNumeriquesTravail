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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INTERFACE is
    PORT(clk, rst: IN STD_LOGIC;
			data_entry: IN STD_LOGIC_VECTOR(31 downto 0);
			input_data: OUT STD_LOGIC_VECTOR(15 downto 0);

			physical_buttons: IN STD_LOGIC_VECTOR(4 downto 0);
			physical_switchs: IN STD_LOGIC_VECTOR(7 downto 0);
			physical_segment: OUT STD_LOGIC_VECTOR(0 to 7);
			physical_segment_activation: OUT STD_LOGIC_VECTOR(3 downto 0)
			
			
        );
end INTERFACE;

architecture Behavioral of INTERFACE is

	SIGNAL clk_counter:  STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL button_maj, maj_delay:  STD_LOGIC;
	SIGNAL clk_button:  STD_LOGIC;
	SIGNAL button_state: STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL switch_state: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL segment_digit: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL segment_activation: STD_LOGIC_VECTOR(3 downto 0);
	
begin
	
	clock_counter : PROCESS(clk, rst) BEGIN
		IF rst = '0' THEN
			clk_counter <= x"0000";
		ELSIF clk'event AND clk = '1' THEN
			clk_counter <= clk_counter + 1;
			clk_button <= clk_counter(15);
		END IF;		
	END PROCESS;
	
		buttons_manager : PROCESS(rst, clk_button) BEGIN
		IF rst = '0' THEN
			button_maj <= '0';
		ELSIF clk_button'event AND clk_button = '1' THEN
			button_state <= physical_buttons;
			switch_state <= physical_switchs;
			maj_delay <= button_state(4);
			IF maj_delay = '0' AND button_state(4) = '1' THEN
				button_maj <= not button_maj;
			END IF;
			
		END IF;		
	END PROCESS;
	
	 -- DIP switch state & buttons state
	input_data(15 downto 8) <= switch_state;
	
	buttons_select : PROCESS(button_maj, button_state) BEGIN
		IF button_maj = '0' THEN
			input_data(7 downto 4) <= button_state(3 downto 0);
			input_data(3 downto 0) <= x"0";
		ELSE
			input_data(7 downto 4) <= x"0";
			input_data(3 downto 0) <= button_state(3 downto 0);
		END IF;		
	END PROCESS;
	
	display_selector : PROCESS(clk_counter, button_maj, data_entry)
		variable data_to_display:  STD_LOGIC_VECTOR(15 downto 0);
	BEGIN
		--data selection
		-- accepts data_entry of type:
		-- MSB & LSB & current RAM value & dip switch value
		CASE button_maj IS
			WHEN '0' =>
				data_to_display := data_entry(31 downto 16);
			WHEN '1' =>
				data_to_display := data_entry(15 downto 0);
			WHEN OTHERS => null;
		END CASE;
		
		--segment(digit) selection
		CASE clk_counter(15 downto 14) IS
			WHEN "00" =>
				segment_activation <= "0111";
				segment_digit <= data_to_display(15 downto 12);
			WHEN "01" =>
				segment_activation <= "1011";
				segment_digit <= data_to_display(11 downto 8);
			WHEN "10" =>
				segment_activation <= "1101";
				segment_digit <= data_to_display(7 downto 4);
			WHEN "11" =>
				segment_activation <= "1110";
				segment_digit <= data_to_display(3 downto 0);
			WHEN OTHERS => null;
		END CASE;	
	END PROCESS;
	
	physical_segment_activation <= segment_activation;
	
	segment_encoder : PROCESS(button_maj, segment_digit, segment_activation) BEGIN
		--display maj point
		IF segment_activation = "1110" AND button_maj = '1' THEN
			physical_segment(7) <= '0';
		ELSE
			physical_segment(7) <= '1';
		END IF;
		
		CASE segment_digit IS
			WHEN x"0" => physical_segment(0 to 6) <= not "1111110";
			WHEN x"1" => physical_segment(0 to 6) <= not "0110000";
			WHEN x"2" => physical_segment(0 to 6) <= not "1101101";
			WHEN x"3" => physical_segment(0 to 6) <= not "1111001";
			WHEN x"4" => physical_segment(0 to 6) <= not "0110011";
			WHEN x"5" => physical_segment(0 to 6) <= not "1011011";
			WHEN x"6" => physical_segment(0 to 6) <= not "1011111";
			WHEN x"7" => physical_segment(0 to 6) <= not "1110000";
			WHEN x"8" => physical_segment(0 to 6) <= not "1111111";
			WHEN x"9" => physical_segment(0 to 6) <= not "1111011";
			WHEN x"a" => physical_segment(0 to 6) <= not "1110111";
			WHEN x"b" => physical_segment(0 to 6) <= not "0011111";
			WHEN x"c" => physical_segment(0 to 6) <= not "1001110";
			WHEN x"d" => physical_segment(0 to 6) <= not "0111101";
			WHEN x"e" => physical_segment(0 to 6) <= not "1001111";
			WHEN x"f" => physical_segment(0 to 6) <= not "1000111";
			WHEN OTHERS => NULL;
		END CASE;
		
		
	END PROCESS;


end Behavioral;

