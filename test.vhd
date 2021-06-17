library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test is
generic (
c_clkfreq	: integer := 50_000_000;
c_baudrate	: integer := 9_600;
c_stopbit	: integer := 1
);
--port (
--clk			: in std_logic;
--rx_i			: in std_logic
--);
end test;

architecture Behavioral of test is

component top is
generic (
	c_clkfreq		: integer := 50_000_000;
	c_baudrate		: integer := 9_600;
	c_stopbit		: integer := 1
);
port(
	clk				: in std_logic;
	rx_i				: in std_logic;
	tx_o				: out std_logic
);
end component;

signal clk					: std_logic := '0';

constant c_clkperiod		: time := 20 ns;

signal rx_i					: std_logic := '1';

constant c_baud9600	: time := 104.16 us;

constant data_s		: std_logic_vector (7 downto 0) := "01110011"; -- s
constant data_nokta	: std_logic_vector (7 downto 0) := "00101110"; -- .
constant data_f		: std_logic_vector (7 downto 0) := "01100110"; -- f
constant data_sifir	: std_logic_vector (7 downto 0) := "00110000"; -- 0
constant data_bir		: std_logic_vector (7 downto 0) := "00110001"; -- 1
constant data_iki		: std_logic_vector (7 downto 0) := "00110010"; -- 2
constant data_uc		: std_logic_vector (7 downto 0) := "00110011"; -- 3
constant data_dort	: std_logic_vector (7 downto 0) := "00110100"; -- 4
constant data_bes		: std_logic_vector (7 downto 0) := "00110101"; -- 5
constant data_alti	: std_logic_vector (7 downto 0) := "00110110"; -- 6
constant data_yedi	: std_logic_vector (7 downto 0) := "00110111"; -- 7
constant data_sekiz	: std_logic_vector (7 downto 0) := "00111000"; -- 8
constant data_dokuz	: std_logic_vector (7 downto 0) := "00111001"; -- 9

  procedure Veri_Yaz (
    veri			       : in  std_logic_vector(7 downto 0);
    signal o_serial	 : out std_logic) is
  begin
 
    o_serial <= '0';
    wait for c_baud9600;
 
    for ii in 0 to 7 loop
      o_serial <= veri(ii);
      wait for c_baud9600;
    end loop;
 
    o_serial <= '1';
    wait for c_baud9600;
  end Veri_Yaz;

begin

i_top : top
generic map(
c_clkfreq	=> c_clkfreq	,
c_stopbit	=> c_stopbit	,
c_baudrate	=> c_baudrate
)
port map(
clk			=> clk			,
rx_i			=> rx_i	
);

P_CLKGEN : process begin
clk	<= '0';
wait for c_clkperiod/2;
clk	<= '1';
wait for c_clkperiod/2;
end process;

P_STIMULI : process begin

wait for c_clkperiod*2;

Veri_Yaz(data_s, rx_i);
Veri_Yaz(data_bir, rx_i);
Veri_Yaz(data_dokuz, rx_i);
Veri_Yaz(data_uc, rx_i);
Veri_Yaz(data_sifir, rx_i);

wait for c_baud9600*55;

Veri_Yaz(data_s, rx_i);
Veri_Yaz(data_nokta, rx_i);

wait for c_baud9600*55;

Veri_Yaz(data_f, rx_i);
Veri_Yaz(data_bir, rx_i);
Veri_Yaz(data_dokuz, rx_i);
Veri_Yaz(data_bes, rx_i);
Veri_Yaz(data_iki, rx_i);

wait for c_baud9600*55;

Veri_Yaz(data_f, rx_i);
Veri_Yaz(data_bir, rx_i);
Veri_Yaz(data_dokuz, rx_i);
Veri_Yaz(data_bir, rx_i);
Veri_Yaz(data_alti, rx_i);

wait;

end process;

end Behavioral;