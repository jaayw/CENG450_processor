library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fetch_decode is

	PORT(
			clk : IN std_logic;
			rst : IN std_logic;
			
			-- input
			in_inst : IN std_logic_vector(15 downto 0); -- take in inst from rom
			
			-- output
			ra :	OUT std_logic_vector(2 downto 0);
			rb	:	OUT std_logic_vector(2 downto 0);
			rc	:	OUT std_logic_vector(2 downto 0);
			cl	:	OUT std_logic_vector(3 downto 0)
		);
		
end fetch_decode;

architecture Behavioral of fetch_decode is

begin
	
	process
	
		begin
		
			ra <= in_inst(8 downto 6); -- wr_index
			rb <= in_inst(5 downto 3); -- rd_index1 (FORMAT A1)
			rc <= in_inst(2 downto 0); -- rd_index2 (FORMAT A1)
			cl <= in_inst(3 downto 0); -- rd_index2 (FORMAT A2 - shifting)
		
	end process;

end Behavioral;

