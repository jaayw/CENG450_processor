library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity output_mux is
	Port (
		clk : IN std_logic;
		rst : IN std_logic;
		
		out_en : IN std_logic;
		data_in : IN std_logic_vector(15 downto 0);
		data_out : OUT std_logic_vector(15 downto 0)
	);

end output_mux;

architecture Behavioral of output_mux is

begin

	process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
					data_out <= (others => '0');
				elsif out_en = '1' then
					data_out <= data_in;
				end if;
			end if;
	end process;

end Behavioral;

