----------------------------------------------------------------------------------
-- Company: Artesis
-- Engineer: Michael Deboeure & Kaj Van der Hallen
-- Module Name:    	MultiFKlok - Structural
-- Project Name: 	Multifunctione klok
-- Target Devices: FPGA
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MultiFKlok is
Port	(	clk50MHz : in STD_LOGIC;
			btn1 : in STD_LOGIC;
			btn2 : in STD_LOGIC;
			btn3 : in STD_LOGIC;
			btn4 : in STD_LOGIC;
			HSync : out STD_LOGIC;
			VSync : out STD_LOGIC;
			Red : out STD_LOGIC_VECTOR(2 downto 0);
			Green : out STD_LOGIC_VECTOR(2 downto 0);
			Blue : out STD_LOGIC_VECTOR(1 downto 0)
);
end MultiFKlok;

architecture Behavioral of MultiFKlok is

COMPONENT klokdeler
	PORT (  clk50MHz_in : in  STD_LOGIC;
           clk25MHz_out : out  STD_LOGIC;
			  TC_clk100Hz_out : out  STD_LOGIC;
           TC_clk4Hz_out : out  STD_LOGIC;
           TC_clk1Hz_out : out  STD_LOGIC);
	END COMPONENT;
	
COMPONENT debouncer
	PORT (  clk : in STD_LOGIC;
			  --clk4Hz : in STD_LOGIC;
			  clk100Hz : in  STD_LOGIC;
           b1,b2,b3,b4 : in  STD_LOGIC;
			  b1_d,b2_d,b3_d,b4_d : out STD_LOGIC);
	END COMPONENT;
	
	COMPONENT toplevel
	PORT(		clk25MHz : IN std_logic;
				clk100Hz : IN std_logic;
				clk1Hz : IN std_logic;
				But1 : IN std_logic;
				But2 : IN std_logic;
				But3 : IN std_logic;
				But4 : IN std_logic;          
				C1 : OUT std_logic_vector(3 downto 0);
				C2 : OUT std_logic_vector(3 downto 0);
				C4 : OUT std_logic_vector(3 downto 0);
				C5 : OUT std_logic_vector(3 downto 0);
				C7 : OUT std_logic_vector(3 downto 0);
				C8 : OUT std_logic_vector(3 downto 0);
				Vsel : OUT std_logic_vector(2 downto 0);
				Vselseg : OUT std_logic_vector(1 downto 0);
				Wac : OUT std_logic;
				Alac : OUT std_logic;
				feS : OUT std_logic_vector(3 downto 0);
				ftS : OUT std_logic_vector(3 downto 0);
				feM : OUT std_logic_vector(3 downto 0);
				ftM : OUT std_logic_vector(3 downto 0);
				feH : OUT std_logic_vector(3 downto 0);
				ftH : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
COMPONENT VGA
	PORT (  clk : in std_logic;								-- systeemklok
			  hsync : out std_logic;								-- horizontaal synchronisatiesignaal
			  vsync : out std_logic;								-- verticaal synchronisatiesignaal
			  red : out std_logic_vector(2 downto 0);				-- uitgang naar 3 bit da-converter (rood)voor VGA scherm
			  green : out std_logic_vector(2 downto 0);			-- uitgang naar 3 bit da-converter (groen)voor VGA scherm
			  blue : out std_logic_vector(1 downto 0);				-- uitgang naar 2 bit da-converter (blauw)voor VGA scherm
			  d1,d2,d4,d5,d7,d8 : in std_logic_vector(3 downto 0);
			  VSel : in std_logic_vector (2 downto 0); -- Selectie Functie
			  VSegSel : in std_logic_vector (1 downto 0); -- Selectie blok instellen
			  Wac : in std_logic; -- Wekker actief?
			  Alac : in std_logic; -- Alarm actief?
			  clk4Hz : in std_logic;
			  feS,ftS,feM,ftM,feH,ftH : in std_logic_vector(3 downto 0)
			  );
	END COMPONENT;

--Klokdeler	
signal C25MHz_int, C100Hz_int, C4Hz_int, C1Hz_int : std_logic;
--Debouncer
signal btn1_int, btn2_int, btn3_int, btn4_int : std_logic;
--State machine
signal tijd_en_int, datum_en_int, wekker_en_int, timer_en_int, chrono_en_int : std_logic;
--VGA
signal d1_int, d2_int, d4_int, d5_int, d7_int, d8_int : std_logic_vector(3 downto 0);
--Chronometerfunctie
signal feH_int, ftH_int, feS_int, ftS_int, feM_int, ftM_int : std_logic_vector(3 downto 0);
--Selecties
signal tSel_int, dSel_int, wSel_int, TiSel_int, VSegSel_int : std_logic_vector(1 downto 0);
signal oD_int, w_ac_int, w_al_int, Ti_al_int, Wac_int, Alac_int : std_logic;
signal VSel_int : std_logic_vector(2 downto 0);
signal alarm_btn : std_logic := '0';


begin

alarm_btn <= btn1_int or btn2_int or btn3_int or btn4_int;

Inst_klokdeler: klokdeler
	PORT MAP(
			clk50MHz_in => clk50MHz,
			clk25MHz_out => C25MHz_int,
			TC_clk100Hz_out => C100Hz_int,
			TC_clk4Hz_out => C4Hz_int,
			TC_clk1Hz_out => C1Hz_int
	);

Inst_debouncing: debouncer
	PORT MAP(
			clk => C25MHz_int,
			--clk4Hz => C4Hz_int,
			clk100Hz => C100Hz_int,
			b1 => btn1,
			b2 => btn2,
			b3 => btn3,
			b4 => btn4,
			b1_d => btn1_int,
			b2_d => btn2_int,
			b3_d => btn3_int,
			b4_d => btn4_int
	);
	
Inst_toplevel: toplevel 
	PORT MAP(
			clk25MHz => C25MHz_int,
			clk100Hz => C100Hz_int,
			clk1Hz => C1Hz_int,
			But1 => btn1_int,
			But2 => btn2_int,
			But3 => btn3_int,
			But4 => btn4_int,
			C1 => d1_int,
			C2 => d2_int,
			C4 => d4_int,
			C5 => d5_int,
			C7 => d7_int,
			C8 => d8_int,
			Vsel => VSel_int,
			Vselseg => VSegSel_int,
			Wac => Wac_int,
			Alac => Alac_int,
			feS => feS_int,
			ftS => ftS_int,
			feM => feM_int,
			ftM => ftM_int,
			feH => feH_int,
			ftH => ftH_int		
	);
			
Inst_vga_initials_top: VGA
	PORT MAP(
			clk => C25MHz_int,
			hsync => HSync,
			vsync => VSync,
			red => Red,
			green => Green,
			blue => Blue,
			d1 => d1_int,
			d2 => d2_int,
			d4 => d4_int,
			d5 => d5_int,
			d7 => d7_int,
			d8 => d8_int,
			VSel => VSel_int,
			VSegSel => VSegSel_int,
			Wac => Wac_int,
			Alac => Alac_int,
			clk4Hz => C4Hz_int,
			feS => feS_int,
			ftS => ftS_int,
			feM => feM_int,
			ftM => ftM_int,
			feH => feH_int,
			ftH => ftH_int
			);
	
end Behavioral;
