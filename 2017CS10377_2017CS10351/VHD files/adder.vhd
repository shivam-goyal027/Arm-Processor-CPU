----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2019 12:38:50 AM
-- Design Name: 
-- Module Name: adder - adder
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.states_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is
Port (data1:out std_logic_vector (31 downto 0);
data2:in std_logic_vector (31 downto 0):=(others=>'0');
data3:in std_logic_vector (31 downto 0):=(others=>'0');
carry:in std_logic:='0'
 );
end adder;

architecture adder of adder is

begin
data1<=data2+data3 when carry='0'else
data2+data3+"00000000000000000000000000000100" ;

end adder;