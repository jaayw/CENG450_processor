library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is

	PORT (
		clk : IN std_logic;
		rst : IN std_logic;
		
		--input
		ra_in : in std_logic_vector(2 downto 0);
		result_in : in std_logic_vector(15 downto 0);
		
		--output
		ra_out : out std_logic_vector(2 downto 0);
		result_out : out std_logic_vector(15 downto 0);
		
		--inout
		z_flag : inout std_logic;
		n_flag : inout std_logic
		
	);

end mem;

architecture Behavioral of mem is

begin

	process (clk, result_in, ra_in)
	
		begin
		
		result_out <= result_in; --alu_result;
		ra_out <= ra_in; --ra register
		n_flag <= n_flag;
		z_flag <= z_flag;
		
	end process;
		


end Behavioral;

