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
		
		-- Input
		
		-- EXE
		opc_exe : IN std_logic_vector(6 downto 0);
		ra_exe : IN std_logic_vector(2 downto 0);
		
		-- MEM
		opc_mem : IN std_logic_vector(6 downto 0);
		ra_mem : IN std_logic_vector(2 downto 0);
		
		-- WB
		opc_wb : IN std_logic_vector(6 downto 0);
		ra_mem : IN std_logic_vector(2 downto 0);

		-- Instruction from various stages
		
		-- Output
		-- Output to PC
		mux1_select : OUT std_logic_vector(2 downto 0);
		mux2_select : OUT std_logic_vector(2 downto 0);
		stall : OUT std_logic;
		displacement : OUT std_logic_vector(8 downto 0)
		--stall : OUT std_logic
	
	);
end controller;

architecture Behavioral of controller is

signal trackHazard_1 : std_logic_vector(1 downto 0) := (others => '0');
signal trackHazard_2 : std_logic_vector(1 downto 0) := (others => '0');
signal trackHazard_3 : std_logic_vector(1 downto 0) := (others => '0');

alias op_code is instr(15 downto 9);
alias instr_ra is instr(8 downto 6);
alias instr_rb is instr(5 downto 3);
alias instr_rc is instr(2 downto 0);
alias instr_cl is instr(3 downto 0);
alias disp_l is instr(8 downto 0);
alias disp_s is instr(5 downto 0);

begin

	-- Tracking Data Hazards
	trackHazard_1 <= 
		-- When (current ra == ra@exe) && (op_code@exe /= nop) && (current op_code /= return)
		"01" when ((instr_ra = ra_exe) and (opc_exe /= "0000000") and (op_code /= "1000111")) else
		-- Returning PC when ra@exe == 111
		"01" when (("111" = ra_exe) and (op_code = "1000111")) else -- RETURN
		-- When (current ra == ra@mem) && (op_code@mem /= nop) && (current op_code /= return)
		"10" when ((instr_ra = ra_mem) and (opc_mem /= "0000000") and (op_code /= "1000111")) else
		-- Returning PC when ra@mem == 111
		"10" when (("111" = ra_mem) and (op_code = "1000111")) else -- RETURN
		-- When (current ra == ra@wb) && (op_code@wb /= nop) && (current op_code /= return)
		"11" when ((instr_ra = ra_wb) and (opc_wb /= "0000000") and (op_code /= "1000111")) else
		-- Returning PC when ra@mem == 111
		"11" when (("111" = ra_wb) and (op_code = "1000111")) else -- RETURN
		-- When others
		"00";
	
	trackHazard_2 <=
		-- When (current rb == rb@exe) && (op_code@exe /= nop) && (current op_code /= return)
		"01" when ((instr_rb = ra_exe) and (opc_exe /= "0000000") and (op_code /= "1000111")) else
		-- When (current rb == rb@mem) && (op_code@mem /= nop) && (current op_code /= return)
		"10" when ((instr_rb = ra_mem) and (opc_mem /= "0000000") and (op_code /= "1000111")) else
		-- When (current rb == rb@wb) && (op_code@wb /= nop) && (current op_code /= return)
		"11" when ((instr_rb = ra_wb) and (opc_wb /= "0000000") and (op_code /= "1000111")) else
		"00";
	
	trackHazard_3 <=
		-- When (current rc == rc@exe) && (op_code@exe /= nop) && (current op_code /= return)
		"01" when ((instr_rc = ra_exe) and (opc_exe /= "0000000") and (op_code /= "1000111")) else
		-- When (current rc == rc@mem) && (op_code@mem /= nop) && (current op_code /= return)
		"10" when ((instr_rc = ra_mem) and (opc_mem /= "0000000") and (op_code /= "1000111")) else
		-- When (current rc == rc@wb) && (op_code@wb /= nop) && (current op_code /= return)
		"11" when ((instr_rc = ra_wb) and (opc_wb /= "0000000") and (op_code /= "1000111")) else
		"00";

	-- Branching (Format B)
	displacement <=
		-- Format B2
		-- BR (Signed Extended -> 0)
		("000" & disp_s) when ((op_code = "1000011") and (disp_s(5) = '0')) else
		-- BR (Signed Extended -> 1)
		("111" & disp_s) when ((op_code = "1000011") and (disp_s(5) = '1')) else
		
		-- BR.N (Signed Extended -> 0)
		("000" & disp_s) when ((op_code = "1000100") and (disp_s(5) = '0')) else
		-- BR.N (Signed Extended -> 1)
		("111" & disp_s) when ((op_code = "1000100") and (disp_s(5) = '1')) else
		
		-- BR.Z (Signed Extended -> 0)
		("000" & disp_s) when ((op_code = "1000101") and (disp_s(5) = '0')) else
		-- BR.Z (Signed Extended -> 1)
		("111" & disp_s) when ((op_code = "1000101") and (disp_s(5) = '1')) else
		
		-- BR.SUB (Signed Extended -> 0)
		("000" & disp_s) when ((op_code = "1000110") and (disp_s(5) = '0')) else
		-- BR.SUB (Signed Extended -> 1)
		("111" & disp_s) when ((op_code = "1000110") and (disp_s(5) = '1')) else
		
		-- Format A0
		-- RETURN
		"000000000" when op_code = "1000111" else
		
		-- Format B1
		-- BRR, BRR.N, BRR.Z
		disp_l;
	

	hazardDetect: process(instr, op_code, opc_exe, opc_mem, opc_wb, trackHazard_1, trackHazard_2, trackHazard_3)
	
		begin
		
			case op_code is
			
				-- ADD or SUB or MUL or NAND (i think)
				-- Check for write back
				when "0000001" | "0000010" | "0000011" | "0000100" =>
					case trackHazard_2 is
						when "01" =>
							case opc_exe is
								-- IN @ EXE
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOAD @ EXE
								-- Stall to allow load from MEM
								when "0010000" =>
									stall <= '1';
									mux1_select <= "000";
								
								when others =>
									-- Forward data from EXE
									mux1_select <= "101";
									
							end case; -- end opc_exe case select
						
						when "10" =>
							case opc_mem is
								-- IN @ MEM
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								when others =>
									-- Forward data from MEM
									mux1_select <= "110";
							
							end case; -- end opc_mem case select
						
						when "11" =>
							-- Forwarded data from WB
							mux1_select <= "111";
						
						when others =>
							mux1_select <= "000";
							
					end case; -- end trackHazard_2
					
					case trackHazard_3 is
						when "01" =>
							case opc_exe is
								-- IN @ EXE 
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux2_select <= "000";
								
								-- LOAD @ EXE
								-- Stall to allow load from MEM
								when "0010000" =>
									stall <= '1';
									mux2_select <= "000";
								
								when others =>
									-- Forward data from EXE
									mux2_select <= "101";
									
							end case; -- end opc_exe case select
						
						when "10" =>
							case opc_mem is
								-- IN @ MEM
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux2_select <= "000";
							
								when others =>
								-- Forward data from MEM
								mux2_select <= "110";
								
							end case; -- end opc_mem case select
					
						when "11" =>
							-- Forward data from WB
							mux2_select <= "111";
						
						when others =>
							mux2_select <= "000";
						
					end case; -- end trackHazard_3
					-- end when ADD, SUB, MUL, NAND case
				
				-- SHL or SHR
				when "0000101" | "0000110" =>
					-- Check for write back
					case trackHazard_1 is
						when "01" =>
							case opc_exe is
								-- IN @ EXE
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOADIMM @ EXE
								-- Stall to allow WB to finish
								when "0010010" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOAD @ EXE
								-- Stall to allow load from MEM
								when "0010000" =>
									stall <= '1';
									mux1_select <= "000";
								
								when others =>
									-- Forward data from EXE
									mux1_select <= "101";
									
							end case; -- end opc_exe case select
						
						when "10" =>
							case opc_mem is
								-- IN @ MEM
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOADIMM @ MEM
								-- Stall to allow WB to finish
								when "0100010" =>
									stall <= '1';
									mux1_select <= "000";
									
								when others =>
									-- Forward data from MEM
									mux1_select <= "110";
							
							end case; -- end opc_mem case select
						
						when "11" =>
							case opc_wb is
								
								-- LOADIMM @ MEM
								-- Stall to allow WB to finish
								when "0100010" =>
								stall <= '1';
								mux1_select <= "000";
								
								when others =>
									-- Forward data from WB
									mux1_select <= "111";
							end case;
						
						when others =>
							mux1_select <= "000";
							
					end case; -- end trackHazard_1
					
					-- IMM
					mux2_select <= "001";
					-- end when SHR or SHL case
				
				-- TEST
				when "0000011" | "0100000" =>
					-- Check for write back
					case trackHazard_1 is
						when "01" =>
							case opc_exe is
								-- IN @ EXE
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOADIMM @ EXE
								-- Stall to allow WB to finish
								when "0010010" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOAD @ EXE
								-- Stall to allow load from MEM
								when "0010000" =>
									stall <= '1';
									mux1_select <= "000";
								
								when others =>
									-- Forward data from EXE
									mux1_select <= "101";
									
							end case; -- end opc_exe case select
						
						when "10" =>
							case opc_mem is
								-- IN @ MEM
								-- Stall to allow WB to finish
								when "0100001" =>
									stall <= '1';
									mux1_select <= "000";
									
								-- LOADIMM @ MEM
								-- Stall to allow WB to finish
								when "0100010" =>
									stall <= '1';
									mux1_select <= "000";
									
								when others =>
									-- Forward data from MEM
									mux1_select <= "110";
							
							end case; -- end opc_mem case select
						
						when "11" =>
							case opc_wb is
								-- LOADIMM @ MEM
								-- Stall to allow WB to finish
								when "0100010" =>
								stall <= '1';
								mux1_select <= "000";
								
								when others =>
									-- Forward data from WB
									mux1_select <= "111";
							end case;
						
						when others =>
							mux1_select <= "000";
							
					end case; -- end trackHazard_1
					
					-- IMM
					mux2_select <= "000";
					-- end when TEST or OUT case
				
				-- IN
				when "0100001" =>
				
				-- BRR
				when "1000000" =>

				-- BRR.N
				when "1000001" =>
				
				-- BRR.Z
				when "1000010" =>
				
				-- BR
				when "1000011" =>
				
				-- BRR.N
				when "1000100" =>
				
				-- BRR.Z
				when "1000101" =>
				
				-- BRR.SUB
				when "1000110" =>
				
				-- RETURN
				when "1000111" =>
			
			end case;
		-- Process instructions for stalling and/or data forwarding
		
		-- RAW Hazards
		-- Parse op_code from execute or mem stage to account for holding or data forward to if/id
		
		-- WAR Hazards
		-- Parse op_code from if/id stage or mem stage?
	
	end process;


end Behavioral;

