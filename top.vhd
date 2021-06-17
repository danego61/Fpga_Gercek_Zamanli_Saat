library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.time_record.ALL;

entity top is
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
end top;

architecture Behavioral of top is

component uart_rx is 
generic (
c_clkfreq		: integer := 50_000_000;
c_baudrate		: integer := 9_600
);
port (
clk				: in std_logic;
rx_i				: in std_logic;
dout_o			: out std_logic_vector (7 downto 0);
rx_done_tick_o	: out std_logic
);
end component;

component uart_tx is
generic (
c_clkfreq		: integer := 50_000_000;
c_baudrate		: integer := 9_600;
c_stopbit		: integer := 1
);
port (
clk				: in std_logic;
din_i				: in std_logic_vector (7 downto 0);
tx_start_i		: in std_logic;
tx_o				: out std_logic;
tx_done_tick_o	: out std_logic;
tx_process		: out std_logic
);
end component;

component main_controller is
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
end component;

component time_controller is
generic (
	c_clkfreq		: integer := 50_000_000
);
port(
	clk			: in std_logic;
	zaman_in		: in t_zaman;
	zaman_out	: out t_zaman;
	tip			: in std_logic
);
end component;

	signal reel_zaman	: t_zaman;
	signal set_zaman 	: t_zaman;
	signal tip			: std_logic;
	
signal rx_data 	: std_logic_vector ( 7 downto 0);
signal rx_done		: std_logic;
signal tx_data		: std_logic_vector (7 downto 0);
signal tx_start	: std_logic;
signal tx_process	: std_logic;

begin

i_uart_rx : uart_rx
generic map (
c_clkfreq		=> c_clkfreq,	
c_baudrate		=> c_baudrate
)
port map(
clk				=> clk,
rx_i				=> rx_i,
dout_o			=> rx_data,
rx_done_tick_o	=> rx_done
);

i_uart_tx : uart_tx
generic map (
c_clkfreq		=> c_clkfreq,	
c_baudrate		=> c_baudrate,
c_stopbit		=> c_stopbit	
)
port map(
clk				=> clk,
din_i				=> tx_data,
tx_start_i		=> tx_start,
tx_o				=> tx_o,
tx_process 		=> tx_process
);


t_main_controller : main_controller
port map(
	clk				=> clk,
	rx_data			=> rx_data,
	rx_done			=> rx_done,
	tx_data			=> tx_data,
	tx_start_c		=> tx_start,
	tx_process		=> tx_process,
	zaman_in			=> set_zaman,
	zaman_out		=> reel_zaman,
	tip				=> tip
);

i_time_controller : time_controller
generic map (
	c_clkfreq		=> c_clkfreq
)
port map(
	clk				=> clk,
	zaman_in			=> reel_zaman,
	zaman_out		=> set_zaman,
	tip				=> tip
);

end Behavioral;