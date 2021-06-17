library ieee;
use ieee.std_logic_1164.all;
 
package time_record is
 
 
  type t_zaman is record
	saat 		: integer range 0 to 23;
	dakika 	: integer range 0 to 59;
  end record t_zaman;
 
  constant C_ZAMAN_INIT : t_zaman := (saat => 0, dakika => 0);
   
end package time_record;