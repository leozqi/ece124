library ieee;
  use ieee.std_logic_1164.all;

entity compx_4bit is
  port (
    a    : in    std_logic_vector(3 downto 0);
    b    : in    std_logic_vector(3 downto 0);
    agtb : out   std_logic;
    aeqb : out   std_logic;
    altb : out   std_logic
  );
end entity compx_4bit;

architecture design of compx_4bit is

begin

  agtb <= '1' when (a > b) else '0';
  aeqb <= '1' when (a = b) else '0';
  altb <= '1' when (a < b) else '0';

end architecture design;
