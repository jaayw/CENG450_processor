
--
-- Created on Wed 29 Mar 2017 16:02:16 PDT
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


entity ROM_VHDL_F2 is
    port(
         clk      : in  std_logic;
         addr     : in  std_logic_vector (6 downto 0);
         data     : out std_logic_vector (15 downto 0)
         );
end ROM_VHDL_F2;

architecture BHV of ROM_VHDL_F2 is

    type ROM_TYPE is array (0 to 127 ) of std_logic_vector (15 downto 0);

    constant rom_content : ROM_TYPE := (
--	000 => "0000000000000000", -- NOP # CENG450
--	001 => "0000000000000000", -- NOP # The factorial of IN input number
--	002 => "0000000000000000", -- NOP # OUT(r1)=IN*(IN-1)*(IN-2)*…*2
--	003 => "0000000000000000", -- NOP # This loop should run (N-1) times
--	004 => "0000000000000000", -- NOP # The start of this program must be at address 0, make sure of the correct branching
--	005 => "0010010000000001", -- LOADIMM.lower #1 
--	006 => "0010011101111000", -- MOV r5, r7	-- r5 is the decrement value
--	007 => "0010011001101000", -- MOV r1, r5 	-- r1 is the Factorial variable, so it is initialized to 1
--	008 => "0010011110101000", -- MOV r6, r5 	-- r6 is initialized to 1, then it’s shifted to get 2
--	009 => "0000101110000001", -- SHL r6#1 	-- the lowest value to be multiplied by (r6=2)
--	010 => "0100001000000000", -- IN r0
--	011 => "0000000000000000", -- NOP
--	012 => "0000000000000000", -- NOP
--	013 => "0000011001001000", -- Mul r1,r1,r0 -- the actual multiplication to find the factorial (IN!)
--	014 => "0000010000000101", -- Sub r0,r0,r5 -- to move to the lower number (r0-1)
--	015 => "0000010100000110", -- Sub r4,r0,r6 -- to check if r0 reaches 2
--	016 => "0000000000000000", -- NOP
--	017 => "0000000000000000", -- NOP
--	018 => "0000111100000000", -- TEST r4 		-- IF negative 
--	019 => "1000001000000100", -- BRR.N +4		-- goto OUT
--	020 => "1000011110001011", -- BR r6,11		-- ElSE: r6=2, 11*2=22, 22+2=24 Byte = 12 Word : goto 12
--	021 => "0000000000000000", -- NOP
--	022 => "0000000000000000", -- NOP
--	023 => "0100000001000000", -- OUT r1 		-- Printout the Factorial
--	024 => "0000000000000000", -- NOP
--	025 => "1000000111101011", -- BRR -21		-- goto to the beginning 
--	026 => "0000000000000000", -- NOP
--	027 => "0000000000000000", -- NOP
--	others => x"0000" ); -- NOP
	
	
	000 => "0000000000000000", -- NOP # CENG450
	002 => "0000000000000000", -- NOP # The factorial of IN input number
	004 => "0000000000000000", -- NOP # OUT(r1)=IN*(IN-1)*(IN-2)*…*2
	006 => "0000000000000000", -- NOP # This loop should run (N-1) times
	008 => "0000000000000000", -- NOP # The start of this program must be at address 0, make sure of the correct branching
	010 => "0010010000000001", -- LOADIMM.lower #1 
	012 => "0010011101111000", -- MOV r5, r7	-- r5 is the decrement value
	014 => "0010011001101000", -- MOV r1, r5 	-- r1 is the Factorial variable, so it is initialized to 1
	016 => "0010011110101000", -- MOV r6, r5 	-- r6 is initialized to 1, then it’s shifted to get 2
	018 => "0000101110000001", -- SHL r6#1 	-- the lowest value to be multiplied by (r6=2)
	020 => "0100001000000000", -- IN r0
	022 => "0000000000000000", -- NOP
	024 => "0000000000000000", -- NOP
	026 => "0000011001001000", -- Mul r1,r1,r0 -- the actual multiplication to find the factorial (IN!)
	028 => "0000010000000101", -- Sub r0,r0,r5 -- to move to the lower number (r0-1)
	030 => "0000010100000110", -- Sub r4,r0,r6 -- to check if r0 reaches 2
	032 => "0000000000000000", -- NOP
	034 => "0000000000000000", -- NOP
	036 => "0000111100000000", -- TEST r4 		-- IF negative 
	038 => "1000001000000100", -- BRR.N +4		-- goto OUT
	040 => "1000011110001011", -- BR r6,11		-- ElSE: r6=2, 11*2=22, 22+2=24 Byte = 12 Word : goto 12
	042 => "0000000000000000", -- NOP
	044 => "0000000000000000", -- NOP
	046 => "0100000001000000", -- OUT r1 		-- Printout the Factorial
	048 => "0000000000000000", -- NOP
	050 => X"0000",--"1000000111101011", -- BRR -21		-- goto to the beginning 
	052 => "0000000000000000", -- NOP
	054 => "0000000000000000", -- NOP
	others => x"0000" ); -- NOP

begin

p1:    process (clk)
	 variable add_in : integer := 0;
    begin
        --if rising_edge(clk) then
					 add_in := conv_integer(unsigned(addr));
                data <= rom_content(add_in);
        --end if;
    end process;
end BHV;


