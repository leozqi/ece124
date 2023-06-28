library ieee;
use ieee.std_logic_1164.all;

entity compx4 is port(
	input_a, input_b : in std_logic_vector(3 downto 0);
	agtb, aeqb, altb : out std_logic
);
end compx4;

architecture compx4_logic of compx4 is

component compx1 port(
	input_a : in std_logic;
	input_b : in std_logic;
	agtb : out std_logic;
	aeqb : out std_logic;
	altb : out std_logic
	);
end component compx1;

signal result_0bit : std_logic_vector(2 downto 0);
signal result_1bit : std_logic_vector(2 downto 0);
signal result_2bit : std_logic_vector(2 downto 0);
signal result_3bit : std_logic_vector(2 downto 0);

-- Result storage format
-- 000 : (greater_out,equal_out,less_out)

-- Index:

-- MSB: 3
--      2
--      1
-- LSB: 0


begin
	COMPX1_0bit: compx1 port map(input_a(0), input_b(0), result_0bit(2), result_0bit(1), result_0bit(0));
	COMPX1_1bit: compx1 port map(input_a(1), input_b(1), result_1bit(2), result_1bit(1), result_1bit(0));
	COMPX1_2bit: compx1 port map(input_a(2), input_b(2), result_2bit(2), result_2bit(1), result_2bit(0));
	COMPX1_3bit: compx1 port map(input_a(3), input_b(3), result_3bit(2), result_3bit(1), result_3bit(0));
	
	agtb <= result_3bit(2)
		OR (
			(NOT result_3bit(2) AND result_2bit(2)))
		OR (
			(NOT result_3bit(0) AND NOT result_2bit(0) AND result_1bit(2)))
		OR (
			(NOT result_3bit(0) AND NOT result_2bit(0) AND NOT result_1bit(0) AND result_0bit(2)))
		;
	
	aeqb <= result_0bit(1) AND result_1bit(1) AND result_2bit(1) AND result_3bit(1);

	altb <= result_3bit(0)                            -- (A(3) > B(3)) ||
		OR (                                           -- (A(3) < B(3)) && (A(2) > B(2)) ||
			(result_3bit(0) AND result_2bit(2)))        -- (A(2) < B(2)) && (A(
		OR (
			(result_3bit(0) AND result_2bit(0) AND result_1bit(2)))
		OR (
			(result_3bit(0) AND result_2bit(0) AND result_1bit(0) AND result_0bit(2)))
		;

end compx4_logic;