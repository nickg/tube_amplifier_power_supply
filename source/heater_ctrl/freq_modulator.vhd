library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;
	use work.sys_ctrl_pkg.all;
	use work.ad_bus_pkg.all;
	use work.llc_pkg.all;

-- pi out function in matlab simulation 853+1422+y*1422; y = [-1, 1]

-- 1422 => 180kHz, 
-- 853 => 300kHz
-- pi out = [0, 569]
-- freq function 853+piout
-- during startup, 300kHz, duty .10-> .50 10ms slide,
-- 569 clk period, 284 clk for .5 duty -> 9014 delay per clk
entity freq_modulator is
    port(
	    modulator_clk : in std_logic;
	    dsp_clk : in std_logic;
	    rstn : in std_logic;

	    piu12_per_ctrl : in unsigned(11 downto 0);
        po4_ht_pwm : out hb_llc_pwm

	);
end freq_modulator;

architecture rtl of freq_modulator is


    signal u12_carrier: unsigned(11 downto 0);
    signal u12_deadtime : unsigned(11 downto 0);
    signal r1_u12_deadtime : unsigned(11 downto 0);
    signal s_pulse : std_logic;
    signal s1_pulse : std_logic;
    signal u12_period : unsigned(11 downto 0);

    signal dly_cntr : unsigned(13 downto 0);

    signal u12_dt_dly : unsigned(11 downto 0);
    signal u12_reset_carrier : unsigned(11 downto 0);

    type t_startup_states is (init, rampup, ready);
    signal st_startup : t_startup_states; 

    signal reset_dly_cntr : std_logic;
    signal r_po4_ht_pwm : hb_llc_pwm;

begin

    startup : process(modulator_clk)

    begin
	if rising_edge(modulator_clk) then
        r1_u12_deadtime <= u12_deadtime;
        if rstn = '0' then
            st_startup <= rampup;
            dly_cntr <= (others => '0');
            u12_period <= to_unsigned(474,12); -- 290kHz initial frequency
            u12_deadtime <= to_unsigned(461,12); -- 883/2-13 cycle initial pulse width
        else
            CASE st_startup is
                WHEN rampup => 
                    -- ramp pulse from 100ns to normal by incrementing deadime
                    dly_cntr <= dly_cntr + 1;
                    if dly_cntr = to_unsigned(350,14) then 
                        reset_dly_cntr <= '1';
                    else
                        reset_dly_cntr <= '0';
                    end if;

                    if reset_dly_cntr = '1' then
                        dly_cntr <= (others => '0');
                        u12_deadtime <= u12_deadtime - 1;
                    end if;


                    if r1_u12_deadtime = 64 then
                        st_startup <= ready;
                    else
                        st_startup <= rampup;
                    end if;


                WHEN ready =>

                    u12_period <= piu12_per_ctrl;

                WHEN others =>
                    st_startup <= rampup;
                    dly_cntr <= (others => '0');
                    u12_period <= to_unsigned(474,12); -- 290kHz initial frequency
                    u12_deadtime <= to_unsigned(461,12); -- 883/2-13 cycle initial pulse width
            end CASE;

        end if;
	end if;
    end process startup;

    freq_synth : process(modulator_clk)

    begin
	if rising_edge(modulator_clk) then
        if rstn = '0' then
            s_pulse <= '0';
            u12_reset_carrier <= to_unsigned(474,12);
        else
            u12_reset_carrier <= u12_period;
            if u12_carrier > u12_reset_carrier then
               u12_carrier <= (others => '0');
               s_pulse <= NOT s_pulse;
            else
                u12_carrier <= u12_carrier + 1;
            end if;
        end if;
	end if;
    end process freq_synth;


    pri_gate_ctrl : process(modulator_clk)
        variable sec_pwm_cntr : unsigned(11 downto 0);
        type t_dt_states is (active_pulse,deadtime);
        variable st_dt_states : t_dt_states;
    begin
	if rising_edge(modulator_clk) then
            s1_pulse <= s_pulse;
        if rstn = '0' then
            r_po4_ht_pwm <= (others => '0');
            po4_ht_pwm <= (others => '0');
            sec_pwm_cntr := (others => '0');
            u12_dt_dly <= (others => '0');
            st_dt_states := deadtime;
        else
            po4_ht_pwm <= r_po4_ht_pwm;
            CASE st_dt_states is
                WHEN active_pulse =>
                    -- gate on
                    u12_dt_dly <= (others => '0');
                    r_po4_ht_pwm.pri_high <= s1_pulse;
                    r_po4_ht_pwm.pri_low <= not s1_pulse;

                    if sec_pwm_cntr > to_unsigned(614,12) then
                        r_po4_ht_pwm.sync1 <= '0';
                        r_po4_ht_pwm.sync2 <= '0';
                    else
                        sec_pwm_cntr := sec_pwm_cntr + 1;
                        r_po4_ht_pwm.sync1 <= s1_pulse;
                        r_po4_ht_pwm.sync2 <= not s1_pulse;
                    end if;

                    if s1_pulse = s_pulse then
                        st_dt_states := active_pulse;
                    else
                        st_dt_states := deadtime;
                    end if;
                WHEN deadtime => 
                    r_po4_ht_pwm <= (others => '0');
                    sec_pwm_cntr := (others => '0');
                    if u12_dt_dly < r1_u12_deadtime then
                        u12_dt_dly <= u12_dt_dly + 1;
                        st_dt_states := deadtime;
                    else
                        u12_dt_dly <= (others => '0');
                        st_dt_states := active_pulse;
                    end if;
                WHEN others => 
                    r_po4_ht_pwm <= (others => '0');
                    po4_ht_pwm <= (others => '0');
                    sec_pwm_cntr := (others => '0');
                    u12_dt_dly <= (others => '0');
                    st_dt_states := active_pulse;
            end CASE;
        end if;
	end if;
    end process pri_gate_ctrl;
end rtl;
