----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 03:29:45 PM
-- Design Name: 
-- Module Name: ALU - ALU
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

entity ALU is
Port (
clk: in std_logic;
reset: in std_logic;
op1: in std_logic_vector(31 downto 0); --rs for lab10
op2: in std_logic_vector(31 downto 0); --rm for lab10
res: out std_logic_vector(31 downto 0); --rdlo wd1
res1: out std_logic_vector(31 downto 0); --rdhi result1
mla: in std_logic_vector(31 downto 0); --rn of mla
rdhi:  in std_logic_vector(31 downto 0); --rn
rdlo: in std_logic_vector(31 downto 0); --rd
control_operation: in std_logic_vector(6 downto 0); -- 0 for add, 1 for sub
C_in_flag:in std_logic;
Z_flag: out std_logic;
C_flag: out std_logic;
V_flag: out std_logic;
N_flag: out std_logic;
we_zflag:in std_logic; 
we_cflag:in std_logic;
we_nflag:in std_logic;
we_vflag:in std_logic
 );
end ALU;

architecture ALU of ALU is
signal zero_signal: std_logic:='0';
signal overflow_signal: std_logic:='0';
signal carry_signal: std_logic:='0';
signal negative_signal: std_logic:='0';
signal c31_signal: std_logic:='0';
signal res2: std_logic_vector(31 downto 0);
signal res3: std_logic_vector(31 downto 0);
signal c32_signal: std_logic;
signal op3: std_logic_vector(31 downto 0);
signal c_signal:std_logic;
signal op4: std_logic_vector(31 downto 0);
signal op5: std_logic_vector(31 downto 0);
signal temp: std_logic_vector(65 downto 0);
signal temp_res1: std_logic_vector(65 downto 0);
signal temp_res2: std_logic_vector(65 downto 0);
signal temp_res3: std_logic_vector(65 downto 0);
signal concat: std_logic_vector(63 downto 0);
signal uns: std_logic_vector(31 downto 0);
signal unop1: unsigned(31 downto 0);
signal unop2: unsigned(31 downto 0);

begin

          op3(0)<='1' when op2(0)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(1)<='1' when op2(1)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(2)<='1' when op2(2)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(3)<='1' when op2(3)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(4)<='1' when op2(4)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(5)<='1' when op2(5)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(6)<='1' when op2(6)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(7)<='1' when op2(7)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(8)<='1' when op2(8)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(9)<='1' when op2(9)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(10)<='1' when op2(10)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(11)<='1' when op2(11)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(12)<='1' when op2(12)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(13)<='1' when op2(13)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(14)<='1' when op2(14)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(15)<='1' when op2(15)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(16)<='1' when op2(16)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(17)<='1' when op2(17)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(18)<='1' when op2(18)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(19)<='1' when op2(19)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(20)<='1' when op2(20)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(21)<='1' when op2(21)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(22)<='1' when op2(22)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(23)<='1' when op2(23)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(24)<='1' when op2(24)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(25)<='1' when op2(25)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(26)<='1' when op2(26)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(27)<='1' when op2(27)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(28)<='1' when op2(28)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(29)<='1' when op2(29)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(30)<='1' when op2(30)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op3(31)<='1' when op2(31)='0' and (control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="0001011" or control_operation="0010111") else '0';
          op4<=(NOT(op2)+"00000000000000000000000000000001");
          op5<=(NOT(op1)+"00000000000000000000000000000001");
          
          uns<=(others=>'0');
          unop1<=unsigned(op1);
          unop2<=unsigned(op2);
          temp_res1<=(op1(31)&op1)*(op2(31)&op2) when control_operation="1000010" else
              (op1(31)&op1)*(op2(31)&op2) + std_logic_vector(resize(signed(mla),66)) when control_operation="1000011";
              
          temp<= std_logic_vector(resize(unsigned('0'&(unop1))*unsigned('0'&(unop2)),66)) when control_operation="1000100" or control_operation="1000101" else  --umull
                 std_logic_vector(resize(signed(op1(31)&signed(op1))*signed(op2(31)&signed(op2)),66)) when control_operation="1000110" or control_operation="1000111" else  --smull
                 (others=>'0');
                 
          concat<=rdhi&rdlo;
          
          temp_res2<=temp + (concat(63)&concat(63)&concat) when control_operation="1000101" or control_operation="1000111" else 
                     (others=>'0');          
          
          
        res2<=
        (op1 + op2) when control_operation="0101000" or control_operation="0101001" or control_operation="0101100" or control_operation="0101101"  or control_operation="0110000" or control_operation="0110001" or control_operation="0000001" or control_operation="0000101" or control_operation="1010100"  or control_operation="0001100" or control_operation="0011000" or control_operation="0100001" or control_operation="01000010" or control_operation="0111001" or control_operation="0111010" or control_operation="0100001" or control_operation="0100010" else
        (op1 AND op2) when control_operation="0001101" or control_operation="0011001" or control_operation="1001100" or control_operation="0010011" or control_operation="0011111" or control_operation="1010010" else
        (op1 XOR op2) when control_operation="0001110" or control_operation="0011010" or control_operation="1001101" or control_operation="0010100" or control_operation="0100000" or control_operation="1010011" else
        (op1-op2) when control_operation="0101010" or control_operation="0101011" or control_operation="0101110" or control_operation="0101111"  or control_operation="0110010" or control_operation="0110011" or control_operation="0000010" or control_operation="0000110" or control_operation="1010101" or control_operation="0000100" or control_operation="0001000" or control_operation="0100011" or control_operation="0100100" or  control_operation="0110111" or control_operation="0111000" or control_operation="0111011" or control_operation="0111100" else
        (op2-op1) when control_operation="0010001" or control_operation="0011101" or control_operation="1010000" else
        (op1+op2+C_in_flag) when control_operation="0001001" or control_operation="0010101" or control_operation="1001000" else--control_operation="0100101" for b
        (op1-op2-C_in_flag) when control_operation="0010110" or control_operation="1001001" or control_operation="0001010" else --subc
        (op2-op1-C_in_flag) when control_operation="0010010" or control_operation="0011110" or control_operation="1010001" else --rsc
        (op1 OR op2) when control_operation="0001111" or control_operation="0011011" or control_operation="1001110" or control_operation="1001110" else --orr
        (op1 AND op3) when control_operation="0010000" or control_operation="0011100" or control_operation="1001111" or control_operation="1001111" else --bic
        op2 when control_operation="0000011" or control_operation="0000111" or control_operation="1010110" else
        op3 when control_operation="0001011" or control_operation="0010111" or control_operation="1001010" else 
        temp_res2(31 downto 0) when control_operation="1000101" or control_operation="1000111" else
        temp(31 downto 0) when control_operation="1000100" or control_operation="1000110"  else
        (others=>'0') ;
        
        res3<= 
               temp(63 downto 32) when control_operation="1000100" or control_operation="1000110" else --umull smull
               temp_res1(31 downto 0) when control_operation="1000010" or  control_operation="1000011" else
               temp_res2(63 downto 32) when control_operation="1000101" or control_operation="1000111" else --umlal and smlal 
               (others=>'0');
        
        res<=res3 when control_operation="1000010" or  control_operation="1000011" else res2;
        res1<=res3;
        
        
        c31_signal<=op1(31) XOR op2(31) XOR res2(31) when control_operation="0101000" or control_operation="0101001" or control_operation="0101100" or control_operation="0101101"  or control_operation="0110000" or control_operation="0110001" or control_operation="0000001" or control_operation="0000101" or control_operation="1010100"  or control_operation="0001100" or control_operation="0011000" or control_operation="1001011" or control_operation="0100001" or control_operation="01000010" else
                    op1(31) XOR op4(31) XOR res2(31) when control_operation="0101010" or control_operation="0101011" or control_operation="0101110" or control_operation="0101111"  or control_operation="0110010" or control_operation="0110011" or control_operation="0000010" or control_operation="0000110" or control_operation="1010101" or control_operation="0000100" or control_operation="0001000" or control_operation="1010111" or control_operation="0100011" or control_operation="0100100" else
                    op2(31) XOR op5(31) XOR res2(31) when control_operation="0010001" or control_operation="0011101" or control_operation="1010000" else
                    '0';
                    
        c32_signal<=(op1(31) AND op2(31)) OR (op1(31) AND c31_signal) OR (op2(31) AND c31_signal) when control_operation="0101000" or control_operation="0101001" or control_operation="0101100" or control_operation="0101101"  or control_operation="0110000" or control_operation="0110001" or control_operation="0000001" or control_operation="0000101" or control_operation="1010100"  or control_operation="0001100" or control_operation="0011000" or control_operation="1001011" or control_operation="0100001" or control_operation="01000010" else
                     (op1(31) AND op4(31)) OR (op1(31) AND c31_signal) OR (op4(31) AND c31_signal) when control_operation="0101010" or control_operation="0101011" or control_operation="0101110" or control_operation="0101111"  or control_operation="0110010" or control_operation="0110011" or control_operation="0000010" or control_operation="0000110" or control_operation="1010101" or control_operation="0000100" or control_operation="0001000" or control_operation="1010111" or control_operation="0100011" or control_operation="0100100" else
                     (op5(31) AND op2(31)) OR (op5(31) AND c31_signal) OR (op2(31) AND c31_signal) when control_operation="0010001" or control_operation="0011101" or control_operation="1010000" else
                     '0';
        c_signal<='0' when (control_operation="1000010" or control_operation="1000011") else (c31_signal XOR c32_signal);
        zero_signal<='1' when (res2="00000000000000000000000000000000") or (temp_res1=("0000000000000000000000000000000000000000000000000000000000000000") and (control_operation="1000010" or control_operation="1000011")) else '0';
        
                process(clk,reset)
                    begin
                        if(reset='1') then
                            C_flag<='0';
                            V_flag<='0';
                            Z_flag<='0';
                            N_flag<='0';
                        elsif(clk='1' and clk'event) then
                            if(we_cflag='1') then
                                C_flag<= c32_signal;
                            end if;
                            if(we_vflag='1') then
                                V_flag<= c_signal;
                            end if;        
                            if(we_zflag='1') then
                                Z_flag<=zero_signal;
                            end if;
                            if(we_nflag='1') then    
                                N_flag<= res2(31);
                            end if;      
                        end if;
                end process;
        
        
end ALU;