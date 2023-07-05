library ieee;
  use ieee.std_logic_1164.all;
  
entity energy_monitor is
  port (
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
end entity energy_monitor;

architecture design of energy_monitor is

begin
  furnace <= agtb  -- mux_temp > curr_temp
  at_temp <= aeqb; -- mux_temp = curr_temp
  ac <= altb;      -- mux_temp < curr_temp
  blower <= (not aeqb) and ((not MC_test_mode) or window_open or door_open);
  window <= window_open;
  door <= door_open;
  vacation <= vacation_mode;
  run <= (not aeqb) and (not (window_open or door_open or MC_test_mode));
  increase <= run and agtb;
  decrease <= run and altb;
end architecture design;