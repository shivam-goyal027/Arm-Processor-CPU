----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2019 07:22:47 PM
-- Design Name: 
-- Module Name: instruction_decoder - instruction_decoder
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

entity instruction_decoder is
Port (
    instruction: in std_logic_vector(31 downto 0);
    i_class: out std_logic_vector(1 downto 0); -- 00 01 10 11 for Halt,DP,DT,Branch
    operation: out std_logic_vector(6 downto 0);  -- 0 to 15  for unknown,Lab4
    rn : out std_logic_vector(3 downto 0);
    rd :out  std_logic_vector(3 downto 0);
    rm : out std_logic_vector(3 downto 0);
    rot_spec : out std_logic_vector (3 downto 0) := (others=>'0');
    shift_spec : out std_logic_vector (7 downto 0) := (others=>'0');
    imm32_DP: out std_logic_vector(31 downto 0);
    imm32_DT: out std_logic_vector(31 downto 0);
    predicate_check:out std_logic_vector(3 downto 0);
    SH:out std_logic_vector(1 downto 0);
    s_bit:out std_logic;
    imm32_DTdash:out std_logic_vector (31 downto 0);
    imm32_branch: out std_logic_vector(31 downto 0)
);
end instruction_decoder;

architecture instruction_decoder of instruction_decoder is
    signal cond : std_logic_vector (3 downto 0);
    signal F : std_logic_vector (1 downto 0);
    signal i_b : std_logic ;
    signal s_b : std_logic ;
    signal opcode : std_logic_vector (3 downto 0);
    signal p_b : std_logic ;
    signal u_b : std_logic ;
    signal umul_b : std_logic ;
    signal amul_b : std_logic ;
    signal b_b : std_logic ;
    signal w_b : std_logic ;
    signal l_b : std_logic ;
    signal opc : std_logic_vector(1 downto 0);
    signal imm8 : std_logic_vector(7 downto 0);
    signal imm12 : std_logic_vector(11 downto 0);
    signal imm24 : std_logic_vector(23 downto 0);
    signal instr_class: std_logic_vector(1 downto 0):="00";
    signal operation2:std_logic_vector(5 downto 0);
    --signal SH: std_logic_vector(1 downto 0);
begin
    
    F<=instruction(27 downto 26);
    instr_class<=
    "00" when (instruction="00000000000000000000000000000000") else
    "01" when F="00" else --dp and lab9
    "10" when F = "01" else --dt
    "11" when F = "10"; --branch
    
    i_class<=instr_class;
    opcode<=instruction(24 downto 21);
    i_b<=instruction(25);
    s_b<=instruction(20);
    s_bit<=s_b;
    p_b<=instruction(24);
    u_b<=instruction(23);
    umul_b<=instruction(22);
    amul_b<=instruction(21);
    b_b<=instruction(22);
    w_b<=instruction(21);
    l_b<=instruction(20);
    opc<=instruction(25 downto 24);
    cond<=instruction(31 downto 28); 
    rn<=instruction(19 downto 16);
    rd<=instruction(15 downto 12);
    rm<=instruction(3 downto 0);
    imm8<=instruction(7 downto 0);
    imm12<=instruction(11 downto 0);
    imm24<=instruction(23 downto 0);
    predicate_check<=instruction(31 downto 28); 
    rot_spec<=instruction(11 downto 8);
    shift_spec<=instruction(11 downto 4); 
    SH<=instruction(6 downto 5);
    imm32_DP<= "000000000000000000000000" &  imm8;
    imm32_DT<="00000000000000000000" & imm12;
    imm32_DTdash<="000000000000000000000000" & instruction(11 downto 8) & instruction(3 downto 0);
    imm32_branch<=imm24(23) & imm24(23) & imm24(23) & imm24(23) & imm24(23) & imm24(23) & imm24(23) & imm24(23) & imm24;
        operation<=
        "0000000" when instr_class="00" else
        "1000100" when cond="1110" and instruction(27 downto 23)="00001" and umul_b='0' and amul_b='0' and instruction(7 downto 4)="1001" else --umull
                "1000101" when cond="1110" and instruction(27 downto 23)="00001" and umul_b='0' and amul_b='1' and instruction(7 downto 4)="1001" else --umlal
                
                "1000111" when cond="1110" and instruction(27 downto 23)="00001" and umul_b='1' and amul_b='1' and instruction(7 downto 4)="1001" else --smlal        
                
        "1000110" when cond="1110" and instruction(27 downto 23)="00001" and umul_b='1' and amul_b='0' and instruction(7 downto 4)="1001" else --smull

        --lab 9
        "0101000" when instr_class="01" and   i_b='0' and b_b='1' and u_b='1' and l_b='0' and instruction(7)='1' and instruction(4)='1' else  --STR SH imm +
        "0101001" when instr_class="01" and i_b='0' and b_b='1' and u_b='1' and l_b='1' and instruction(7)='1' and instruction(4)='1' else  --LDR SH imm +
        "0101010" when instr_class="01" and i_b='0' and b_b='1' and u_b='0' and l_b='0' and instruction(7)='1' and instruction(4)='1' else  --STR SH imm -
        "0101011" when instr_class="01" and i_b='0' and b_b='1' and u_b='0' and l_b='1' and instruction(7)='1' and instruction(4)='1' else  --LDR SH imm -
        "0101100" when instr_class="01" and i_b='0' and b_b='0' and u_b='1' and l_b='0' and instruction(7)='1' and instruction(4)='1' and instruction(11 downto 8)="0000" else  --STR SH reg+
        "0101101" when instr_class="01" and i_b='0' and b_b='0' and u_b='1' and l_b='1' and instruction(7)='1' and instruction(4)='1' and instruction(11 downto 8)="0000" else  --LDR SH reg+
        "0101110" when instr_class="01" and i_b='0' and b_b='0' and u_b='0' and l_b='0' and instruction(7)='1' and instruction(4)='1' and instruction(11 downto 8)="0000" else  --STR SH reg-
        "0101111" when instr_class="01" and i_b='0' and b_b='0' and u_b='0' and l_b='1' and instruction(7)='1' and instruction(4)='1' and instruction(11 downto 8)="0000" else  --LDR SH reg-
        
        --DT with reg offset   areg
        "0110000" when instr_class="10" and i_b='1' and b_b='0'and l_b='0' and instruction(4)='0' and u_b='1' else  --str+
        "0110001" when instr_class="10" and i_b='1' and b_b='0'and l_b='1' and instruction(4)='0' and u_b='1' else  --ldr+   
        "0110010" when instr_class="10" and i_b='1' and b_b='0'and l_b='0' and instruction(4)='0' and u_b='0' else  --str-
        "0110011" when instr_class="10" and i_b='1' and b_b='0'and l_b='1' and instruction(4)='0' and u_b='0' else  --ldr- 
        
        "0110100" when instr_class="11" and opc="11" and cond="1110" else --bl
        --reg ldrb    areg
        "0110101" when instr_class="10" and i_b='1' and b_b='1'and l_b='0' and instruction(4)='0' and u_b='1' else  --strb+
        "0110110" when instr_class="10" and i_b='1' and b_b='1'and l_b='1' and instruction(4)='0' and u_b='1' else  --ldrb+   
        "0110111" when instr_class="10" and i_b='1' and b_b='1'and l_b='0' and instruction(4)='0' and u_b='0' else  --strb-
        "0111000" when instr_class="10" and i_b='1' and b_b='1'and l_b='1' and instruction(4)='0' and u_b='0' else  --ldrb- 
        
        --imm ldrb dt
        "0111001" when instr_class="10" and i_b='0' and p_b='1' and u_b='1' and b_b='1' and w_b='0' and l_b='0' else  --str+
        "0111010" when instr_class="10" and i_b='0' and p_b='1' and u_b='1' and b_b='1' and w_b='0' and l_b='1' else  --ldr+   
        "0111011" when instr_class="10" and i_b='0' and p_b='1' and u_b='0' and b_b='1' and w_b='0' and l_b='0' else  --str-
        "0111100" when instr_class="10" and i_b='0' and p_b='1' and u_b='0' and b_b='1' and w_b='0' and l_b='1' else  --ldr- 
        
        --DT with imm offset dt
        "0100001" when instr_class="10" and i_b='0' and p_b='1' and u_b='1' and b_b='0' and w_b='0' and l_b='0' else  --str+
        "0100010" when instr_class="10" and i_b='0' and p_b='1' and u_b='1' and b_b='0' and w_b='0' and l_b='1' else  --ldr+   
        "0100011" when instr_class="10" and i_b='0' and p_b='1' and u_b='0' and b_b='0' and w_b='0' and l_b='0' else  --str-
        "0100100" when instr_class="10" and i_b='0' and p_b='1' and u_b='0' and b_b='0' and w_b='0' and l_b='1' else  --ldr- 
                
        --lab10
        "1000010" when cond="1110" and instr_class="01" and i_b='0' and opcode="0000" and instruction(7 downto 4)="1001" else--mul
        "1000011" when cond="1110" and instr_class="01" and i_b='0' and opcode="0001" and instruction(7 downto 4)="1001" else--mla
        
        
        "0000001" when instr_class="01" and opcode="0100" and i_b='1' else   --add_i ` 
        "0000010" when instr_class="01" and opcode="0010" and  i_b='1' else   --sub_i ` done
        "0000011" when instr_class="01" and opcode="1101" and i_b='1' else   --mov_i ~ in lab4
        "0000100" when instr_class="01" and opcode="1010"  and s_b='1' and i_b='1' else   --cmp_i # flag set only
        "0000101" when instr_class="01" and opcode="0100"  and i_b='0' and instruction(4)='0' else  --add_r `
        "0000110" when instr_class="01" and opcode="0010"  and i_b='0'  and instruction(4)='0' else  --sub_r `
        "0000111" when (instr_class="01" and opcode="1101"  and i_b='0' and instruction(4)='0' and (not(instruction="11100001101100001111000000001110")))  else  --mov_r ~
        "0001000" when instr_class="01" and opcode="1010" and s_b='1' and i_b='0' and instruction(4)='0' else   --cmp_r #
        "1000001" when (instruction="11100001101100001111000000001110") else
        --immidiate
        "0001001" when instr_class="01" and opcode="0101" and i_b='1' else  --addc ``
        "0001010" when instr_class="01" and opcode="0110" and i_b='1' else  --subc ``
        "0001011" when instr_class="01" and opcode="1111" and i_b='1' else  --mvn ~
        "0001100" when instr_class="01" and opcode="1011" and s_b='1' and i_b='1' else  --cmn_i #
        "0001101" when instr_class="01" and opcode="0000" and i_b='1' else  --and `
        "0001110" when instr_class="01" and opcode="0001" and i_b='1' else  --eor `
        "0001111" when instr_class="01" and opcode="1100" and i_b='1' else  --orr `
        "0010000" when instr_class="01" and opcode="1110" and i_b='1' else  --bic `
        "0010001" when instr_class="01" and opcode="0011" and i_b='1' else  --rsb ``
        "0010010" when instr_class="01" and opcode="0111" and i_b='1' else  --rsc ``
        "0010011" when instr_class="01" and opcode="1000" and s_b='1' and i_b='1' else  --tst #
        "0010100" when instr_class="01" and opcode="1001" and s_b='1' and i_b='1' else  --teq #
        --registers
        "0010101" when instr_class="01" and opcode="0101"  and instruction(4)='0' else  --addc ``
        "0010110" when instr_class="01" and opcode="0110"  and instruction(4)='0' else  --subc ``
        "0010111" when instr_class="01" and opcode="1111"  and instruction(4)='0' else  --mvn_r ~
        "0011000" when instr_class="01" and opcode="1011" and s_b='1'  and instruction(4)='0' else  --cmn_r #
        "0011001" when instr_class="01" and opcode="0000"  and instruction(4)='0' else  --and `
        "0011010" when instr_class="01" and opcode="0001"  and instruction(4)='0' else  --eor `
        "0011011" when instr_class="01" and opcode="1100"  and instruction(4)='0' else  --orr `
        "0011100" when instr_class="01" and opcode="1110"  and instruction(4)='0' else  --bic `
        "0011101" when instr_class="01" and opcode="0011"  and instruction(4)='0' else  --rsb ``
        "0011110" when instr_class="01" and opcode="0111" and instruction(4)='0' else  --rsc ``
        "0011111" when instr_class="01" and opcode="1000" and s_b='1' and instruction(4)='0' else  --tst #
        "0100000" when instr_class="01" and opcode="1001" and s_b='1' and instruction(4)='0' else  --teq #
        
        --branch  
        "0100101" when instr_class="11" and opc="10" and cond="1110" else --b
        "0100110" when instr_class="11" and opc="10" and cond="0000" else --beq
        "0100111" when instr_class="11" and opc="10" and cond="0001" else --bne
        
        "0111101" when instruction(27 downto 23 )="00010" and instruction(21 downto 16)="001111" and instruction(11 downto 0)="000000000000"else --mrs check for cpsr,spsr in cpu
        "0111110" when instruction(27 downto 23 )="00010" and instruction(21 downto 4)="101001111100000000" else --msr check for cpsr,spsr in cpu
        
        "0111111" when instruction(27 downto 24)="1111" else --swi
        
       -- "1001000" when register specified shifts(includes rotate)
       "1001000" when instr_class="01" and opcode="0101"  and instruction(4)='1' else  --addc ``
       "1001001" when instr_class="01" and opcode="0110"  and instruction(4)='1' else  --subc ``
       "1001010" when instr_class="01" and opcode="1111"  and instruction(4)='1' else  --mvn_r ~
       "1001011" when instr_class="01" and opcode="1011" and s_b='1'  and instruction(4)='1' else  --cmn_r #
       "1001100" when instr_class="01" and opcode="0000"  and instruction(4)='1' else  --and `
       "1001101" when instr_class="01" and opcode="0001"  and instruction(4)='1' else  --eor `
       "1001110" when instr_class="01" and opcode="1100"  and instruction(4)='1' else  --orr `
       "1001111" when instr_class="01" and opcode="1110"  and instruction(4)='1' else  --bic `
       "1010000" when instr_class="01" and opcode="0011"  and instruction(4)='1' else  --rsb ``
       "1010001" when instr_class="01" and opcode="0111" and instruction(4)='1' else  --rsc ``
       "1010010" when instr_class="01" and opcode="1000" and s_b='1' and instruction(4)='1' else  --tst #
       "1010011" when instr_class="01" and opcode="1001" and s_b='1' and instruction(4)='1' else  --teq #
       "1010100" when instr_class="01" and opcode="0100"  and i_b='0' and instruction(4)='1' else  --add_r `
      "1010101" when instr_class="01" and opcode="0010"  and i_b='0'  and instruction(4)='1' else  --sub_r `
      "1010110" when (instr_class="01" and opcode="1101"  and i_b='0' and instruction(4)='1' and (not(instruction="11100001101100001111000000001110")))  else  --mov_r ~
      "1010111" when instr_class="01" and opcode="1010" and s_b='1' and i_b='0' and instruction(4)='1' else   --cmp_r #
               
        
        
        
        "1000000"; -- undef instr
end instruction_decoder;