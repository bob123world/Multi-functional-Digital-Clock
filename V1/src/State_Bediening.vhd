library ieee;
use IEEE.std_logic_1164.all;

entity state_bediening is
	PORT (
		clk : in std_logic;
		sel : in std_logic;
		tijd_en : OUT STD_LOGIC;
		datum_en : OUT STD_LOGIC;
		wekker_en : OUT STD_LOGIC;
		timer_en : OUT STD_LOGIC;
		chrono_en : OUT STD_LOGIC
	 );
end state_bediening;

architecture behavioral of state_bediening is

type state is (state0,state1,state2,state3,state4);
signal next_state: state;
signal present_state : state := state0;

signal tijd_en_int,datum_en_int,wekker_en_int,timer_en_int,chrono_en_int : std_logic := '0';


begin

process (clk)
	begin
	if rising_edge(clk) then
		if sel = '1' then
			present_state <= next_state;
		end if;
	end if;
end process;

	
process (clk) --Next-States
begin
	if rising_edge(clk) then
		case present_state is
			when state0 =>
				next_state <= state1;
			when state1 =>
				next_state <= state2;
			when state2 =>
				next_state <= state3;
			when state3 =>
				next_state <= state4;
			when others =>
				next_state <= state0;
		end case;
	end if;
end process;



process (clk) --Outputs
begin
	if rising_edge(clk) then
		case present_state is
			when state0 => --Tijdsfunctie
				chrono_en_int <= '0';
				tijd_en_int <= '1';
			when state1 => --Datumfunctie
				tijd_en_int <= '0';
				datum_en_int <= '1';
			when state2 => --Wekkerfunctie
				datum_en_int <= '0';
				wekker_en_int <= '1';
			when state3 => --Timerfunctie
				wekker_en_int <= '0';
				timer_en_int <= '1';
			when state4 => --Chronofunctie
				timer_en_int <= '0';
				chrono_en_int <= '1';
			when others =>
				null;
		end case;
	end if;
end process;

tijd_en <= tijd_en_int;
datum_en <= datum_en_int;
wekker_en <= wekker_en_int;
timer_en <= timer_en_int;
chrono_en <= chrono_en_int;

end behavioral;