library ieee;
use ieee.std_logic_1164.all;

entity compx1 is port(
	input_a, input_b : in std_logic;
	agtb, aeqb, altb : out std_logic
);
end compx1;

architecture compx1_logic of compx1 is

begin
	agtb <= input_a AND (NOT input_b);
	aeqb <= input_a XNOR input_b;
	altb <= (NOT input_a) AND input_b;
end compx1;