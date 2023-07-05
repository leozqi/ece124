library ieee;
  use ieee.std_logic_1164.all;

  
entity mux_4bit is port(
  logic_in0, logic_in1 : in std_logic_vector(3 downto 0);
  mux_select           : in std_logic;
  logic_out            : out std_logic_vector(3 downto 0)
  );
end entity mux_4bit;


architecture design of mux_4bit is

begin
  with mux_select select logic_out <=
    logic_in0 when '0',
    logic_in1 when '1';
end architecture design;