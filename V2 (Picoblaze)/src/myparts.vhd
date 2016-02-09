library IEEE;
use IEEE.STD_LOGIC_1164.all;

package myparts is

component kcpsm3 is
    Port (      address : out std_logic_vector(9 downto 0);
            instruction : in std_logic_vector(17 downto 0);
                port_id : out std_logic_vector(7 downto 0);
           write_strobe : out std_logic;
               out_port : out std_logic_vector(7 downto 0);
            read_strobe : out std_logic;
                in_port : in std_logic_vector(7 downto 0);
              interrupt : in std_logic;
          interrupt_ack : out std_logic;
                  reset : in std_logic;
                    clk : in std_logic);
    end component;
component uart_rx is
    Port (            serial_in : in std_logic;
                       data_out : out std_logic_vector(7 downto 0);
                    read_buffer : in std_logic;
                   reset_buffer : in std_logic;
                   en_16_x_baud : in std_logic;
            buffer_data_present : out std_logic;
                    buffer_full : out std_logic;
               buffer_half_full : out std_logic;
                            clk : in std_logic);
    end component;
	 

component uart_tx is
    Port (            data_in : in std_logic_vector(7 downto 0);
                 write_buffer : in std_logic;
                 reset_buffer : in std_logic;
                 en_16_x_baud : in std_logic;
                   serial_out : out std_logic;
                  buffer_full : out std_logic;
             buffer_half_full : out std_logic;
                          clk : in std_logic);
    end component;

component clkdivider is
    generic (divideby : natural := 2);
    Port ( clk : in std_logic;
           reset : in std_logic;
           pulseout : out std_logic);
end component;

component testprg is
    Port (      address : in std_logic_vector(9 downto 0);
            instruction : out std_logic_vector(17 downto 0);
             proc_reset : out std_logic;
                    clk : in std_logic);
    end component;

component seg7_driver is
    Port(clk50: in STD_LOGIC;
			rst: in STD_LOGIC;
			char0: in STD_LOGIC_VECTOR (3 downto 0);
			char1: in STD_LOGIC_VECTOR (3 downto 0);
			char2: in STD_LOGIC_VECTOR (3 downto 0);
			char3: in STD_LOGIC_VECTOR (3 downto 0);
			anodes: out STD_LOGIC_VECTOR (3 downto 0);
			encodedChar: out STD_LOGIC_VECTOR (6 downto 0));
end component;


end myparts;


--package body <Package_Name> is
 
--end <Package_Name>;
