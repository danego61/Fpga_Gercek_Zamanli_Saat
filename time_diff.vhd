library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

use work.time_record.ALL;

entity time_diff is
generic (
	c_clkfreq	: integer := 50_000_000
);
port(
	clk			: in std_logic;
	zaman_in		: in t_zaman;
	zaman_out	: out t_zaman;
	tip			: in std_logic
);
end time_diff;

architecture Behavioral of time_diff is

	signal zaman : t_zaman := C_ZAMAN_INIT;
	signal saniye 	: integer range 0 to 59;
	signal sayac	: integer range 0 to c_clkfreq;
	
begin

zaman_out <= zaman;

P_MAIN : process(clk)

begin

	if(rising_edge(clk)) then
	
		if( tip = '1' ) then
		
			zaman 	<= zaman_in;
			saniye	<= 0;
			sayac		<= 0;
			
		else
		
			if( sayac = c_clkfreq ) then
			
				sayac 	<= 0;
				saniye 	<= saniye + 1;
				
				if ( saniye = 59 ) then
				
					saniye <= 0;
					
					if( zaman.dakika = 59 ) then
					
						if(zaman.saat = 23 ) then
						
							zaman.saat 		<= 0;
							zaman.dakika 	<= 0;
							
						else
						
							zaman.saat 		<= zaman.saat + 1;
							zaman.dakika 	<= 0;
						
						end if;
						
					else
					
						zaman.dakika 	<= zaman.dakika + 1;
					
					end if;
				
				end if;
				
			else
			
				sayac <= sayac + 1;
				
			end if;
			
		end if;
	
	end if;
	
end process P_MAIN;

end Behavioral;