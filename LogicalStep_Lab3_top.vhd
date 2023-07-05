library ieee;
  use ieee.std_logic_1164.all;

entity logicalstep_lab3_top is
  port (
    clkin_50 : in    std_logic;
    pb_n     : in    std_logic_vector(3 downto 0);
    sw       : in    std_logic_vector(7 downto 0);
    -----------------------------------------------------
    -- Simulation use only.
    -- HVAC_temp : out std_logic_vector(3 downto 0);
    -----------------------------------------------------
    leds       : out   std_logic_vector(7 downto 0);
    seg7_data  : out   std_logic_vector(6 downto 0);
    seg7_char1 : out   std_logic;
    seg7_char2 : out   std_logic
  );
end entity logicalstep_lab3_top;

architecture behaviour of logicalstep_lab3_top is

  component seven_segment is port (
      hex      : in    std_logic_vector(3 downto 0);
      sevenseg : out   std_logic_vector(6 downto 0)
    );
  end component seven_segment;

  component segment7_mux is port (
      clk  : in    std_logic := '0';
      din2 : in    std_logic_vector(6 downto 0);
      din1 : in    std_logic_vector(6 downto 0);
      dout : out   std_logic_vector(6 downto 0);
      dig2 : out   std_logic;
      dig1 : out   std_logic
    );
  end component segment7_mux;

  component tester is port (
      mc_testmode : in    std_logic;
      i1eqi2      : in    std_logic;
      i1gti2      : in    std_logic;
      i1lti2      : in    std_logic;
      input1      : in    std_logic_vector(3 downto 0);
      input2      : in    std_logic_vector(3 downto 0);
      test_pass   : out   std_logic
    );
  end component;

  component hvac is   port (
      hvac_sim : in    boolean;
      clk      : in    std_logic;
      run      : in    std_logic;
      increase : in    std_logic;
      decrease : in    std_logic;
      temp     : out   std_logic_vector(3 downto 0)
    );
  end component;

  constant hvac_sim : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board
  -- or TRUE for doing simulations with the HVAC Component
  ------------------------------------------------------------------

  -- global clock
  signal clk_in               : std_logic;
  signal hex_a,     hex_b     : std_logic_vector(3 downto 0);
  signal hexa_7seg, hexb_7seg : std_logic_vector(6 downto 0);
  signal desired_temp         : std_logic_vector(3 downto 0);
  signal vacation_temp        : std_logic_vector(3 downto 0);

  signal vacation_mode        : std_logic;
  signal MC_test_mode         : std_logic;
  signal window_open          : std_logic;
  signal door_open            : std_logic;

  signal mux_temp             : std_logic_vector(3 downto 0);
  signal current_temp         : std_logic_vector(3 downto 0);
  signal agtb, aeqb, altb     : std_logic;

  signal mt_7seg, ct_7seg     : std_logic_vector(6 downto 0);

  signal MC_test_pass         : std_logic;

  signal run                  : std_logic;
  signal increase, decrease   : std_logic;
-------------------------------------------------------------------

begin -- Here the circuit begins

  -- Assign signals to external inputs
  clk_in <= clkin_50; -- hook up the clock input

  desired_temp  <= sw(3 downto 0);
  vacation_temp <= sw(7 downto 4);

  INVERTER: component inverter port map (
    pb_n(3), pb_n(2), pb_n(1), pb_n(0),
    vacation_mode, MC_test_mode, window_open, door_open
  );

  -- Port mappings based on diagram
  MUX: component mux_4bit port map (
    desired_temp,  -- input one
    vacation_temp, -- input two
    vacation_mode, -- select
    mux_temp       -- output
  );

  HVAC: component hvac port map (
    clk_in,
    run,
    increase,
    decrease,
    current_temp
  );

  COMPX_4: component compx4 port map (
    mux_temp,     -- input A
    current_temp, -- input B
    agtb,         -- outputs
    aeqb,
    altb
  );

  SEVENSEG_1: component sevensegment port map (
    mux_temp, -- input
    mt_7seg   -- output
  );

  SEVENSEG_2: component sevensegment port map (
    current_temp, -- input
    ct_7seg       -- output
  );

  SEVENSEG_MUX: component segment7_mux port map (
    mt_7seg,    -- inputs
    ct_7seg,
    seg7_char2, -- outputs
    seg7_data,
    seg7_char1
  );

  TESTER: component Tester port map (
    desired_temp, -- inputs
    current_temp,
    MC_test_mode,
    agtb,
    aeqb,
    altb,
    MC_test_pass  -- output
  );

  ENERGY_MONITOR: component energy_monitor port map (
    agtb,
    aeqb,
    altb,
    vacation_mode,
    MC_test_mode,
    window_open,
    door_open,
    furnace,
    at_temp,
    AC,
    blower,
    window,
    door,
    vacation,
    run,
    increase,
    decrease
  );

  -- hvac_temp <= current_temp;

  -- LED set
  leds(0) <= furnace;
  leds(1) <= at_temp;
  leds(2) <= AC;
  leds(3) <= blower;
  leds(4) <= window;
  leds(5) <= door;
  leds(6) <= MC_test_pass;
  leds(7) <= vacation;

end architecture design;

