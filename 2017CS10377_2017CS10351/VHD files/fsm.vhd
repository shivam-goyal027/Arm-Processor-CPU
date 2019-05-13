----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2019 02:08:42 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
  Port (
  clock:in std_logic;
  reset: in std_logic;
  fsm_go:in std_logic:='0';
  fsm_step:in std_logic:= '0';
  fsm_instr:in std_logic:= '0';
--  slide_sw:in std_logic_vector(2 downto 0):="000";
  control_state_signal:in std_logic;
  instr_signal:in std_logic;
  green_signal:out std_logic 
   );
end fsm;

architecture fsm of fsm is
    
    type fsm_states is (initial,done,cont,onestep,oneinstr);
    signal fsm_state: fsm_states:=initial ;


begin
process(reset,clock)
    begin
        if(reset='1') then
        fsm_state<=initial;
        green_signal<='0';
        
        elsif(clock='1' and clock'event) then
        case fsm_state is
            when initial=>
               if (fsm_step='0' and fsm_instr='0' and instr_signal='1') then
                fsm_state<=initial;
                green_signal<='0';
               elsif fsm_step='1' then
                fsm_state<=onestep;
                green_signal<='1';
               elsif fsm_go='1' then
                fsm_state<=cont;
                green_signal<='1';
               elsif fsm_instr='1' then
                fsm_state<=oneinstr;
                green_signal<='1';
               end if;
               
            when onestep=>
                fsm_state<=done;
                green_signal<='0';
                
            when cont=>
                if instr_signal='1' then
                    fsm_state<=done;
                    green_signal<='0';
                else fsm_state<=cont;
                green_signal<='1';
                end if;
            
            when oneinstr=>
                if control_state_signal = '1' then
                    fsm_state<=done;
                    green_signal<='0';
                else fsm_state<=oneinstr;
                green_signal<='1';
                end if;
                
            when done=>
                if(fsm_step='0' and fsm_go='0' and fsm_instr='0') then
                    fsm_state<=initial;
                    green_signal<='0';
                else
                    fsm_state<=done;
                    green_signal<='0';
                end if;
                   
            when others =>
                fsm_state<=initial;
                green_signal<='0';
        end case;
        
        
    
        end if;
    end process;
                        

end fsm;