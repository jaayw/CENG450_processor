library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
	Port (
		clk : IN std_logic;
		instr : IN std_logic_vector(15 downto 0);
		
		-- input
		-- Instruction from various stages
		
		-- output
		-- Output to PC
		-- Hold/En/Run state?
		displacement : OUT std_logic_vector(8 downto 0)
		--stall : OUT std_logic
	
	);
end controller;

architecture Behavioral of controller is

alias op_code is instr(15 downto 9);
alias disp_l is instr(8 downto 0);
alias disp_s is instr(5 downto 0);

begin

-- Branching (Format B)
displacement <=
	-- Format B2
	-- BR (Signed Extended -> 0)
	("000" & disp_s) when ((opcode = "1000011") and (disp_s(5) = '0')) else
	-- BR (Signed Extended -> 1)
	("111" & disp_s) when ((opcode = "1000011") and (disp_s(5) = '1')) else
	
	-- BR.N (Signed Extended -> 0)
	("000" & disp_s) when ((opcode = "1000100") and (disp_s(5) = '0')) else
	-- BR.N (Signed Extended -> 1)
	("111" & disp_s) when ((opcode = "1000100") and (disp_s(5) = '1')) else
	
	-- BR.Z (Signed Extended -> 0)
	("000" & disp_s) when ((opcode = "1000101") and (disp_s(5) = '0')) else
	-- BR.Z (Signed Extended -> 1)
	("111" & disp_s) when ((opcode = "1000101") and (disp_s(5) = '1')) else
	
	-- BR.SUB (Signed Extended -> 0)
	("000" & disp_s) when ((opcode = "1000110") and (disp_s(5) = '0')) else
	-- BR.SUB (Signed Extended -> 1)
	("111" & disp_s) when ((opcode = "1000110") and (disp_s(5) = '1')) else
	
	-- Format A0
	-- RETURN
	"000000000" when opcode = "1000111" else
	
	-- Format B1
	-- BRR, BRR.N, BRR.Z
	disp_l;
	



	--hazard: process (clk)
	
		-- Process instructions for stalling and/or data forwarding
		
		-- RAW Hazards
		-- Parse op_code from execute or mem stage to account for holding or data forward to if/id
		
		-- WAR Hazards
		-- Parse op_code from if/id stage or mem stage?
	
	--end process;


end Behavioral;

