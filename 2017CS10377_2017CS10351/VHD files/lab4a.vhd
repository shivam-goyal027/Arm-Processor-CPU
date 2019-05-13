----------------------------------------------------------------------------------

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.states_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity lab4a is
Port ( 
clock:in std_logic;
reset: in std_logic;
cpsr_i_bit: in std_logic;
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
end entity;

architecture Behavioral of lab4a is

component shifter is
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
end component;

component register_file
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
end component;

component adder
Port (data1:out std_logic_vector (31 downto 0);
data2:in std_logic_vector (31 downto 0);
data3:in std_logic_vector (31 downto 0);
carry:in std_logic
 );
 end component;

component control_fsm
Port (
clk: in std_logic;
reset: in std_logic;
i_class: in std_logic_vector(1 downto 0); -- 00 01 10 11 for Halt,DP,DT,Branch
operation: in std_logic_vector(6 downto 0);  -- 0 to 15  for unknown,Lab4
green_signal: in std_logic;
bl_signal:in std_logic;
control_state2:out control_states;
p:in std_logic;
red_signal: out std_logic ;
cpsr_i: in std_logic);
end component;

component instruction_decoder
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
end component;

component ALU
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
end component;

component fsm
  Port (
clock:in std_logic;
reset: in std_logic;
fsm_go:in std_logic:='0';
fsm_step:in std_logic:= '0';
fsm_instr:in std_logic:= '0';
--slide_sw:in std_logic_vector(2 downto 0):="000";
control_state_signal:in std_logic;
instr_signal:in std_logic;
green_signal:out std_logic 
   );
end component;

--    signal error: std_logic;
    signal pc: std_logic_vector(31 downto 0); --reg for pc
    signal s_bit:std_logic;
	signal Z_flag:std_logic;
	signal we_zflag:std_logic;
	signal we_cflag:std_logic;
	signal we_nflag:std_logic;
	signal we_vflag:std_logic;
	signal s_zflag:std_logic;
    signal s_cflag:std_logic;
    signal s_nflag:std_logic;
    signal s_vflag:std_logic;
    signal rn : std_logic_vector(3 downto 0);
    signal rd : std_logic_vector(3 downto 0);
    signal rm : std_logic_vector(3 downto 0);
    signal wen_rf:std_logic_vector(1 downto 0);
    signal wen_pc:std_logic_vector(1 downto 0):="00";
    signal control_state: control_states:= fetch ;
    signal i_class: std_logic_vector(1 downto 0);
    signal operation: std_logic_vector(6 downto 0);
    signal wd1:std_logic_vector(31 downto 0); --this is the output of alu
    signal op1:std_logic_vector(31 downto 0);
    signal op2:std_logic_vector(31 downto 0);
    signal rd1:std_logic_vector (31 downto 0);
    signal rd2:std_logic_vector (31 downto 0);
    signal rd3:std_logic_vector (31 downto 0);
    signal rot_spec :std_logic_vector (3 downto 0) := (others=>'0'); --rotation
    signal shift_spec : std_logic_vector (7 downto 0) := (others=>'0'); --shift
    signal shift_type: std_logic_vector(1 downto 0);
    signal SH: std_logic_vector(1 downto 0);
    signal imm32_DP: std_logic_vector(31 downto 0);
    signal imm32_DT: std_logic_vector(31 downto 0);
    signal imm32_branch:std_logic_vector(31 downto 0);
    signal green:std_logic;
    signal red:std_logic;
    signal instr_signal:std_logic;
    signal opr_alu:std_logic; -- 0 for add, 1 for sub
    signal pc_new:std_logic_vector(31 downto 0);
    signal IR:std_logic_vector(31 downto 0):=(others=>'0');
    signal A_reg:std_logic_vector(31 downto 0);
    signal B_reg:std_logic_vector(31 downto 0);
    signal result_reg:std_logic_vector(31 downto 0);
    signal result_reg2:std_logic_vector(31 downto 0);
    signal DR:std_logic_vector(31 downto 0);
    signal zero_flag:std_logic;
    signal carry_flag_alu:std_logic;
    signal carry_flag_shifter:std_logic;
    signal overflow_flag:std_logic;
    signal negative_flag:std_logic;
    signal in_adder1:std_logic_vector(31 downto 0):=(others=>'0');
    signal in_adder2:std_logic_vector(31 downto 0):=(others=>'0');
    signal carry_adder:std_logic:='0';
    signal temp:std_logic_vector(1 downto 0):="00";
    signal imm8:std_logic_vector(7 downto 0);
    signal imm12:std_logic_vector(11 downto 0);
    signal imm24:std_logic_vector(23 downto 0);
    signal val_rd: std_logic_vector(31 downto 0);
    signal C_out_flag_signal:std_logic:='0';
    signal shifted_op2_for_alu: std_logic_vector(31 downto 0);
    signal shifted_op2_from_shifter: std_logic_vector(31 downto 0);
    signal D_reg: std_logic_vector(31 downto 0);
    signal store_signal: std_logic_vector(31 downto 0);
    signal load_signal: std_logic_vector(31 downto 0);
    signal predicate: std_logic:='1';
    signal predicate_check: std_logic_vector(3 downto 0);
    signal bl_signal:std_logic:='0';
    signal shift_spec_signal:std_logic_vector(7 downto 0);
    signal rot_spec_signal:std_logic_vector(4 downto 0);
    signal imm32_DTdash:std_logic_vector(31 downto 0);
    signal cpsr:std_logic_vector(31 downto 0);
    signal spsr:std_logic_vector(31 downto 0):=(others=>'0');
    signal cpsr_signal:std_logic_vector(31 downto 0);
    signal spsr_signal:std_logic_vector(31 downto 0):=(others=>'0');
    signal msr_signal:std_logic_vector(31 downto 0);
    signal mrs_signal:std_logic_vector(31 downto 0);
    signal swi_function:std_logic_vector(2 downto 0);
    signal rdhi_signal: std_logic_vector(31 downto 0);
    signal rdlo_signal: std_logic_vector(31 downto 0);
    signal result1: std_logic_vector(31 downto 0); --second output of alu
    signal rs: std_logic_vector(3 downto 0);
    signal rn_dash: std_logic_vector(3 downto 0);
    signal E_reg: std_logic_vector(31 downto 0);
      signal F_reg: std_logic_vector(31 downto 0);
    signal rd_dash: std_logic_vector(3 downto 0);
    signal rm_dash: std_logic_vector(3 downto 0);
begin
   shift_spec_signal<=E_reg(4 downto 0)&"000" when (operation="1001000" or operation="1001001" or operation="1001010" or operation="1001011" or operation="1001100" or operation="1001101" or operation="1001110" or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010010" or operation="1010011" or operation="1010100" or operation="1010101" or operation="1010110" or operation="1010111" ) else shift_spec when (operation="0000101" or operation="0000110" or operation="0000111" or operation="0001000" or operation="0110000" or operation="0110001" or operation="0110010" or operation="0110011" or operation="0010101" or operation="0010110" or operation="0010111" or operation="0011000"  or operation="0011001" or operation="0011010" or operation="0011011" or operation="0011100" or operation="0011101" or operation="0011110" or operation="0011111" or operation="0100000"  ) else "00000000";
   rot_spec_signal<=E_reg(4 downto 0) when (operation="1001000" or operation="1001001" or operation="1001010" or operation="1001011" or operation="1001100" or operation="1001101" or operation="1001110" or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010010" or operation="1010011" or operation="1010100" or operation="1010101" or operation="1010110" or operation="1010111" ) else rot_spec & '0' when (operation="0000001" or operation="0000010" or operation="0000011" or operation="0001001" or operation="0001010" or operation="0001011" or operation="0001100" or operation="0001101" or operation="0001110" or operation="0001111" or operation="0010000" or operation="0010001" or operation="0010010" or operation="0010011" or operation="0010100") else rot_spec & IR(7) when ( operation="0110000" or operation="0110001" or operation="0110010" or operation="0110011" or operation="0000101" or operation="1010100" or operation="0000110" or operation="0000111" or operation="0001000" or operation="0010101" or operation="0010110" or operation="0010111" or operation="0011000"  or operation="0011001" or operation="0011010" or operation="0011011" or operation="0011100" or operation="0011101" or operation="0011110" or operation="0011111" or operation="0100000") else "00000";
   
   rs<=IR(11 downto 8);
   rm_dash<=rd when ((operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" )and control_state=read_RF)
            else rm;
   rn_dash<= rs when((operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" or operation="1001000" or operation="1001001" or operation="1001010" or operation="1001011" or operation="1001100" or operation="1001101" or operation="1001110" or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010010" or operation="1010011" or operation="1010100" or operation="1010101" or operation="1010110" or operation="1010111" )and (control_state=read_RF)) 
               else rd when ((operation="1000010" or operation="1000011" ) and control_state=decode  )
               else rn;
               
   rd_dash<= rn when ((operation="1000010" or operation="1000011" )and control_state=Res2RF)
            else rn when((operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" ) and control_state=Res2RFhi)
            else rd;
   instr_signal<=
                '1' when control_state=halt else '0';             
   shift_type <= "00" when (shift_spec(1)='1' and shift_spec(2)='1') or (operation="0000001" or operation="0000010" or operation="0000011" or operation="0000100" or operation="0001001" or operation="0001010" or operation="0001011" or operation="0001100" or operation="0001101" or operation="0001110" or operation="0001111" or operation="0010000" or operation="0010001" or operation="0010010" or operation="0010011" or operation="0010100")else --ror
                 "01" when (shift_spec(1)='1' and shift_spec(2)='0') else --lsr
                 "10" when (shift_spec(1)='0' and shift_spec(2)='0') else --lsl
                 "11"; --asr
   imm32_DT<="00000000000000000000" & IR(11 downto 0);
    --SH <= IR(6 downto 5); --unsigned_half_word ="01" else signed_byte="10" else signed_half_word ="11"
    in_adder1<="00000000000000000000000000000100" when (operation="1000000" and control_state=exp3) else
               "00000000000000000000000000001000" when (operation="0111111" and control_state=exp3) else
               "00000000000000000000000000011000" when (cpsr(7)='0' and control_state=exp3) else
               "00000000000000000000000000000000" when ((not(operation="0111111") and not(operation="1000001") and cpsr(7)='1') and control_state=exp3) else
                pc;
    in_adder2<=
            (imm32_branch(29 downto 0)&"00") when control_state=brn and ((operation="0100110" and zero_flag='1') or (operation="0100111" and zero_flag='0') or (operation="0100101") or (operation="0110100")) and green='1' else
            "00000000000000000000000000000100" when (control_state=fetch  and green='1') else
            "00000000000000000000000000000000";
    carry_adder<=
            '1' when control_state=brn and ((operation="0100101") or (operation="0110100") or (operation="0100110" and zero_flag='1') or (operation="0100111" and zero_flag='0') ) else
            '0';
            
       
    
    predicate<= '1' when ((reset='1')or(IR="00000000000000000000000000000000")or(predicate_check="0000" and zero_flag='1') or (predicate_check="0001" and zero_flag='0') or (predicate_check="0010" and C_out_flag_signal='1') or (predicate_check="0011" and C_out_flag_signal='0') or (predicate_check="0100" and negative_flag='1') or (predicate_check="0101" and negative_flag='0') or (predicate_check="0110" and overflow_flag='1') or (predicate_check="0111" and overflow_flag='0') or (predicate_check="1000" and C_out_flag_signal='1' and zero_flag='0') or (predicate_check="1001" and (zero_flag='1' or C_out_flag_signal='0')) or (predicate_check="1010" and negative_flag=overflow_flag) or (predicate_check="1011" and (not(negative_flag=overflow_flag))) or (predicate_check="1100" and (zero_flag='0' and negative_flag=overflow_flag)) or (predicate_check="1101" and (zero_flag='1' or (not(overflow_flag=negative_flag)))) or (predicate_check="1110") or (predicate_check="1111")) else
                '0';
    
    bl_signal<='1' when operation="0110100" else '0';             

    wen_pc<=
            "01" when ((control_state=fetch or control_state=brn or control_state=exp3) and green='1') else
            "10" when (control_state=load_r14_exp) else 
            --"11" when ((operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" )and control_state=Res2RFhi) else
            "00";
    --rm Areg
    op1<=
         E_reg when operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" else
        "00000000000000000000000000000000" when operation="0000011" or operation="0001011" or operation="0000111" or operation="1010110" or operation="0010111" or operation="1001010" else
        B_reg when (operation="0100001" or operation="0100010" or operation="0100011" or operation="0100100" or operation="0110101" or operation="0110110" or operation="0110111" or operation="0111000" or operation="0111001" or operation="0111010" or operation="0111011" or operation="0111100" or operation="0101000" or operation="0101001" or operation="0101010" or operation="0101011" or operation="0101100" or operation="0101101" or operation="0101110" or operation="0101111" or operation="0110000" or operation="0110101" or operation="0111001" or operation="0111011" or operation="0110001" or operation="0110110" or operation="0111010" or operation="0110010" or operation="0110111" or operation="0111011" or operation="0110011" or operation="0111000" or operation="0111100" or operation="0000001" or operation="0001001" or operation="0010101" or operation="1001000" or operation="0000101" or operation="1010100" or operation="0000010" or operation="0000110" or operation="1010101" or operation="0001010" or operation="0010110" or operation="1001001" or operation="0010010" or operation="0010001"  or operation="0011110" or operation="1010001" or operation="0011101" or operation="1010000"  or operation="0000100" or operation="0001000" or operation="1010111" or operation="0001100" or operation="0011000" or operation="1001011"or operation="0001101" or operation="0011001" or operation="1001100" or operation="0001111" or operation="0011011" or operation="1001110" or operation="0001110" or operation="0011010" or operation="1001101" or operation="0010000" or operation="0011100" or operation="1001111"   or operation="0010011" or operation="0011111" or operation="1010010" or operation="0010100" or operation="0100000" or operation="1010011" or operation="1001000" or operation="1001001" or operation="1001100" or operation="1001101" or operation="1001110"  or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010100" or operation="1010101"  ) or (i_class="10");
        
    op2<=
        imm32_DP when operation="0010011" or operation="0010100"  or operation="0001011" or operation="0001101" or operation="0001110" or operation="0001111" or operation="0010000" or operation="0000100" or operation="0001100" or operation="0000011" or operation="0001011" or operation="0000001" or operation="0000010" or operation="0001001" or operation="0001010" or operation="0010001" or operation="0010011"  else
        imm32_DT when operation="0100001" or operation="0100010" or operation="0100011" or operation="0100100" or operation="0111010"  or operation="0111001"  or operation="0111011" or operation="0111100"  else
        A_reg when operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111"   or operation="0101100" or operation="0101101" or operation="0101110" or operation="0101111" or operation="0110000" or operation="0110101" or operation="0110001" or operation="0110110" or operation="0110010" or operation="0110111" or operation="0110011" or operation="0111000" or operation="0011111" or operation="1010010" or (operation="0000111" or operation="1010110" ) or operation ="000111" or operation="0010111" or operation="1001010"  or operation="0010111" or operation="1001010" or operation="0100000" or operation="1010011" or operation="0011001" or operation="1001100" or operation="0011010" or operation="1001101" or operation="0011011" or operation="1001110" or operation="0011100" or operation="1001111" or operation="0001000" or operation="1010111" or operation="0011000" or operation="1001011" or operation="0000101" or operation="1010100" or operation="0000110" or operation="1010101" or operation="0010101" or operation="1001000" or operation="0010110" or operation="1001001" or operation="0011101" or operation="1010000" or operation="0011110" or operation="1010001" or operation="1001000" or operation="1001001" or operation="1001100" or operation="1001101" or operation="1001110"  or operation="1001111" or operation="1010000" or operation="1010001" or operation="1010100" or operation="1010101"   else
        imm32_DTdash when operation="0101000" or operation="0101001" or operation="0101010" or operation="0101011" ;
       
    shifted_op2_for_alu<=D_reg;         
        
    we_zflag<= '1' when ((s_bit='1') and control_state=arith and i_class="01") else '0'; --same for all instruction
    we_cflag<= '1' when ((operation="0001001" or operation="0001010" or operation="0010010" or operation="0010101" or operation="1001000" or operation="0010110" or operation="1001001" or operation="0011110" or operation="1010001" or operation="0000001" or operation="0000010" or operation="0000101" or operation="1010100" or operation="0000110" or operation="1010101" or operation="0010001" or operation="0011101" or operation="1010000" or operation="0000100" or operation="0001000" or operation="1010111" or operation="0001100" or operation="0011000" or operation="1001011") and control_state=arith and s_bit='1') else '0';
    we_vflag<= '1' when ((operation="0001001" or operation="0001010" or operation="0010010" or operation="0010101" or operation="1001000" or operation="0010110" or operation="1001001" or operation="0011110" or operation="1010001" or operation="0000001" or operation="0000010" or operation="0000101" or operation="1010100" or operation="0000110" or operation="1010101" or operation="0010001" or operation="0011101" or operation="1010000" or operation="0000100" or operation="0001000" or operation="1010111" or operation="0001100" or operation="0011000" or operation="1001011") and control_state=arith and s_bit='1') else '0';
    we_nflag<= '1' when ((s_bit='1') and control_state=arith and i_class="01") else '0';  --same for all instruction
    
    --s_zflag<=we_zflag;
    s_cflag<='1' when ((operation="0011001" or operation="1001100" or operation= "0011010" or operation="0011011" or operation="1001110" or operation= "0011100" or operation="0011111" or operation="1010010" or operation= "0100000" or operation="0010111" or operation="1001010" or operation= "0000011" or operation="0000111" or operation="1010110" or operation= "0001011" or operation="0001101" or operation= "0001110" or operation="0001111" or operation= "0010000" or operation="0010011" or operation= "0010100") and control_state=shift) else '0';
    --s_nflag<=we_nflag;
    --s_vflag<= '0'; --unconditionally zero in shifter
    
    C_out_flag_signal<=carry_flag_alu when ((operation="0001001" or operation="0001010" or operation="0010010" or operation="0010101" or operation="1001000" or operation="0010110" or operation="1001001" or operation="0011110" or operation="1010001" or operation="0000001" or operation="0000010" or operation="0000101" or operation="1010100" or operation="0000110" or operation="1010101" or operation="0010001" or operation="0011101" or operation="1010000" or operation="0000100" or operation="0001000" or operation="1010111" or operation="0001100" or operation="0011000" or operation="1001011") and control_state=arith and instruction(20)='1') else
                        carry_flag_shifter when ((operation="0011001" or operation="1001100" or operation= "011010" or operation="0011011" or operation="1001110" or operation= "011100" or operation="0011111" or operation="1010010" or operation= "100000" or operation="0010111" or operation="1001010" or operation= "000011" or operation="0000111" or operation="1010110" or operation= "001011" or operation="0001101" or operation= "001110" or operation="0001111" or operation= "010000" or operation="0010011" or operation= "010100") and control_state=shift) else '0';
    
    C_out_flag<=C_out_flag_signal;
    wen_rf<= "11" when (cpsr(7)='0' and (control_state=exp1))or ((operation="0111111" or operation="1000000") and (control_state=exp1))
     else "01" when ((operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" )and control_state=Res2RFhi) or (((operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" or operation="1000010" or operation="1000011" or operation="0000001" or operation="0000010" or operation="0000011" or operation="0000101" or operation="1010100" or operation="0000110" or operation="1010101" or operation="0000111" or operation="1010110" or operation="0001001" or operation="0001010" or operation="0001011" or operation="0001101" or operation="0001110" or operation="0001111" or operation="0010000" or operation="0010001" or operation="0010010" or operation="0010101" or operation="1001000" or operation="0010110" or operation="1001001" or operation="0010111" or operation="1001010" or operation="0011001" or operation="1001100" or operation="0011010" or operation="1001101" or operation="0011011" or operation="1001110" or operation="0011100" or operation="1001111" or operation="0011101" or operation="1010000" or operation="0011110" or operation="1010001") and control_state=res2RF) or ((operation="0100010" or operation="0100100" or operation="0111010" or operation="0111100" or operation="0110110" or operation="0111000" or operation="0110001" or operation="0110011" or operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")  and control_state=mem2RF) or (operation="0111101" and control_state=exp2RF)) 
     else "10" when ((operation="0110100" and control_state=a) )else "00";
    spsr_signal<=cpsr when (((operation="0111111" or operation="1000000") and (control_state=exp2)) or (cpsr(7)='0' and (control_state=exp2))) else A_reg when(IR(22)='1' and operation="0111110" and control_state=RF2exp) else spsr;
    rd3<= result_reg when ((control_state=res2RF)) else load_signal when(control_state=mem2RF) else
            result_reg2 when ((operation="1000010" or operation="1000011" or operation="1000100" or operation="1000101" or operation="1000110" or operation="1000111" )and control_state=Res2RFhi) else
                cpsr when (IR(22)='0' and operation="0111101") else
                spsr when (IR(22)='1' and operation="0111101")else rd3;
                
    
    write_enable<= '1' when control_state=mem_wr else '0';
   -- SH <= IR(6 downto 5); --unsigned_half_word ="01" else signed_byte="10" else signed_half_word ="11"
    store_signal<= val_rd(15 downto 0) & DR(15 downto 0) when (result_reg(1)='0' and SH="01" and (operation="0101000" or operation="0101010" or operation="0101100" or operation="0101110")) else
                   DR(31 downto 16) & val_rd(15 downto 0) when (result_reg(1)='1' and SH="01" and (operation="0101000" or operation="0101010" or operation="0101100" or operation="0101110")) else
                   val_rd(7 downto 0) & DR(23 downto 0) when (result_reg(1 downto 0)="00" and (operation="0110101" or operation="0110111" or operation="0111001" or operation="0111011")) else
                   DR(31 downto 24) & val_rd(7 downto 0) & DR(15 downto 0) when (result_reg(1 downto 0)="01" and (operation="0110101" or operation="0110111" or operation="0111001" or operation="0111011")) else
                   DR(31 downto 16) & val_rd(7 downto 0) & DR(7 downto 0) when (result_reg(1 downto 0)="10" and (operation="0110101" or operation="0110111" or operation="0111001" or operation="0111011")) else
                   DR(31 downto 8) & val_rd(7 downto 0) when (result_reg(1 downto 0)="11" and (operation="0110101" or operation="0110111" or operation="0111001" or operation="0111011")) else
                   val_rd when  (operation="0100001" or operation="0100011" or operation="0110000" or operation="0110010") else
                   "00000000000000000000000000000000"; 
                   
    load_signal<=DR(31)& DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)& DR(31 downto 24) when(result_reg(1 downto 0)="00" and SH="10" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    DR(23) & DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) &DR(23) & DR(23 downto 16) when (result_reg(1 downto 0)="01" and SH="10" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    DR(15)& DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)& DR(15 downto 8)when (result_reg(1 downto 0)="10" and SH="10" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)&DR(7)& DR(7 downto 0) when (result_reg(1 downto 0)="10" and SH="10" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    DR(31)& DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)&DR(31)& DR(31 downto 16) when(result_reg(1)='0' and SH="11" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    DR(15)& DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)&DR(15)& DR(15 downto 0) when(result_reg(1)='1' and SH="11" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    "0000000000000000"& DR(31 downto 16) when(result_reg(1)='0' and SH="01" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    "0000000000000000"& DR(15 downto 0) when(result_reg(1)='1' and SH="01" and (operation="0101001" or operation="0101011" or operation="0101101" or operation="0101111")) else
                    "000000000000000000000000" & DR(7 downto 0) when (result_reg(1 downto 0)="11" and (operation="0110110" or operation="0111000" or operation="0111010" or operation="0111100")) else
                    "000000000000000000000000" & DR(15 downto 8) when (result_reg(1 downto 0)="10" and (operation="0110110" or operation="0111000" or operation="0111010" or operation="0111100")) else
                    "000000000000000000000000" & DR(23 downto 16) when (result_reg(1 downto 0)="01" and (operation="0110110" or operation="0111000" or operation="0111010" or operation="0111100")) else
                    "000000000000000000000000" & DR(31 downto 24) when (result_reg(1 downto 0)="00" and (operation="0110110" or operation="0111000" or operation="0111010" or operation="0111100")) else
                    DR when (operation="0100010" or operation="0100100" or operation="0110001" or operation="0110011") else
                    "00000000000000000000000000000000";
    data_to<=store_signal;
    
    add_to_data<=result_reg(31 downto 2) & "00" ;
    
    
    process(clock,reset,green)
    begin
        if(reset='1') then
            --predicate<='1';
            temp<="11"; -- just a temporary variable used for checking
        elsif(clock='1' and clock'event and green='1') then
                   case control_state is
                       when fetch=>
                       IR<=instruction; 
                       cpsr<=cpsr_signal;
                       --temp<="11";   
                       when decode=>
                       A_reg<=rd1;   -- rm
                       B_reg<=rd2;   --rn
                       --temp<="11"; 
                       
                       when read_RF=>
                       E_reg<=rd2;
                       F_reg<=rd1;
                       when shift=>
                       D_reg<= shifted_op2_from_shifter;  
                       
                       when arith=>
                       result_reg<=wd1;
                       result_reg2<=result1;
                       when addr=>
                       result_reg<=wd1;
--                       when mem_wr=>
--                       data_to<= B_reg;
--                       add_to_data<=result_reg;
                       when mem_rd=>
                       DR<=data_from;
                              
                       when exp2=>
                       spsr<=spsr_signal;
                       
                       when RF2exp=>
                       cpsr<=cpsr_signal;
                       spsr<=spsr_signal;
                       
                      when exp4=>
                      cpsr<=cpsr_signal;
                       when brn=>
                       --pc<=pc_new;
                       
                       when others=>
                                            
                    end case;                    
               end if;
        
    end process;
     Add_to_prog<=pc;
     
    zero_out<=zero_flag;
     neg_out<=negative_flag;
     over_out<=overflow_flag;
cpsr_signal(31 downto 28)<=spsr(31 downto 28)when (IR="11100001101100001111000000001110" and control_state=res2RF) else A_reg(31 downto 28) when(IR(22)='0' and operation="0111110" and control_state=RF2exp) else negative_flag & zero_flag & C_out_flag_signal & overflow_flag;
cpsr_signal(7)<=spsr(7)when (IR="11100001101100001111000000001110" and control_state=res2RF) else '1' when (control_state=exp4) else A_reg(7) when(IR(22)='0' and operation="0111110" and control_state=RF2exp) else cpsr_i_bit;
cpsr_signal(27 downto 8)<=A_reg(27 downto 8) when(IR(22)='0' and operation="0111110" and control_state=RF2exp) else "00000000000000000000";
cpsr_signal(6 downto 0)<=A_reg(6 downto 0) when(IR(22)='0' and operation="0111110" and control_state=RF2exp) else "0000000";
swi_function<=IR(2 downto 0); -- activated only when operation="111111"


    

alu1:ALU port map(clock,reset,op1,shifted_op2_for_alu,wd1,result1,B_reg,B_reg,F_reg,operation,C_out_flag_signal,zero_flag,carry_flag_alu,overflow_flag,negative_flag,we_zflag,we_cflag,we_nflag,we_vflag);
i_decoder: instruction_decoder port map(IR,i_class,operation,rn ,rd ,rm ,rot_spec,shift_spec,imm32_DP,imm32_DT,predicate_check,SH,s_bit,imm32_DTdash,imm32_branch);
fsm_execution:fsm port map(clock,reset,go,step,instrr,red,instr_signal,green);
fsm_control: control_fsm port map(clock,reset,i_class,operation,green,bl_signal,control_state,predicate,red,cpsr(7));
adder1: adder port map(pc_new,in_adder1,in_adder2,carry_adder); 
reg_file:register_file port map (clock,reset,rm_dash,rn_dash,rd1,rd2,rd_dash,rd3,wen_rf,val_rd,pc,pc_new,wen_pc,slide_sw2,signal_to_light);
shifting: shifter port map(C_out_flag_signal,op2,shifted_op2_from_shifter,shift_spec_signal,rot_spec_signal,shift_type,s_cflag,carry_flag_shifter); 
                                    
                                    
end Behavioral;
    