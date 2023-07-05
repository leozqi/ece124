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

  component compx_1bit is port (
      input_a    : in    std_logic;
      input_b    : in    std_logic;
      agtb : out   std_logic;
      aeqb : out   std_logic;
      altb : out   std_logic
    );
  end component compx_1bit;

  signal a3gtb3 : std_logic;
  signal a3eqb3 : std_logic;
  signal a3ltb3 : std_logic;
  signal a2gtb2 : std_logic;
  signal a2eqb2 : std_logic;
  signal a2ltb2 : std_logic;
  signal a1gtb1 : std_logic;
  signal a1eqb1 : std_logic;
  signal a1ltb1 : std_logic;
  signal a0gtb0 : std_logic;
  signal a0eqb0 : std_logic;
  signal a0ltb0 : std_logic;

begin

  COMP3: component compx_1bit port map (a(3), b(3), a3gtb3, a3eqb3, a3ltb3);
  COMP2: component compx_1bit port map (a(2), b(2), a2gtb2, a2eqb2, a2ltb2);
  COMP1: component compx_1bit port map (a(1), b(1), a1gtb1, a1eqb1, a1ltb1);
  COMP0: component compx_1bit port map (a(0), b(0), a0gtb0, a0eqb0, a0ltb0);

  agtb <= a3gtb3
    or ((not a3gtb3) and a2gtb2)
    or ((not a3gtb3) and (not a2gtb2) and a1gtb1)
    or ((not a3gtb3) and (not a2gtb2) and (not a1gtb1) and a0gtb0);

  aeqb <= a3eqb3 and a2eqb2 and a1eqb1 and a0eqb0;

  altb <= a3ltb3
    or (a3eqb3 and a2ltb2)
    or (a3eqb3 and a2eqb2 and a1ltb1)
    or (a3eqb3 and a2eqb2 and a1eqb1 and a0ltb0);

end architecture design;
