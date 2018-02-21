library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
	Port(
			-- input
			rst : IN std_logic;
         clk : IN std_logic;
			in1 : IN	std_logic_vector(15 downto 0);
			in2 : IN std_logic_vector(15 downto 0);
			alu_mode : IN std_logic_vector(2 downto 0);
			
			-- output
			result : OUT std_logic_vector(15 downto 0);
			z_flag : OUT std_logic;
			n_flag : OUT std_logic
			);
	
end alu;

architecture Behavioral of alu is

signal result_32 : std_logic_vector(31 downto 0);

begin

	process
		
		variable result_sh : std_logic_vector(15 downto 0);
		
		variable result_mul : std_logic_vector(15 downto 0);
	
		begin
		
			case alu_mode is
			
				when "000" => -- nop (mode: 0)
					result <= "0000000000000000";
			
				when "001" => -- add (mode: 1)
					result <= std_logic_vector((signed(in1) + signed(in2)));
					
				when "010" => -- sub (mode: 2)
					result <= std_logic_vector((signed(in1) - signed(in2)));
					
				when "011" => -- mul (mode: 3)
					result_mul := std_logic_vector((signed(in1(15 downto 0)) * signed(in2(15 downto 0))));
					result <= result_mul(15 downto 0);
					
				when "100" => -- nand (mode: 4)
					result <= (in1 nand in2);
					
				when "101" => -- SHL (Shift Left) (mode: 5)
									for i in 0 to 15 loop
										if i <= to_integer(unsigned(in2)) then
											result_sh := in1(14 downto 0) & '0';
										end if;
									end loop;
									
									result <= result_sh;
					
				when "110" => -- SHR (Shift Right) mode: 6)
									for i in 0 to 15 loop
										if i <= to_integer(unsigned(in2)) then
											result_sh := in1(15 downto 1) & '0';
										end if;
									end loop;
									
									result <= result_sh;
									
				when "111" => -- test (mode: 7)
					result <= "0000000000000000";
					
					if(in1 = "0") then
						z_flag <= '1';
					else
						z_flag <= '0';
					end if;
					
					if(signed(in1) < 0) then
						n_flag <= '1';
					else
						n_flag <= '0';
					end if;
					
				when others =>
					NULL;
					
			end case;
			
	end process;

-- zero flag
z_flag <=
'1' when(alu_mode = "111") and (to_integer(unsigned(in1)) = 0) else
'0' when(alu_mode = "111") and (to_integer(unsigned(in1)) /= 0) else
'0';

-- negative flag
n_flag <=
'1' when(alu_mode = "111") and (to_integer(unsigned(in1)) < 0) else
'0' when(alu_mode = "111") and (to_integer(unsigned(in1)) >= 0) else
'0';

end Behavioral;

