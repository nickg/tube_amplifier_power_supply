library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;
	use work.sys_ctrl_pkg.all;
	use work.ad_bus_pkg.all;
    use work.onboard_ad_ctrl_pkg.all;

    use work.vendor_specifics_pkg.all;

entity data_control is
    port(
	    core_clk : in std_logic;
	    modulator_clk : in std_logic;
	    modulator_clk2 : in std_logic;
        si_pll_lock : in std_logic;

-- aux pwm
	    po_aux_pwm : out std_logic;

-- PFC pwm
	    po2_pfc_pwm : out std_logic_vector(1 downto 0);

-- heater pwm
	    po2_ht_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_ht_sec_pwm : out std_logic_vector(1 downto 0);

-- DBH pwm
	    po2_DHB_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_DHB_sec_pwm : out std_logic_vector(1 downto 0);
			
-- uart rx and tx
	    pi_uart_rx : in std_logic;
	    po_uart_tx : out std_logic;

-- ad converter A signals
	    po_ada_cs : out std_logic;
	    po_ada_clk : out std_logic;
	    pi_ada_sdata : in std_logic;
	    po3_ada_muxsel : out std_logic_vector(2 downto 0);

-- ad converter B signals
	    po_adb_cs : out std_logic;
	    po_adb_clk : out std_logic;
	    pi_adb_sdata : in std_logic;
	    po3_adb_muxsel : out std_logic_vector(2 downto 0);

-- ext ad converter 1 signals
	    po_ext_ad1_cs : out std_logic;
	    po_ext_ad1_clk : out std_logic;
	    pi_ext_ad1_sdata : in std_logic;

-- ext ad converter 2 signals
	    po_ext_ad2_cs : out std_logic;
	    po_ext_ad2_clk : out std_logic;
	    pi_ext_ad2_sdata : in std_logic;

        so_ada_ctrl : out rec_onboard_ad_ctrl_signals;
        so_adb_ctrl : out rec_onboard_ad_ctrl_signals;

	    so_uart_ready_event	: out std_logic;
	    so16_uart_rx_data	: out std_logic_vector(15 downto 0);
	    
	    si_tcmd_system_cmd : in tcmd_system_commands

);
end data_control;

architecture rtl of data_control is

component uart_event_ctrl is
	generic (
				g_CLKS_PER_BIT : integer; 
				g_RX_bytes_in_word : integer;
				g_TX_bytes_in_word : integer 
			);
	--- uart interface
	port(
		uart_Clk : in std_logic;
		
		po_uart_tx_serial : out std_logic;
		pi_uart_rx_serial : in std_logic;

		si_uart_start_event : in std_logic;
		si16_uart_tx_data : in std_logic_vector(15 downto 0);
		
		so_uart_rx_rdy : out std_logic;
		so16_uart_rx_data : out std_logic_vector(15 downto 0)
	    );
end component;


component ad_control is
	port( 
		ad_clock : in std_logic;
		ad_bus_clock : in std_logic;
        si_pll_lock : in std_logic;

-- ad converter A signals
		po_ada_cs : out std_logic;
		po_ada_clk : out std_logic;
		pi_ada_sdata : in std_logic;
		po3_ada_muxsel : out std_logic_vector(2 downto 0);

-- ad converter B signals
		po_adb_cs : out std_logic;
		po_adb_clk : out std_logic;
		pi_adb_sdata : in std_logic;
		po3_adb_muxsel : out std_logic_vector(2 downto 0);

        so_ada_ctrl : out rec_onboard_ad_ctrl_signals;
        so_adb_ctrl : out rec_onboard_ad_ctrl_signals;

		ti_ada_triggers : in t_ad_triggers;
		ti_adb_triggers : in t_ad_triggers
	    );	
end component; 

component ext_ad_control is
	port( 
		ad_clock : in std_logic;
		ad_bus_clock : in std_logic;

-- ext ad converter 1 signals
	    po_ext_ad1_cs : out std_logic;
	    po_ext_ad1_clk : out std_logic;
	    pi_ext_ad1_sdata : in std_logic;

-- ext ad converter 2 signals
	    po_ext_ad2_cs : out std_logic;
	    po_ext_ad2_clk : out std_logic;
	    pi_ext_ad2_sdata : in std_logic;

-- ext ad converter control signals, in ad clock domain
	    si_ext_ad1_start : in std_logic;
	    si_ext_ad2_start : in std_logic;

-- ext ad converter data, in ad bus clock domain
        ht_adc_control : out rec_ext_ad_ctrl;
        dhb_adc_control : out rec_ext_ad_ctrl
	);
end component;

component sw_supply_ctrl is
    port(
	    core_clk : in std_logic;
	    modulator_clk : in std_logic;
	    modulator_clk2 : in std_logic;
-- aux pwm
	    po_aux_pwm : out std_logic;
-- PFC pwm
	    po2_pfc_pwm : out std_logic_vector(1 downto 0);
-- heater pwm
	    po2_ht_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_ht_sec_pwm : out std_logic_vector(1 downto 0);
-- DBH pwm
	    po2_DHB_pri_pwm : out std_logic_vector(1 downto 0);
	    po2_DHB_sec_pwm : out std_logic_vector(1 downto 0);
-- onboard ad data in
        si_ada_ctrl : in rec_onboard_ad_ctrl_signals;
        si_adb_ctrl : in rec_onboard_ad_ctrl_signals;
-- ext ad converter data, in ad bus clock domain
        ht_adc_control : in rec_ext_ad_ctrl;
        dhb_adc_control : in rec_ext_ad_ctrl;
-- ad trigger signals
	    to_ada_triggers : out t_ad_triggers;
	    to_adb_triggers : out t_ad_triggers;
-- ext ad trigger signals, clocked in modulator_clk2 domain    
	    so_ext_ad1_start : out std_logic;
	    so_ext_ad2_start : out std_logic;
-- test data out 
	    so_std18_test_data : out std_logic_vector(17 downto 0);
-- uart rx for testing 
	    si_uart_ready_event	: in std_logic;
	    si16_uart_rx_data	: in std_logic_vector(15 downto 0);
-- system command signals from main state machine
	    si_tcmd_system_cmd : in tcmd_system_commands
	);
end component;

signal r_si_uart_start_event : std_logic;
signal r_so_uart_rx_rdy : std_logic;

signal r_so16_uart_rx_data : std_logic_vector(15 downto 0);
signal r_si16_uart_tx_data : std_logic_vector(15 downto 0);

signal r_ti_ada_triggers : t_ad_triggers;
signal r_ti_adb_triggers : t_ad_triggers;

--safe, clocked in ad bus clock domain
signal r_so16_ext_ad1_data : std_logic_vector(15 downto 0);
signal r_so16_ext_ad2_data : std_logic_vector(15 downto 0);

signal r_si_ext_ad1_start : std_logic;
signal r_si_ext_ad2_start : std_logic;
signal r_so_ext_ad1_rdy : std_logic; 
signal r_so_ext_ad2_rdy : std_logic; 

signal r_so_ada_ctrl : rec_onboard_ad_ctrl_signals;
signal r_so_adb_ctrl : rec_onboard_ad_ctrl_signals;
signal ht_adc_control : rec_ext_ad_ctrl;
signal dhb_adc_control : rec_ext_ad_ctrl;

begin

uart : uart_event_ctrl
	generic map(
				g_CLKS_PER_BIT => g_vendor_specific_uart_clks_per_bit,
				g_RX_bytes_in_word => g_vendor_specific_RX_bytes_in_word,
				g_TX_bytes_in_word => g_vendor_specific_TX_bytes_in_word 
			)
				
    port map(
		uart_Clk => core_clk,
		
		po_uart_tx_serial => po_uart_tx,
		pi_uart_rx_serial => pi_uart_rx,

		si_uart_start_event => r_si_uart_start_event,
		si16_uart_tx_data => r_si16_uart_tx_data,

		so_uart_rx_rdy => r_so_uart_rx_rdy, 
		so16_uart_rx_data => r_so16_uart_rx_data 
	    );

onboard_ad_control : ad_control 
    port map( 
		ad_clock => modulator_clk,
		ad_bus_clock => core_clk,
        si_pll_lock => si_pll_lock,

-- ad converter A signals
		po_ada_cs => po_ada_cs, 
		po_ada_clk => po_ada_clk, 
		pi_ada_sdata => pi_ada_sdata, 
		po3_ada_muxsel => po3_ada_muxsel, 

-- ad converter B signals
		po_adb_cs => po_adb_cs, 
		po_adb_clk => po_adb_clk, 
		pi_adb_sdata => pi_adb_sdata, 
		po3_adb_muxsel => po3_adb_muxsel, 

        so_ada_ctrl => r_so_ada_ctrl,
        so_adb_ctrl => r_so_adb_ctrl,

		ti_ada_triggers => r_ti_ada_triggers, 
		ti_adb_triggers => r_ti_adb_triggers 
	    );	


ext_adc : ext_ad_control
	port map( 
		ad_clock => modulator_clk2,
		ad_bus_clock => core_clk,

-- ext ad converter 1 signals
	    po_ext_ad1_cs => po_ext_ad1_cs,
	    po_ext_ad1_clk =>  po_ext_ad1_clk,
	    pi_ext_ad1_sdata =>  pi_ext_ad1_sdata,

-- ext ad converter 2 signals
	    po_ext_ad2_cs =>  po_ext_ad2_cs,
	    po_ext_ad2_clk =>  po_ext_ad2_clk,
	    pi_ext_ad2_sdata =>  pi_ext_ad2_sdata,

-- ext ad converter control signals,  ad clock doma
	    si_ext_ad1_start =>  r_si_ext_ad1_start,
	    si_ext_ad2_start =>  r_si_ext_ad2_start,

-- ext ad converter data,  ad bus clock doma
        ht_adc_control => ht_adc_control,
        dhb_adc_control => dhb_adc_control

	);

supply_ctrl_layer : sw_supply_ctrl
port map(core_clk, modulator_clk, modulator_clk2, open, po2_pfc_pwm, po2_ht_pri_pwm, po2_ht_sec_pwm, po2_dhb_pri_pwm, po2_dhb_sec_pwm, r_so_ada_ctrl, r_so_adb_ctrl, ht_adc_control, dhb_adc_control, r_ti_ada_triggers, r_ti_adb_triggers, r_si_ext_ad1_start, r_si_ext_ad2_start, open, r_so_uart_rx_rdy,r_so16_uart_rx_data, si_tcmd_system_cmd);

    test_data_streaming : process(core_clk)
	variable jeemux : unsigned(2 downto 0);

    begin
	if rising_edge(core_clk) then
        if r_so_adb_ctrl.ad_rdy_trigger = '1' then
            CASE jeemux is
            WHEN 3d"0" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"0"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"1" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"1"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"2" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"2"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"3" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"3"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"4" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"4"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"5" => 
                if r_so_ada_ctrl.std3_ad_address = 3d"5"  then
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data <= r_so_ada_ctrl.std16_ad_bus;
                else
                    r_si_uart_start_event <= '0';
                end if;
            WHEN 3d"6" => 
                    r_si_uart_start_event <= '1';
                    r_si16_uart_tx_data(2 downto 0) <= r_so_ada_ctrl.std3_ad_address;
            WHEN others => 
                --do nothing
            end CASE;
        end if;

	    if r_so_uart_rx_rdy = '1' then
			CASE r_so16_uart_rx_data is
				WHEN 16d"0" => 
					jeemux := 3d"0";
				WHEN 16d"1" => 
					jeemux := 3d"1";
				WHEN 16d"2" => 
					jeemux := 3d"2";
				WHEN 16d"3" => 
					jeemux := 3d"3";
				WHEN 16d"4" => 
					jeemux := 3d"4";
				WHEN 16d"5" => 
					jeemux := 3d"5";
				WHEN 16d"6" => 
					jeemux := 3d"6";
				WHEN others =>
					-- do nothing
			end CASE;
	    end if;
	end if;
    end process test_data_streaming;

		so_ada_ctrl <= r_so_ada_ctrl;
		so_adb_ctrl <= r_so_adb_ctrl;
end rtl;
