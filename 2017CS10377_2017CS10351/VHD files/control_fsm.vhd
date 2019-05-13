----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 05:46:24 PM
-- Design Name: 
-- Module Name: control_fsm - control_fsm
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

package states_pkg is
    type control_states is (fetch,decode,skip,shift,arith,addr,a,brn,halt,res2RF,mem_wr,mem_rd,mem2RF,exp1,exp2,exp3,exp4,exp2RF,RF2exp,load_r14_exp,read_RF,Res2RFhi);
end states_pkg;
package body states_pkg is
end states_pkg;
use work.states_pkg.all;
library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_fsm is
Port (
clk: in std_logic;
reset: in std_logic;
i_class: in std_logic_vector(1 downto 0); -- 00 01 10 11 for Halt,DP,DT,Branch
operation: in std_logic_vector(6 downto 0);  -- 0 to 15  for unknown,Lab4
green_signal: in std_logic;
bl_signal:in std_logic;
control_state2:out control_states;
p:in std_logic:='1';
red_signal: out std_logic:='0';
cpsr_i: in std_logic
);
end control_fsm;

architecture control_fsm of control_fsm is
signal control_state1: control_states:=fetch;
begin
process(clk,reset)
begin
    if(reset='1') then
        control_state1<=fetch;
        red_signal<='0';
    elsif(clk='1' and clk'event and green_signal='1') then
        case control_state1 is
            when fetch=>
            if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                else control_state1<=decode;
                red_signal<='0';
                end if;
            when decode=>
                if(operation="1000000" or operation="0111111")then
                    control_state1<=exp1;
                    red_signal<='0';
                elsif(reset='1') then
                    control_state1<=exp3;
                    red_signal<='0';
                elsif(operation="0111101")then
                    control_state1<=exp2RF;
                    red_signal<='1';
                 elsif(operation="0111110")then
                   control_state1<=RF2exp;
                   red_signal<='1';
                elsif(p='0')then
                   control_state1<=skip;
                   red_signal<='1'; 
                elsif(operation="1000001")then
                    control_state1<=load_r14_exp;
                    red_signal<='1';
                elsif(operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" or operation="1001000" or operation="1001001" or operation="1001010" or operation="1001011" or operation="1001100" or operation="1001101" or operation="1001110" or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010010" or operation="1010011" or operation="1010100" or operation="1010101" or operation="1010110" or operation="1010111" ) then 
                    control_state1<=read_RF;
                    red_signal<='0';                    
                elsif(i_class="01" or i_class="10") then
                    control_state1<=shift;
                    red_signal<='0';                    
                elsif(i_class="11" and bl_signal='0') then
                    control_state1<=brn;
                    red_signal<='1';
                elsif(i_class="11" and bl_signal='1') then
                    control_state1<=a;
                    red_signal<='0';
                elsif(i_class="00") then
                    control_state1<=halt;
                    red_signal<='1';
                else
                    control_state1<=halt;
                    red_signal<='1';
                end if;
            when read_RF=>
            if(reset='1') then
                                            control_state1<=exp3;
                                            red_signal<='0';
               else 
               control_state1<=shift;
                red_signal<='0';  
                end if;                    
            when load_r14_exp=>
                 if(cpsr_i='0') then
                                       control_state1<=exp1;
                                       red_signal<='0';
                                   elsif(reset='1') then
                                                       control_state1<=exp3;
                                                       red_signal<='0';
                                           else control_state1<=fetch;
                                           red_signal<='0';
                                           end if;
            when RF2exp=>
                if(cpsr_i='0') then
                            control_state1<=exp1;
                            red_signal<='0';
                        elsif(reset='1') then
                                            control_state1<=exp3;
                                            red_signal<='0';
                                else control_state1<=fetch;
                                red_signal<='0';
                                end if;
            when exp2RF=>
                                                if(cpsr_i='0') then
                                                            control_state1<=exp1;
                                                            red_signal<='0';
                                                        elsif(reset='1') then
                                                                            control_state1<=exp3;
                                                                            red_signal<='0';
                                                                else control_state1<=fetch;
                                                                red_signal<='0';
                                                                end if;
            when a=>
            if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                   else control_state1<=brn;
                    red_signal<='1';
                    end if;
            when shift=>
            if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                 elsif(i_class="01" and (not(operation="0101000" or operation="0001001" or operation="0101010" or operation="0101011" or operation="0101100" or operation="0101101" or operation="0101110" or operation="0101111" ))) then
                    control_state1<=arith;
                    red_signal<='0';
                 elsif(i_class="10" or (operation="0101000" or operation="0101001" or operation="0101010" or operation="0101011" or operation="0101100" or operation="0101101" or operation="0101110" or operation="0101111" )) then
                    control_state1<=addr;
                    red_signal<='0';
                    end if;
            when arith=>
            if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                
                    elsif(operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111")then
                                          control_state1<=res2RFhi;
                   red_signal<='0';
                   else
                     control_state1<=res2RF;
                    red_signal<='1';
                    end if;
            when res2RFhi=>
             if(reset='1') then
                                           control_state1<=exp3;
                                           red_signal<='0';
                              else control_state1<=Res2RF;
                               red_signal<='1';
                               end if;
            when res2RF=>
            if(cpsr_i='0') then
                control_state1<=exp1;
                red_signal<='0';
            elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                    else control_state1<=fetch;
                    red_signal<='0';
                    end if;
            when addr=>
                    if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                    else control_state1<=mem_rd;
                    red_signal<='0';
                    end if;
            when mem_wr=>
                    if(cpsr_i='0') then
                                                          control_state1<=exp1;
                                                          red_signal<='0';   
                                                          elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                                
                    else control_state1<=fetch;
                    red_signal<='0';
                    end if;
            when mem_rd=>
            if(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                    elsif(operation="0100001" or operation="0100011" or operation="0101000" or operation="0101010" or operation="0101100" or operation="0101110" or operation="0111001" or operation="0111011" or operation="0110000" or operation="0110010" or operation="0110101" or operation="0110111") then
                        control_state1<=mem_wr;
                        red_signal<='1';
                    elsif(operation="0100100" or operation="0100010" or operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111" or operation="0111010" or operation="0111100" or operation="0110001" or operation="0110011" or operation="0110110" or operation="0111000") then
                        control_state1<=mem2RF;
                        red_signal<='1';
                    end if;
            when mem2RF=>
                   if(cpsr_i='0') then
                                                                     control_state1<=exp1;
                                                                     red_signal<='0';   
                  elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';  
                                else control_state1<=fetch;
                    red_signal<='0';
                    end if;
            when brn=>
            if(cpsr_i='0') then
                                                                                 control_state1<=exp1;
                                                                                 red_signal<='0';   
                    elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                                else control_state1<=fetch;
                    red_signal<='0';
                    end if;
            when halt=>
             if(cpsr_i='0') then
                                                                     control_state1<=exp1;
                                                                     red_signal<='0';   
                    elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                                else control_state1<=fetch;
                    red_signal<='0'; 
                    end if;
            when skip=>
             if(cpsr_i='0') then
                                                                     control_state1<=exp1;
                                                                     red_signal<='0';   
                   elsif(reset='1') then
                                control_state1<=exp3;
                                red_signal<='0';
                                else  control_state1<=fetch;
                    red_signal<='0';  
                    end if;   
            when exp1=>
                    control_state1<=exp2;
                    red_signal<='0';
            when exp2=>
                    control_state1<=exp3;
                    red_signal<='0';
            when exp3=>
                    control_state1<=exp4;
                    red_signal<='1';
            when exp4=>
                    control_state1<=fetch;
                    red_signal<='0';                    
         end case;                    
    end if;
end process;
control_state2<=control_state1;

end control_fsm;