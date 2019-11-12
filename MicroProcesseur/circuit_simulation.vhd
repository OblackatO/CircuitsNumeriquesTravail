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
end circuit_simulation;

architecture Behavioral of circuit_simulation is
component CPU is
    PORT(clk, rst: IN STD_LOGIC;
			write_read: OUT STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
         address: OUT STD_LOGIC_VECTOR(15 downto 0)
        );

    
end component;
component RAM is
    PORT(clk, write_read: IN STD_LOGIC;
         data_entry: IN STD_LOGIC_VECTOR(7 downto 0);
         data_exit: OUT STD_LOGIC_VECTOR(7 downto 0);
         address: IN STD_LOGIC_VECTOR(15 downto 0)
        );

    
end component;
	signal clk: STD_LOGIC :='0' ;
	signal rst, wr: STD_LOGIC;
	signal data_c2m, data_m2c: STD_LOGIC_VECTOR(7 downto 0);
	signal address: STD_LOGIC_VECTOR(15 downto 0);
	
begin
	rst <= '0','1' after 10 ns;
	clk <= not clk after 50 ns;
	c_cpu: CPU port map(clk, rst, wr, data_m2c, address);
	c_ram: RAM port map (clk, wr, data_c2m, data_m2c, address);

end Behavioral;

