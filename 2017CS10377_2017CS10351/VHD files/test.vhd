----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2019 02:07:49 PM
-- Design Name: 
-- Module Name: test - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use work.states_pkg.all;

entity test is
 Port(
       clock:in std_logic;
       reset1:in std_logic;
       step1:in std_logic;
       go1:in std_logic;
       instr1:in std_logic;
       light:out std_logic_vector(15 downto 0);
       slide_sw2:in std_logic_vector(11 downto 0);
       cpsr_i_bit1:in std_logic;
       slide_sw:in std_logic_vector(2 downto 0)
   );
end test;

architecture Behavioral of test is

component lab4a
Port ( 
clock:in std_logic;
reset: in std_logic;
cpsr_i_bit:in std_logic;
go:in std_logic;
step:in std_logic;
instrr:in std_logic;
slide_sw:in std_logic_vector(2 downto 0);
instruction:in std_logic_vector(31 downto 0); 
data_from:in std_logic_vector(31 downto 0);
Add_to_prog:out std_logic_vector(31 downto 0);
data_to:out std_logic_vector(31 downto 0);
add_to_data:out std_logic_vector(31 downto 0);
write_enable: out std_logic;
C_out_flag:out std_logic;
slide_sw2: in std_logic_vector(11 downto 0);
signal_to_light:out std_logic_vector(15 downto 0);
zero_out:out std_logic;
neg_out:out std_logic;
over_out:out std_logic

);
end component;

component dist_mem_gen_0
PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
component dist_mem_gen_1
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;
--component debounce
--PORT(
--    clock    : IN  STD_LOGIC;  --input clock
--    button1  : IN  STD_LOGIC;  --input signal to be debounced
--    button2  : IN  STD_LOGIC;
--    button3  : IN  STD_LOGIC;
--    button4  : IN  STD_LOGIC;
--    button5  : IN  STD_LOGIC;
--    result1  : OUT STD_LOGIC;
--    result2  : OUT STD_LOGIC;
--    result3  : OUT STD_LOGIC;
--    result4  : OUT STD_LOGIC;
--    result5  : OUT STD_LOGIC ); --debounced signal
--END component;

--signal clock:std_logic:='0';
signal reset: std_logic:='0';
signal go: std_logic:='0';
signal step: std_logic:='0';
signal instrr:std_logic:='0';
signal cpsr_i_bit:std_logic:='0';
signal cpsr_i_bit2:std_logic:='1';
--signal reset1: std_logic:='0';
--signal go1: std_logic:='0';
--signal step1: std_logic:='0';
--signal slide_sw: std_logic_vector(2 downto 0):="000";
signal instr:std_logic_vector(31 downto 0); 
signal data_from:std_logic_vector(31 downto 0);
signal Add_to_prog:std_logic_vector(31 downto 0);
signal data_to:std_logic_vector(31 downto 0);
signal add_to_data:std_logic_vector(31 downto 0);
signal write_enable: std_logic;
--signal slide_sw2: std_logic_vector(11 downto 0);
--signal light: std_logic_vector (15 downto 0);
signal signal_to_light: std_logic_vector(15 downto 0);
signal zero_out: std_logic:='0';
signal neg_out:std_logic:='0';
signal over_out: std_logic:='0';
signal C_out_flag:std_logic:='0';
--signal cpsr_i_bit:std_logic:='0';

--constant clk_period : time := 1 ns;
begin
light<=
    Add_to_prog(15 downto 0) when slide_sw2="100000000000" else
    data_from(15 downto 0) when slide_sw2="010000000000" else
    add_to_data(15 downto 0) when slide_sw2="001000000000" else
    data_to(15 downto 0) when slide_sw2="000100000000" else
    instr(15 downto 0) when slide_sw2="000010000000" else
    "000000000000000" & zero_out when slide_sw2="000000000010" else
    signal_to_light(15 downto 0) when slide_sw2="000000000100" else
    signal_to_light(15 downto 0) when slide_sw2="000000001100" else
    signal_to_light(15 downto 0) when slide_sw2="000000010100" else
    signal_to_light(15 downto 0) when slide_sw2="000000011100" else
    signal_to_light(15 downto 0) when slide_sw2="000000100100" else
    signal_to_light(15 downto 0) when slide_sw2="000000101100" else
    signal_to_light(15 downto 0) when slide_sw2="000000110100" else
    signal_to_light(15 downto 0) when slide_sw2="000000111100" else
    signal_to_light(15 downto 0) when slide_sw2="000001000100" else
    signal_to_light(15 downto 0) when slide_sw2="000001001100" else
    signal_to_light(15 downto 0) when slide_sw2="000001010100" else
    signal_to_light(15 downto 0) when slide_sw2="000001011100" else
    signal_to_light(15 downto 0) when slide_sw2="000001100100" else
    signal_to_light(15 downto 0) when slide_sw2="000001101100" else
    signal_to_light(15 downto 0) when slide_sw2="000001110100" else
    signal_to_light(15 downto 0) when slide_sw2="000001111100" else
    signal_to_light(15 downto 0) when slide_sw2="000000000101" else
    signal_to_light(15 downto 0) when slide_sw2="000000001101" else
    signal_to_light(15 downto 0) when slide_sw2="000000010101" else
    signal_to_light(15 downto 0) when slide_sw2="000000011101" else
    signal_to_light(15 downto 0) when slide_sw2="000000100101" else
    signal_to_light(15 downto 0) when slide_sw2="000000101101" else
    signal_to_light(15 downto 0) when slide_sw2="000000110101" else
    signal_to_light(15 downto 0) when slide_sw2="000000111101" else
    signal_to_light(15 downto 0) when slide_sw2="000001000101" else
    signal_to_light(15 downto 0) when slide_sw2="000001001101" else
    signal_to_light(15 downto 0) when slide_sw2="000001010101" else
    signal_to_light(15 downto 0) when slide_sw2="000001011101" else
    signal_to_light(15 downto 0) when slide_sw2="000001100101" else
    signal_to_light(15 downto 0) when slide_sw2="000001101101" else
    signal_to_light(15 downto 0) when slide_sw2="000001110101" else
    signal_to_light(15 downto 0) when slide_sw2="000001111101" else
    Add_to_prog(31 downto 16) when slide_sw2="100000000001" else
    --data_from(31 downto 16) when slide_sw2="010000000001" else
    --add_to_data(31 downto 16) when slide_sw2="001000000001" else
    --data_to(31 downto 16) when slide_sw2="000100000001" else
    --instr(31 downto 16) when slide_sw2="000010000001" else
    "000000000000000" & zero_out when slide_sw2="010000000001" else
    "000000000000000" & C_out_flag when slide_sw2="001000000001" else
    "000000000000000" & over_out when slide_sw2="000100000001" else
    "000000000000000" & neg_out when slide_sw2="000010000001"  else
    "000000000000000" & zero_out when slide_sw2="000000000011"; 
    
cpsr_i_bit2<=not(cpsr_i_bit);
                           
ins_mem: dist_mem_gen_0 port map (Add_to_prog(9 downto 2), instr);
data_mem: dist_mem_gen_1 port map ( add_to_data(9 downto 2),data_to ,clock ,write_enable,data_from );
cpu: lab4a port map (clock,reset1,cpsr_i_bit1,go1,step1,instr1,slide_sw,instr,data_from,Add_to_prog,data_to,add_to_data,write_enable,C_out_flag,slide_sw2,signal_to_light,zero_out,neg_out,over_out);
--deb: debounce port map (clock=>clock,button1=>reset1,button2=>go1,button3=>step1,button4=>instr1,button5=>cpsr_i_bit1,result1=>reset,result2=>go,result3=>step,result4=>instrr,result5=>cpsr_i_bit);

end Behavioral;
