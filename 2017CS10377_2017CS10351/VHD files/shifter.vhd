----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2019 04:20:41 PM
-- Design Name: 
-- Module Name: shifter - shifter
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.states_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shifter is
Port ( 
C_in_flag:in std_logic;
operand2:in std_logic_vector(31 downto 0);
shifted_operand2:out std_logic_vector(31 downto 0);
shift_value:in std_logic_vector(7 downto 0);
rotate_value:in std_logic_vector(4 downto 0);
s_r:in std_logic_vector(1 downto 0); -- 00 if ROR, 01 if LSR, 10 if LSL, 11 if ASR
write_c_flag:in std_logic;
C_out_shifter:out std_logic
);
end shifter;

architecture shifter of shifter is
signal shifted_op2_1:std_logic_vector(31 downto 0);
signal shifted_op2_2:std_logic_vector(31 downto 0);
signal shifted_op2_4:std_logic_vector(31 downto 0);
signal shifted_op2_8:std_logic_vector(31 downto 0);
signal shifted_op2_16:std_logic_vector(31 downto 0);
signal check: integer;

begin
--op2
--shifted_op2
--s_r 
--shift_value --8 bit vector
--rotate_value --4 bit vector

shifted_op2_1<= operand2(0) & operand2(31 downto 1) when (s_r="00" and rotate_value(0)='1') else
				"0" & operand2(31 downto 1)when (shift_value(3)='1' and s_r="01") else
				operand2(30 downto 0) & "0"  when (shift_value(3)='1' and s_r="10") else
				operand2(31) & operand2(31 downto 1)when (shift_value(3)='1' and s_r="11") else
				operand2;

shifted_op2_2<= shifted_op2_1(1) & shifted_op2_1(0) & shifted_op2_1(31 downto 2) when (rotate_value(1)='1' and s_r="00") else
				"00" & shifted_op2_1(31 downto 2) when (shift_value(4)='1' and s_r="01") else
				shifted_op2_1(29 downto 0) & "00" when (shift_value(4)='1' and s_r="10") else
				shifted_op2_1(31) & shifted_op2_1(31) & shifted_op2_1(31 downto 2)  when (shift_value(4)='1' and s_r="11") else 
				shifted_op2_1;

shifted_op2_4<= shifted_op2_2(3) & shifted_op2_2(2) &shifted_op2_2(1) &shifted_op2_2(0) & shifted_op2_2(31 downto 4) when (rotate_value(2)='1' and s_r="00") else
				"0000" & shifted_op2_2(31 downto 4) when (shift_value(5)='1' and s_r="01") else
				shifted_op2_2(27 downto 0) & "0000" when (shift_value(5)='1' and s_r="10")else
				shifted_op2_2(31) & shifted_op2_2(31) & shifted_op2_2(31) & shifted_op2_2(31) & shifted_op2_2(31 downto 4) when 
				(shift_value(5)='1' and s_r="11") else 
				shifted_op2_2;


shifted_op2_8<= shifted_op2_4(7) & shifted_op2_4(6) &shifted_op2_4(5) &shifted_op2_4(4) & shifted_op2_4(3) & shifted_op2_4(2) &shifted_op2_4(1) &shifted_op2_4(0) &  shifted_op2_4(31 downto 8) when (rotate_value(3)='1' and s_r="00") else
				"00000000" & shifted_op2_4(31 downto 8)when (shift_value(6)='1' and s_r="01" )else
				shifted_op2_4(23 downto 0) & "00000000"when (shift_value(6)='1' and s_r="10" )else
				shifted_op2_4(31) & shifted_op2_4(31) & shifted_op2_4(31) & shifted_op2_4(31) &  shifted_op2_4(31) & shifted_op2_4(31) & shifted_op2_4(31) & shifted_op2_4(31) & shifted_op2_4(31 downto 8) when (shift_value(6)='1' and s_r="11" )else 
				shifted_op2_4;


shifted_op2_16<= shifted_op2_8(15) & shifted_op2_8(14) &shifted_op2_8(13) &shifted_op2_8(12) & shifted_op2_8(11) & shifted_op2_8(10) &shifted_op2_8(9) &shifted_op2_8(8) & shifted_op2_8(7) & shifted_op2_8(6) &shifted_op2_8(5) &shifted_op2_8(4) & shifted_op2_8(3) & shifted_op2_8(2) &shifted_op2_8(1) & shifted_op2_8(0) & shifted_op2_8(31 downto 16) when (rotate_value(4)='1' and s_r="00") else
				"0000000000000000" & shifted_op2_8(31 downto 16) when (shift_value(7)='1' and s_r="01") else
				shifted_op2_8(15 downto 0) & "0000000000000000" when (shift_value(7)='1' and s_r="10") else
				shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) &  shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) &  shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31) & shifted_op2_8(31 downto 16)when (shift_value(7)='1' and s_r="11") else 
				shifted_op2_8;


shifted_operand2<=shifted_op2_16;
check<=to_integer(unsigned(shift_value(7 downto 3)));
C_out_shifter<=C_in_flag when (check=0 and write_c_flag='1') else
            operand2(32-check) when(s_r="10" and write_c_flag='1') else
            operand2(check+1) when ((s_r="01" or s_r="11") and write_c_flag='1' ) else
            C_in_flag;

end shifter;
