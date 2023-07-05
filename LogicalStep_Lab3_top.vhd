library ieee;
  use ieee.std_logic_1164.all;

entity LogicalStep_Lab3_top is
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
end entity LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is

  component pb_inverter is port (
    pb_n : in  std_logic_vector(3 downto 0);
    pb   : out std_logic_vector(3 downto 0)
    );
  end component pb_inverter;
  
  component mux_4bit is port(
    logic_in0, logic_in1 : in std_logic_vector(3 downto 0);
    mux_select           : in std_logic;
    logic_out            : out std_logic_vector(3 downto 0)
    );
  end component mux_4bit;
  
  component HVAC is port(
    HVAC_SIM : in boolean;
	 clk : in std_logic;
	 run : in std_logic;
	 increase, decrease : in std_logic;
	 temp : out std_logic_vector(3 downto 0)
    );
  end component HVAC;

  component compx_4bit is port(
    a    : in    std_logic_vector(3 downto 0);
    b    : in    std_logic_vector(3 downto 0);
    agtb : out   std_logic;
    aeqb : out   std_logic;
    altb : out   std_logic
    );
  end component compx_4bit;

  component SevenSegment is port (
      hex      : in    std_logic_vector(3 downto 0);
      sevenseg : out   std_logic_vector(6 downto 0)
    );
  end component SevenSegment;

  component segment7_mux is port (
      clk  : in    std_logic := '0';
      din2 : in    std_logic_vector(6 downto 0);
      din1 : in    std_logic_vector(6 downto 0);
      dout : out   std_logic_vector(6 downto 0);
      dig2 : out   std_logic;
      dig1 : out   std_logic
    );
  end component segment7_mux;

  component Tester is port (
      mc_testmode : in    std_logic;
      i1eqi2      : in    std_logic;
      i1gti2      : in    std_logic;
      i1lti2      : in    std_logic;
      input1      : in    std_logic_vector(3 downto 0);
      input2      : in    std_logic_vector(3 downto 0);
      test_pass   : out   std_logic
    );
  end component;

  component energy_monitor is port(
    agtb : in std_logic;
    aeqb : in std_logic;
    altb : in std_logic;
    vacation_mode : in std_logic;
    MC_test_mode : in std_logic;
    window_open : in std_logic;
    door_open : in std_logic;
    furnace : out std_logic;
    at_temp : out std_logic;
    ac : out std_logic;
    blower : out std_logic;
    window : out std_logic;
    door : out std_logic;
    vacation : out std_logic;
    run : out std_logic;
    increase : out std_logic;
    decrease : out std_logic
    );
  end component;

  constant hvac_sim : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board
  -- or TRUE for doing simulations with the HVAC Component
  ------------------------------------------------------------------

  -- global clock
  signal clk_in               : std_logic;
  
  signal pb                   : std_logic_vector(3 downto 0);
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
  
  signal furnace, at_temp, ac, blower, window, door, vacation : std_logic;
  
-------------------------------------------------------------------

begin -- Here the circuit begins

  -- Assign signals to external inputs
  clk_in <= clkin_50; -- hook up the clock input

  desired_temp  <= sw(3 downto 0);
  vacation_temp <= sw(7 downto 4);

  -- Invert active-low components
  INVERTER: component pb_inverter port map (pb_n, pb);
  vacation_mode <= pb(3);
  MC_test_mode <= pb(2);
  window_open <= pb(1);
  door_open <= pb(0);

  -- Port mappings based on diagram
  MUX: component mux_4bit port map (
    desired_temp,  -- input one
    vacation_temp, -- input two
    vacation_mode, -- select
    mux_temp       -- output
  );

  HVAC1: component HVAC port map (
    hvac_sim,
    clk_in,
    run,
    increase,
    decrease,
    current_temp
  );

  COMPX_4: component compx_4bit port map (
    mux_temp,     -- input A
    current_temp, -- input B
    agtb,         -- outputs
    aeqb,
    altb
  );

  SEVENSEG_1: component SevenSegment port map (
    mux_temp, -- input
    mt_7seg   -- output
  );

  SEVENSEG_2: component SevenSegment port map (
    current_temp, -- input
    ct_7seg       -- output
  );
  
  SEVENSEG_MUX: component segment7_mux port map (
    clk_in,     -- clock
    mt_7seg,    -- inputs
    ct_7seg,
	 seg7_data,
    seg7_char2, -- outputs
    seg7_char1
  );

  TESTER1: component Tester port map (
    MC_test_mode,
	 aeqb,
	 agtb,
	 altb,
	 desired_temp,
	 current_temp,
	 MC_test_pass
  );

  ENERGY_MON: component energy_monitor port map (
    agtb,
    aeqb,
    altb,
    vacation_mode,
    MC_test_mode,
    window_open,
    door_open,
    furnace,
    at_temp,
    ac,
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
  leds(2) <= ac;
  leds(3) <= blower;
  leds(4) <= window;
  leds(5) <= door;
  leds(6) <= MC_test_pass;
  leds(7) <= vacation;

end architecture design;

