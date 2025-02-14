----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:07 11/05/2019 
-- Design Name: 
-- Module Name:    circuit_simulation - Behavioral 
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

entity circuit_simulation is
	PORT(physical_buttons: IN STD_LOGIC_VECTOR(4 downto 0);
			physical_switchs: IN STD_LOGIC_VECTOR(7 downto 0);
			physical_segment: OUT STD_LOGIC_VECTOR(0 to 7);
			physical_segment_activation: OUT STD_LOGIC_VECTOR(3 downto 0)
			);
end circuit_simulation;

architecture Behavioral of circuit_simulation is
component CPU is
    PORT(clk, rst: IN STD_LOGIC;
			write_read, ram_activation: OUT STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
			data_out: OUT STD_LOGIC_VECTOR(7 downto 0);
         address: OUT STD_LOGIC_VECTOR(15 downto 0)
        );

    
end component;
component RAM is
    PORT(clk, write_read, activation: IN STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
         data_exit: OUT STD_LOGIC_VECTOR(7 downto 0);
         address: IN STD_LOGIC_VECTOR(15 downto 0);
			
			interface_exit: OUT STD_LOGIC_VECTOR(31 downto 0);
			interface_entry: IN STD_LOGIC_VECTOR(15 downto 0)
        );

    
end component;

component INTERFACE is
    PORT(clk, rst: IN STD_LOGIC;
			data_entry: IN STD_LOGIC_VECTOR(31 downto 0);
			input_data: OUT STD_LOGIC_VECTOR(15 downto 0);

			physical_buttons: IN STD_LOGIC_VECTOR(4 downto 0);
			physical_switchs: IN STD_LOGIC_VECTOR(7 downto 0);
			physical_segment: OUT STD_LOGIC_VECTOR(0 to 7);
			physical_segment_activation: OUT STD_LOGIC_VECTOR(3 downto 0)
			
			
        );

    
end component;
	signal clk: STD_LOGIC :='0' ;
	signal rst, wr, ram_activation : STD_LOGIC;
	signal data_c2m, data_m2c: STD_LOGIC_VECTOR(7 downto 0);
	signal address: STD_LOGIC_VECTOR(15 downto 0);
	signal data_m2i: STD_LOGIC_VECTOR(31 downto 0);
	signal data_i2m: STD_LOGIC_VECTOR(15 downto 0);
	
begin
	rst <= '0','1' after 10 ns;
	clk <= not clk after 50 ns;
	c_cpu: CPU port map(clk, rst, wr, ram_activation, data_m2c, data_c2m, address);
	c_ram: RAM port map (clk, wr, ram_activation, data_c2m, data_m2c, address,  data_m2i, data_i2m);
	c_interface: INTERFACE port map(clk, rst, data_m2i, data_i2m, physical_buttons, physical_switchs, physical_segment, physical_segment_activation);

end Behavioral;

