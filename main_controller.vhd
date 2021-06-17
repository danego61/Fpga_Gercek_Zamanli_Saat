library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

use work.time_record.ALL;

entity main_controller is
port(
	clk			: in std_logic;
	rx_data		: in std_logic_vector (7 downto 0);
	rx_done		: in std_logic;
	tx_data		: out std_logic_vector (7 downto 0);
	tx_start_c	: out std_logic;
	tx_process	: in std_logic;
	zaman_in		: in t_zaman;
	zaman_out	: out t_zaman;
	tip			: out std_logic := '0'
);
end main_controller;

architecture Behavioral of main_controller is

type states is (S_IDLE, S_READ_COMMAND, S_PROCESS, S_SEND);
type commands is (C_SET_CLOCK, C_SEND_CLOCK, C_CLOCK_DIFF);

constant C_S					: std_logic_vector(7 downto 0) := "01110011"; -- s
constant C_F					: std_logic_vector(7 downto 0) := "01100110"; -- f
constant C_N					: std_logic_vector(7 downto 0) := "00101110"; -- .
constant C_A					: std_logic_vector(7 downto 0) := "00101011"; -- +
constant C_E					: std_logic_vector(7 downto 0) := "00101101"; -- -
signal state 					: states := S_IDLE;
signal command 				: commands := C_SEND_CLOCK;
signal zaman					: t_zaman := C_ZAMAN_INIT;
signal command_clock_cntr	: integer range 0 to 3;
signal tx_start_counter		: integer range 0 to 50;
signal zaman_tip				: std_logic := '0';
signal fark_isaret			: std_logic_vector(7 downto 0) := C_A;
signal tx_start				: std_logic := '0';

begin

tx_start_c <= tx_start;

P_MAIN : process(clk)

	variable integer_val : integer range 0 to 9;

begin

	if(rising_edge(clk)) then
	
	
		if(tx_start = '1') then
		
			if(tx_start_counter = 50) then
				
				tx_start_counter 	<= 0;
				tx_start				<= '0';
			
			else
			
				tx_start_counter 	<= tx_start_counter + 1;
			
			end if;
		
		end if;
	
		case state is
		
			when S_IDLE =>
				
				if(rx_done = '1') then
				
					command_clock_cntr <= 0;
					
					case rx_data is
						
						when C_S => -- s
							
							command <= C_SEND_CLOCK;
							state <= S_READ_COMMAND;
							
						when C_F => --f
							
							command <= C_CLOCK_DIFF;
							state <= S_READ_COMMAND;
							
						when others =>
						
							state <= S_IDLE;
						
					end case;
				
				end if;
				
			when S_READ_COMMAND =>
			
				if(rx_done = '1') then
				
					if(rx_data = C_N) then -- .
					
						if(command = C_SEND_CLOCK) then
								
							state <= S_PROCESS;
								
						end if;
							
					else
					
						integer_val := to_integer(unsigned(rx_data)) - 48;
						case command_clock_cntr is
						
							when 0 =>
							
								zaman.saat <= integer_val * 10;
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 1 =>
							
								zaman.saat <= integer_val + zaman.saat;
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 2 =>
							
								zaman.dakika <= integer_val * 10;
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 3 =>
							
								if(command = C_SEND_CLOCK) then
								
									command <= C_SET_CLOCK;
								
								end if;
								zaman.dakika <= integer_val + zaman.dakika;
								state <= S_PROCESS;
							
						end case;
							
					end if;
				
				end if;
			
			when S_PROCESS =>
				
				if(tx_start = '0' and tx_process = '0') then
					
					case command is
					
						when C_SET_CLOCK =>
							
							zaman_tip		<= '1';
							tx_data  		<= C_S;
							tx_start 		<= '1';
							state <= S_SEND;
							command_clock_cntr <= 0;
						
						when C_SEND_CLOCK =>
							
							zaman 			<= zaman_in;
							tx_data  		<= C_S;
							tx_start 		<= '1';
							state <= S_SEND;
							command_clock_cntr <= 0;
						
						when C_CLOCK_DIFF =>
							
							if( zaman.saat > zaman_in.saat ) then
							
								fark_isaret <= C_A;
								if ( zaman.dakika >= zaman_in.dakika ) then
								
									zaman.dakika 	<= zaman.dakika - zaman_in.dakika;
									zaman.saat		<= zaman.saat - zaman_in.saat;
									tx_data  <= C_A;
									tx_start <= '1';
									state <= S_SEND;
									command_clock_cntr <= 0;
									
								else
								
									zaman.dakika 	<= 60 - zaman_in.dakika + zaman.dakika;
									zaman.saat		<= zaman.saat - zaman_in.saat - 1;
									tx_data  <= C_A;
									tx_start <= '1';
									state <= S_SEND;
									command_clock_cntr <= 0;
								
								end if;
								
							else
							
								if ( zaman.dakika >= zaman_in.dakika ) then
								
									if ( zaman.saat = zaman_in.saat ) then
								
										fark_isaret <= C_A;
										tx_data  <= C_A;
									
									else
									
										fark_isaret <= C_E;
										tx_data  <= C_E;
									
									end if;
									zaman.dakika 	<= zaman.dakika - zaman_in.dakika;
									zaman.saat		<= zaman_in.saat - zaman.saat;
									tx_start <= '1';
									state <= S_SEND;
									command_clock_cntr <= 0;
									
								else
								
									fark_isaret <= C_E;
									zaman.dakika 	<= zaman_in.dakika - zaman.dakika;
									zaman.saat		<= zaman_in.saat - zaman.saat;
									tx_data  <= C_E;
									tx_start <= '1';
									state <= S_SEND;
									command_clock_cntr <= 0;
								
								end if;
							
							end if;
						
					end case;
					
				end if;
				
			when S_SEND =>
			
				if(tx_start = '0' and tx_process = '0') then
				
					if(zaman_tip = '1') then

						zaman_tip <= '0';
					
					end if;
					
					case command_clock_cntr is
						
							when 0 =>
								
								tx_data <= std_logic_vector(
									to_unsigned(((zaman.saat / 10) mod 10) + 48, tx_data'length)
								);
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 1 =>
							
								tx_data <= std_logic_vector(
									to_unsigned((zaman.saat mod 10) + 48, tx_data'length)
								);
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 2 =>
							
								tx_data <= std_logic_vector(
									to_unsigned(((zaman.dakika / 10) mod 10) + 48, tx_data'length)
								);
								command_clock_cntr <= command_clock_cntr + 1;
								
							when 3 =>
								
								tx_data <= std_logic_vector(
									to_unsigned((zaman.dakika mod 10) + 48, tx_data'length)
								);
								state <= S_IDLE;
							
						end case;
						tx_start <= '1';
				
				end if;
			
		end case;
		
	end if;

end process P_MAIN;

tip <= zaman_tip;
zaman_out <= zaman;

end Behavioral;