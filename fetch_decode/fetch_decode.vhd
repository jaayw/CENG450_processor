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
			wr_index_out : OUT std_logic_vector(2 downto 0);
			wr_data_out : OUT std_logic_vector(15 downto 0);
			ra_out :	OUT std_logic_vector(2 downto 0);
			rb_out :	OUT std_logic_vector(2 downto 0);
			rc_out :	OUT std_logic_vector(2 downto 0);
			cl_out :	OUT std_logic_vector(3 downto 0)
		);
		
end fetch_decode;

architecture Behavioral of fetch_decode is

signal op_code : std_logic_vector(6 downto 0);

begin
	
	op_code <= in_inst(15 downto 9);
	
	process(clk, rst, in_inst, op_code)
	
		begin
		
			if op_code = ("0100000" or "0100001") then
				ra_out <= in_inst(8 downto 6);
				rb_out <= (others => '0');
				rc_out <= (others => '0');
				
			else
				ra_out <= in_inst(8 downto 6); -- wr_index
				rb_out <= in_inst(5 downto 3); -- rd_index1 (FORMAT A1)
				rc_out <= in_inst(2 downto 0); -- rd_index2 (FORMAT A1)
				cl_out <= in_inst(3 downto 0); -- rd_index2 (FORMAT A2 - shifting)
			end if;
		
			-- temporary
			wr_index_out <= (others => '0');
			wr_data_out <= (others => '0');
	end process;

end Behavioral;

