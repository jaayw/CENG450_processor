library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fetch is

	PORT (
		clk : in std_logic;
		rst : in std_logic
		--take in an instruction
		--put out an instruction
		--determine pc state?
	);

end fetch;

architecture Behavioral of fetch is

begin


end Behavioral;

