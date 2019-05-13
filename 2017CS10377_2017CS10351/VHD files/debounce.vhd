--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY debounce IS
  PORT(
    clock    : IN  STD_LOGIC;  --input clock
    button1  : IN  STD_LOGIC;  --input signal to be debounced
    button2  : IN  STD_LOGIC;
    button3  : IN  STD_LOGIC;
    button4  : IN  STD_LOGIC;
    button5  : IN  STD_LOGIC;
    result1  : OUT STD_LOGIC;
    result2  : OUT STD_LOGIC;
    result3  : OUT STD_LOGIC;
    result4  : OUT STD_LOGIC;
    result5  : OUT STD_LOGIC ); --debounced signal
END debounce;

ARCHITECTURE logic OF debounce IS
 
   --counter size (20 bits gives 10.5ms with 100MHz clock)
  SIGNAL flipflops1   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
  SIGNAL counter_set1 : STD_LOGIC;                    --sync reset to zero
  SIGNAL counter_out1 : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output
  
   SIGNAL flipflops2   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
   SIGNAL counter_set2 : STD_LOGIC;                    --sync reset to zero
   SIGNAL counter_out2 : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output
   
    SIGNAL flipflops3   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
    SIGNAL counter_set3 : STD_LOGIC;                    --sync reset to zero
    SIGNAL counter_out3 : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output

     SIGNAL flipflops4   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
    SIGNAL counter_set4 : STD_LOGIC;                    --sync reset to zero
    SIGNAL counter_out4 : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output
    
     SIGNAL flipflops5   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
       SIGNAL counter_set5 : STD_LOGIC;                    --sync reset to zero
       SIGNAL counter_out5 : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output
BEGIN

  counter_set1 <= flipflops1(0) xor flipflops1(1);   --determine when to start/reset counter
  counter_set2 <= flipflops2(0) xor flipflops2(1);   --determine when to start/reset counter
  counter_set3 <= flipflops3(0) xor flipflops3(1);   --determine when to start/reset counter
  counter_set4 <= flipflops4(0) xor flipflops4(1);
  counter_set5 <= flipflops5(0) xor flipflops5(1);
  
  PROCESS(clock)
  BEGIN
    IF(clock'EVENT and clock = '1') THEN
      flipflops1(0) <= button1;
      flipflops1(1) <= flipflops1(0);
      If(counter_set1 = '1') THEN                  --reset counter because input is changing
        counter_out1 <= (OTHERS => '0');
      ELSIF(counter_out1(20) = '0') THEN --stable input time is not yet met
        counter_out1 <= counter_out1 + 1;
      ELSE                                        --stable input time is met
        result1 <= flipflops1(1);
      END IF;    
      
        flipflops2(0) <= button2;
        flipflops2(1) <= flipflops2(0);
        If(counter_set2 = '1') THEN                  --reset counter because input is changing
          counter_out2 <= (OTHERS => '0');
        ELSIF(counter_out2(20) = '0') THEN --stable input time is not yet met
          counter_out2 <= counter_out2 + 1;
        ELSE                                        --stable input time is met
          result2 <= flipflops2(1);
        END IF;    
            
      flipflops3(0) <= button3;
      flipflops3(1) <= flipflops3(0);
      If(counter_set3 = '1') THEN                  --reset counter because input is changing
        counter_out3 <= (OTHERS => '0');
      ELSIF(counter_out3(20) = '0') THEN --stable input time is not yet met
        counter_out3 <= counter_out3 + 1;
      ELSE                                        --stable input time is met
        result3 <= flipflops3(1);
      END IF;    
      
      flipflops4(0) <= button4;
              flipflops4(1) <= flipflops4(0);
              If(counter_set4 = '1') THEN                  --reset counter because input is changing
                counter_out4 <= (OTHERS => '0');
              ELSIF(counter_out4(20) = '0') THEN --stable input time is not yet met
                counter_out4 <= counter_out4 + 1;
              ELSE                                        --stable input time is met
                result4 <= flipflops4(1);
              END IF;  
              
       flipflops5(0) <= button5;
                    flipflops5(1) <= flipflops5(0);
                    If(counter_set5 = '1') THEN                  --reset counter because input is changing
                      counter_out5 <= (OTHERS => '0');
                    ELSIF(counter_out5(20) = '0') THEN --stable input time is not yet met
                      counter_out5 <= counter_out5 + 1;
                    ELSE                                        --stable input time is met
                      result5 <= flipflops5(1);
                    END IF;    
    END IF;
  END PROCESS;
END logic;