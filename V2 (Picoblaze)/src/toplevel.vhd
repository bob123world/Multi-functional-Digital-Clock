----------------------------------------------------------------------------------
-- Company: EchelonEmbedded.com
-- Engineer: Doug Wenstrand
-- 
-- Create Date:    21:14:31 02/26/2008 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This is a starting point design for using the picoblaze
-- soft core processor on the digilent NEXYS2 Spartan3E starter kit.
-- Interfaces to the seven segment display, switches, buttons, leds, and serial
-- ports are provided as a quick start for any end application.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.myparts.all;

entity toplevel is
    Port (  clk25MHz : in  STD_LOGIC;
				clk100Hz : in STD_LOGIC;
				clk1Hz : in STD_LOGIC;
				But1 : in STD_LOGIC;
				But2 : in STD_LOGIC;
				But3 : in STD_LOGIC;
				But4 : in STD_LOGIC;
				C1 : out STD_LOGIC_VECTOR(3 downto 0);
				C2 : out STD_LOGIC_VECTOR(3 downto 0);
				C4 : out STD_LOGIC_VECTOR(3 downto 0);
				C5 : out STD_LOGIC_VECTOR(3 downto 0);
				C7 : out STD_LOGIC_VECTOR(3 downto 0);
				C8 : out STD_LOGIC_VECTOR(3 downto 0);
				Vsel : out STD_LOGIC_VECTOR(2 downto 0);
				Vselseg : out STD_LOGIC_VECTOR(1 downto 0);
				Wac : out STD_LOGIC;
				Alac : out STD_LOGIC;
				feS : out STD_LOGIC_VECTOR(3 downto 0);
				ftS : out STD_LOGIC_VECTOR(3 downto 0);
				feM : out STD_LOGIC_VECTOR(3 downto 0);
				ftM : out STD_LOGIC_VECTOR(3 downto 0);
				feH : out STD_LOGIC_VECTOR(3 downto 0);
				ftH : out STD_LOGIC_VECTOR(3 downto 0)				
				);
end toplevel;

architecture Behavioral of toplevel is

COMPONENT Button_Driver
	PORT(
		clk : IN std_logic;
		B1 : IN std_logic;
		B2 : IN std_logic;
		B3 : IN std_logic;
		B4 : IN std_logic;
		--enable : IN std_logic;
		StartCycl : IN std_logic;
		EndCycl : IN std_logic;          
		Buttons : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
COMPONENT bin2bcd
	PORT (
		bin: IN std_logic_vector(7 downto 0);
		e: OUT std_logic_vector(3 downto 0);
		t: OUT std_logic_vector(3 downto 0)
	);
END COMPONENT;

COMPONENT interrupthandler
	PORT (
		clk : in STD_LOGIC;
		clk100Hz : in STD_LOGIC;
		interrupt_ack: in STD_LOGIC;
		interrupt: out STD_LOGIC
	);
END COMPONENT;
	
signal out_port, in_port, port_id, in_port_reg, StartCycl_int, EndCycl_int, Buttons_int, Buttonspico_int : std_logic_vector(7 downto 0);
signal read_strobe, write_strobe, reset : std_logic;
signal address : std_logic_vector(9 downto 0);
signal instruction : std_logic_vector(17 downto 0);
signal jtag_reset, baudclk, ms_ena : std_logic;
signal Vsel_int, Vselseg_int : std_logic_vector(7 downto 0);
signal Alarmac_int, Wekkerac_int : std_logic_vector(7 downto 0);
signal sectimer, hondtimer : std_logic_vector(7 downto 0);

signal getalseg1_bin,getalseg2_bin,getalseg3_bin : std_logic_vector(7 downto 0);
signal C1_int,C2_int,C4_int,C5_int,C7_int,C8_int : std_logic_vector(3 downto 0);

signal fH_bin,fS_bin,fM_bin : std_logic_vector(7 downto 0);
signal feH_int,ftH_int,feS_int,ftS_int,feM_int,ftM_int : std_logic_vector(3 downto 0);

signal interrupt_int, interrupt_ack_int : std_logic := '0';
--signal StartCycl_int, EndCycl_int : std_logic_vector(7 downto 0) := "00000000";
--signal readbuttons : std_logic := '0';
begin


-- this is the program ROM.  The vhdl file which contains the program rom (pre-loaded with a program)
-- is made via. the assembler kcpsm3.  If JTAG loading is done, then this can be overridden.
-- when it assembles the program.  When modifying the code, make sure that you modify the file which
-- is in the project.  Or, simply replace the program rom in this 

progrom : testprg port map 
		(
		address => address,
		instruction => instruction,
		proc_reset => jtag_reset,
		clk=>clk25Mhz
		);


reset <= jtag_reset; --unless you want to hook it to a button


-- instantiate the Ken Chapman Picoblaze, and Uarts

-- Inkomende signalen van de buttons:
Inst_Button_Driver: Button_Driver PORT MAP(
		clk => clk25MHz,
		B1 => But1,
		B2 => But2,
		B3 => But3,
		B4 => But4,
		--enable => readbuttons,
		StartCycl => StartCycl_int(0),
		EndCycl => EndCycl_int(0),		
		Buttons => Buttons_int
	);

pblaze : kcpsm3 port map
     (
	  address => address,
     instruction => instruction,
     port_id => port_id,
     write_strobe => write_strobe,
     out_port => out_port,
     read_strobe => read_strobe,
     in_port => in_port_reg,
     interrupt => interrupt_int,
     interrupt_ack => interrupt_ack_int,
     reset => reset,
     clk => clk25MHz
	  );
   
Buttonspico_int <= Buttons_int when rising_edge(clk25MHz); 	

-- process for picoblaze reading

readmux: process(port_id)
begin
	case port_id is
		when x"00" => in_port <= hondtimer (7 downto 0);
		when x"01" => in_port <= sectimer (7 downto 0);
		when x"02" => in_port <= Buttonspico_int(7 downto 0);
	   when others => in_port <= x"5a";
	end case;
end process readmux;

-- register the in_port to increase speed, which we certainly don't need for 50MHz clock
-- but good practice, since PORT_ID is valid for 2 clocks
-- also serves the purpose of synchronizing the inputs, which is a good idea since the picoblaze will
-- be reading them.  Note of course that the inputs from switches...etc are not debounced, that is done in SW

in_port_reg <= in_port when rising_edge(clk25MHz);

-- Signalen die uit de picoblaze komen:


getalseg1_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"03") and (write_strobe='1'); --segment 1 binaire waarde
getalseg2_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"04") and (write_strobe='1'); --segment 2 binaire waarde
getalseg3_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"05") and (write_strobe='1'); --segment 3 binaire waarde

Vsel_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"06") and (write_strobe='1');
Vselseg_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"07") and (write_strobe='1');
Wekkerac_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"08") and (write_strobe='1');
Alarmac_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"09") and (write_strobe='1');

fH_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"10") and (write_strobe='1'); --freeze honderdsten binaire waarde
fS_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"11") and (write_strobe='1'); --freeze seconden binaire waarde
fM_bin(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"12") and (write_strobe='1'); --freeze minuten binaire waarde

--readbuttons <= out_port(0) when rising_edge(clk25MHz) and (port_id=x"13") and (write_strobe='1');
StartCycl_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"13") and (write_strobe='1');
EndCycl_int(7 downto 0) <= out_port when rising_edge(clk25MHz) and (port_id=x"14") and (write_strobe='1');


interrupts : interrupthandler port map
     (
	  clk => clk25MHz,
	  clk100Hz => clk100Hz,
	  interrupt_ack => interrupt_ack_int,
	  interrupt => interrupt_int
	  );

getalseg1_to_bcd : bin2bcd port map
     (
	  bin => getalseg1_bin,
	  e => C2_int,
	  t => C1_int
	  );
	  
getalseg2_to_bcd : bin2bcd port map
     (
	  bin => getalseg2_bin,
	  e => C5_int,
	  t => C4_int
	  );
	  
getalseg3_to_bcd : bin2bcd port map
     (
	  bin => getalseg3_bin,
	  e => C8_int,
	  t => C7_int
	  );

fH_to_bcd : bin2bcd port map
     (
	  bin => fH_bin,
	  e => feH_int,
	  t => ftH_int
	  );

fS_to_bcd : bin2bcd port map
     (
	  bin => fS_bin,
	  e => feS_int,
	  t => ftS_int
	  );

fM_to_bcd : bin2bcd port map
     (
	  bin => fM_bin,
	  e => feM_int,
	  t => ftM_int
	  );
	  
-- Tijdssignalen:
hondtimer <= hondtimer + 1 when rising_edge(clk100Hz);
sectimer <= sectimer + 1 when rising_edge(clk1Hz);
	
-- Signalen die men naar buiten stuurt:	
	
C1 <= C1_int;
C2 <= C2_int;
C4 <= C4_int;
C5 <= C5_int;
C7 <= C7_int;
C8 <= C8_int;

Vsel <= Vsel_int(2 downto 0);
Vselseg <= Vselseg_int(1 downto 0);	

Wac <= Wekkerac_int(0);
Alac <= Alarmac_int(0);	

ftH <= ftH_int;
feH <= feH_int;
ftM <= ftM_int;
feM <= feM_int;
ftS <= ftS_int;
feS <= feS_int;

end Behavioral;

