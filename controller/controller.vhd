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
		rst : IN std_logic;
		
		-- input
		-- Instruction from various stages
		
		-- output
		-- Output to PC
		-- Hold/En/Run state?
		stall : OUT std_logic
	
	);
end controller;

architecture Behavioral of controller is

begin


	--hazard: process (clk)
	
		-- Process instructions for stalling and/or data forwarding
		
		-- RAW Hazards
		
		-- WAR Hazards
	
	--end process;


end Behavioral;

