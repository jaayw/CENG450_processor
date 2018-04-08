
--
-- Created on Thu Mar 24 13:46:54 PDT 2016
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity ROM_VHDL_L is
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (15 downto 0)
         );
end ROM_VHDL_L;

architecture BHV of ROM_VHDL_L is

    type ROM_TYPE is array (0 to 127) of std_logic_vector (15 downto 0);

    constant rom_content : ROM_TYPE := (
	-- Format L1
	000 => "0010010000001111", -- LOADIMM.LOWER #15 -- works
	001 => "0010010100000101", -- LOADIMM.UPPER #5 -- works
	002 => X"0000", -- NOP TEST
	003 => X"0000", -- NOP TEST
	004 => X"0000", -- NOP TEST
	005 => "0010011001111000", -- MOV R1, R7 -- MOV 1295 (R7) -> R1 stall issues...
	006 => "0010010000000000", -- LOADIMM.LOWER #0 
	007 => "0010010100000110", -- LOADIMM.UPPER #6
	008 => X"0000", -- NOP TEST
	009 => X"0000", -- NOP TEST
	010 => X"0000", -- NOP TEST
	011 => "0010011010111000", -- MOV R2, R7 -- MOV
	012 => X"0000", -- NOP TEST
	013 => X"0000", -- NOP TEST
	014 => X"0000", -- NOP TEST
	015 => "0010001010001000", -- STORE R2, R1
	016 => "0010000011001000", -- LOAD R3, R1
	others => x"0000" ); -- NOP
	
	-- Format L (Final Test 1)
--	000 => "0100001001000000", -- IN R1         
--	001 => "0010010000000101", -- LOADIMM.LOWER #5
--	002 => "0010010100000000", -- LOADIMM.UPPER #0
--	003 => "0010011010111000", -- MOV R2, R7
--	004 => "0010010000000010", -- LOADIMM.LOWER #2
--	005 => "0010010100000000", -- LOADIMM.UPPER #0
--	006 => "0010011011111000", -- MOV R3, R7
--	007 => "0010010000000001", -- LOADIMM.LOWER #1
--	008 => "0010010100000000", -- LOADIMM.UPPER #0
--	009 => "0010011100111000", -- MOV R4, R7
--	010 => "0000011001001011", -- MUL R1, R1, R3
--	011 => "0000001001001100", -- ADD R1, R1, R4
--	012 => "0000010010010100", -- SUB R2, R2, R4
--	013 => "0000111010000000", -- TEST R2
--	014 => "1000010000000001", -- BRR.Z 1
--	015 => "1000000111111010", -- BRR -6
--	016 => "0100000001000000", -- OUT R1
--	017 => "1000000111111111", -- BRR -1
--	others => x"0000" ); -- NOP
	
	-- Format L (Final Test 2)
--	000 => "0100001001000000", -- IN R1         
--	001 => "0010010000000101", -- LOADIMM.LOWER #5
--	002 => "0010010100000000", -- LOADIMM.UPPER #0
--	003 => "0010011010111000", -- MOV R2, R7
--	004 => "0010010000000010", -- LOADIMM.LOWER #2
--	005 => "0010010100000000", -- LOADIMM.UPPER #0
--	006 => "0010011011111000", -- MOV R3, R7
--	007 => "0010010000000001", -- LOADIMM.LOWER #1
--	008 => "0010010100000000", -- LOADIMM.UPPER #0
--	009 => "0010011100111000", -- MOV R4, R7
--	010 => "0000100001001011", -- NAND R1, R1, R3
--	011 => "0000101001000000", -- SHL R1, R1, R4
--	012 => "0000010010010100", -- SUB R2, R2, R4
--	013 => "0000111010000000", -- TEST R2
--	014 => "1000010000000001", -- BRR.Z 1
--	015 => "1000000111111010", -- BRR -6
--	016 => "0100000001000000", -- OUT R1
--	017 => "1000000111111111", -- BRR -1
--	others => x"0000" ); -- NOP
	
begin

p1:    process (clk)
	 variable add_in : integer := 0;
    begin
        if rising_edge(clk) then
					 add_in := conv_integer(unsigned(addr));
                data <= rom_content(add_in);
        end if;
    end process;
end BHV;


