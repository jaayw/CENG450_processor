library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file is
	port(
		clk: in std_logic;
		rst : in std_logic;

		-- input
		rd_index1: in std_logic_vector(2 downto 0); 
		rd_index2: in std_logic_vector(2 downto 0); 
		wr_index: in std_logic_vector(2 downto 0); 
		wr_data_reg: in std_logic_vector(15 downto 0);
		wr_enable_reg: in std_logic;
		loadimm_en : IN std_logic;
		loadimm_select : IN std_logic_vector(1 downto 0);
		loadimm_data : IN std_logic_vector(7 downto 0);
		mov_en : IN std_logic;
		src_reg : IN std_logic_vector(2 downto 0);
		dest_reg : IN std_logic_vector(2 downto 0);
		
		-- output
		rd_data1: out std_logic_vector(15 downto 0); 
		rd_data2: out std_logic_vector(15 downto 0)

	);
end register_file;

architecture behavioural of register_file is

type reg_array is array (integer range 0 to 7) of std_logic_vector(15 downto 0);

signal reg_file : reg_array := (x"0000", x"0101", x"0A0A", x"0F0F", x"00AA", x"FF00", x"1111", x"FFFF");

-- FOR TESTING
--:= (x"0000", x"0101", x"0A0A", x"0F0F", x"00AA", x"FF00", x"1111", x"FFFF");

begin

--write operation 
process(clk)

	begin
		if(clk='0' and clk'event) then if(rst='1') then
			for i in 0 to 7 loop
				reg_file(i)<= reg_file(i);--(others => '0'); 
			end loop;
		elsif(wr_enable_reg='1' and loadimm_en = '0') then
			case wr_index(2 downto 0) is
				when "000" => reg_file(0) <= wr_data_reg;
				when "001" => reg_file(1) <= wr_data_reg;
				when "010" => reg_file(2) <= wr_data_reg;
				when "011" => reg_file(3) <= wr_data_reg;
				when "100" => reg_file(4) <= wr_data_reg;
				when "101" => reg_file(5) <= wr_data_reg;
				when "110" => reg_file(6) <= wr_data_reg;
				when "111" => reg_file(7) <= wr_data_reg;
				when others => NULL;
			end case;
		elsif (wr_enable_reg = '0' and loadimm_en = '1' and mov_en = '0') then -- INSERT MOV COND
			if loadimm_select = "01" then
				reg_file(7)(7 downto 0) <=loadimm_data;
			elsif loadimm_select = "10" then
				reg_file(7)(15 downto 8) <= loadimm_data;
			end if;
		 
		 elsif (wr_enable_reg = '0' and loadimm_en = '0' and mov_en = '1') then
			case dest_reg is
				when "000" => reg_file(0) <= reg_file(conv_integer(src_reg));
				when "001" => reg_file(1) <= reg_file(conv_integer(src_reg));
				when "010" => reg_file(2) <= reg_file(conv_integer(src_reg));
				when "011" => reg_file(3) <= reg_file(conv_integer(src_reg));
				when "100" => reg_file(4) <= reg_file(conv_integer(src_reg));
				when "101" => reg_file(5) <= reg_file(conv_integer(src_reg));
				when "110" => reg_file(6) <= reg_file(conv_integer(src_reg));
				when "111" => reg_file(7) <= reg_file(conv_integer(src_reg));
				when others => NULL;
			end case;
			
--			case dest_reg is
--			end case;
		end if; 
    end if;
end process;-- end write operation

	--read operation
	rd_data1 <=	
		reg_file(0) when(rd_index1="000") else
		reg_file(1) when(rd_index1="001") else
		reg_file(2) when(rd_index1="010") else
		reg_file(3) when(rd_index1="011") else
		reg_file(4) when(rd_index1="100") else
		reg_file(5) when(rd_index1="101") else
		reg_file(6) when(rd_index1="110") else reg_file(7);

	rd_data2 <=
		reg_file(0) when(rd_index2="000") else
		reg_file(1) when(rd_index2="001") else
		reg_file(2) when(rd_index2="010") else
		reg_file(3) when(rd_index2="011") else
		reg_file(4) when(rd_index2="100") else
		reg_file(5) when(rd_index2="101") else
		reg_file(6) when(rd_index2="110") else reg_file(7);

end behavioural;