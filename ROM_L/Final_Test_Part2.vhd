
--
-- Created on Tue Mar 29 10:11:26 PDT 2016
-- 

-- IMPORTANT! : For instruction 14, it is assumed that PC is incremented automatically by 1 after each fetch by one. If you assumed otherwise, change the jump offset accordingly.

-- A = INPUT
-- DO five iterations {
--	A= (A NAND 2)  SHL 1
--	}
-- OUTPUT A
-- R1 = A
-- R2 = loopCounter
-- R3 = 2
-- R4 = 1

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity ROM_VHDL is
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (15 downto 0)
         );
end ROM_VHDL;

architecture BHV of ROM_VHDL is

    type ROM_TYPE is array (0 to 127 ) of std_logic_vector (15 downto 0);

    constant rom_content : ROM_TYPE := (
	000 => "0100001001000000", -- IN R1         
	001 => "0010010000000101", -- LOADIMM.LOWER #5
	002 => "0010010100000000", -- LOADIMM.UPPER #0
	003 => "0010011010111000", -- MOV R2, R7
	004 => "0010010000000010", -- LOADIMM.LOWER #2
	005 => "0010010100000000", -- LOADIMM.UPPER #0
	006 => "0010011011111000", -- MOV R3, R7
	007 => "0010010000000001", -- LOADIMM.LOWER #1
	008 => "0010010100000000", -- LOADIMM.UPPER #0
	009 => "0010011100111000", -- MOV R4, R7
	010 => "0000100001001011", -- NAND R1, R1, R3
	011 => "0000101001000000", -- SHL R1, R1, R4
	012 => "0000010010010100", -- SUB R2, R2, R4
	013 => "0000111010000000", -- TEST R2
	014 => "1000010000000001", -- BRR.Z 1
	015 => "1000000111111010", -- BRR -6
	016 => "0100000001000000", -- OUT R1
	017 => "1000000111111111", -- BRR -1
	others => x"0000" ); -- NOP
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


