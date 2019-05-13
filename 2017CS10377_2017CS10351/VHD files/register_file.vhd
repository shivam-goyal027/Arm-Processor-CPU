----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 01:40:07 PM
-- Design Name: 
-- Module Name: register_file - register_file
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

entity register_file is
Port (
clk:in std_logic;
reset:in std_logic;
readport1_ad:in std_logic_vector (3 downto 0);
readport2_ad:in std_logic_vector (3 downto 0);
readport1_data:out std_logic_vector (31 downto 0);
readport2_data:out std_logic_vector (31 downto 0);
writeport_ad:in std_logic_vector (3 downto 0);
writeport_data:in std_logic_vector (31 downto 0);
writeport_enable: in std_logic_vector(1 downto 0);
writeport_value: out std_logic_vector (31 downto 0); --val of rd
pcport_outdata:out std_logic_vector (31 downto 0);
pcport_indata:in std_logic_vector (31 downto 0);
pcport_enable: in std_logic_vector(1 downto 0);
slide_sw2: in std_logic_vector(11 downto 0);
signal_to_light:out std_logic_vector(15 downto 0)
 );
end register_file;

architecture register_file of register_file is
type rf is array(0 to 15) of std_logic_vector(31 downto 0);
signal reg : rf;
signal r14_exp: std_logic_vector (31 downto 0);
begin
readport1_data<=reg(to_integer(unsigned(readport1_ad)));
readport2_data<=reg(to_integer(unsigned(readport2_ad)));
writeport_value<=reg(to_integer(unsigned(writeport_ad)));
pcport_outdata<=reg(15);
signal_to_light<=
       reg(0)(15 downto 0) when slide_sw2="000000000100" else
       reg(1)(15 downto 0) when slide_sw2="000000001100" else
       reg(2)(15 downto 0) when slide_sw2="000000010100" else
       reg(3)(15 downto 0) when slide_sw2="000000011100" else
       reg(4)(15 downto 0) when slide_sw2="000000100100" else
       reg(5)(15 downto 0) when slide_sw2="000000101100" else
       reg(6)(15 downto 0) when slide_sw2="000000110100" else
       reg(7)(15 downto 0) when slide_sw2="000000111100" else
       reg(8)(15 downto 0) when slide_sw2="000001000100" else
       reg(9)(15 downto 0) when slide_sw2="000001001100" else
       reg(10)(15 downto 0) when slide_sw2="000001010100" else
       reg(11)(15 downto 0) when slide_sw2="000001011100" else
       reg(12)(15 downto 0) when slide_sw2="000001100100" else
       reg(13)(15 downto 0) when slide_sw2="000001101100" else
       reg(14)(15 downto 0) when slide_sw2="000001110100" else
       reg(15)(15 downto 0) when slide_sw2="000001111100" else
       reg(0)(31 downto 16) when slide_sw2="000000000101" else
      reg(1)(31 downto 16) when slide_sw2="000000001101" else
      reg(2)(31 downto 16) when slide_sw2="000000010101" else
      reg(3)(31 downto 16) when slide_sw2="000000011101" else
      reg(4)(31 downto 16) when slide_sw2="000000100101" else
      reg(5)(31 downto 16) when slide_sw2="000000101101" else
      reg(6)(31 downto 16) when slide_sw2="000000110101" else
      reg(7)(31 downto 16) when slide_sw2="000000111101" else
      reg(8)(31 downto 16) when slide_sw2="000001000101" else
      reg(9)(31 downto 16) when slide_sw2="000001001101" else
      reg(10)(31 downto 16) when slide_sw2="000001010101" else
      reg(11)(31 downto 16) when slide_sw2="000001011101" else
      reg(12)(31 downto 16) when slide_sw2="000001100101" else
      reg(13)(31 downto 16) when slide_sw2="000001101101" else
      reg(14)(31 downto 16) when slide_sw2="000001110101" else
      reg(15)(31 downto 16) when slide_sw2="000001111101" ;
process(clk,reset)
    begin
        if(reset='1') then
            reg<=(others=>(others=>'0'));
            r14_exp<=(others=>'0');
            --reg(15)<=pcport_indata;
        elsif (clk='1' and clk'event) then
            if(writeport_enable="01") then
                reg(to_integer(unsigned(writeport_ad)))<=writeport_data;
            elsif(writeport_enable="10") then
                reg(14)<=reg(15);
            elsif(writeport_enable="11")then
                r14_exp<=reg(15);
            end if;
            if(pcport_enable="01") then
                reg(15)<=pcport_indata;
            elsif(pcport_enable="10")then
                reg(15)<=r14_exp;
            end if;
        end if;
end process;
end register_file;