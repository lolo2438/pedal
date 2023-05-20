library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

use tb_lib.tb_fn.clk_gen;

entity tremolo_tb is
end entity;

architecture tb of tremolo_tb is

  constant DATA_WIDTH   : natural := 16;
  constant PARAM_WIDTH  : natural := 10;
  constant TREMOLO_FMAX : real := 25.0;
  constant TREMOLO_FMIN : real := 0.2;
  constant CLK_FREQ     : real := 100_000_000.0;

  signal clk_i   : in  std_logic := '0';
  signal rst_i   : in  std_logic := '0';
  signal en_i    : in  std_logic := '0';
  signal data_i  : in  std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0);
  signal valid_o : out std_logic;
  signal depth_i : in  std_logic_vector(PARAM_WIDTH-1 downto 0) := (others => '0');
  signal rate_i  : in  std_logic_vector(PARAM_WIDTH-1 downto 0) := (others => '0');
  signal wave_i  : in  std_logic_vector(PARAM_WIDTH-1 downto 0) := (others => '0');

begin

  clk_gen(clk_i, CLK_FREQ);


  main:
  process
  begin
    wait;
  end process;


  DUT: entity work.tremolo(rtl)
  generic map(
    DATA_WIDTH    => DATA_WIDTH,
    PARAM_WIDTH   => PARAM_WIDTH,
    TREMOLO_FMAX  => TREMOLO_FMAX,
    TREMOLO_FMIN  => TRMEOLO_FMIN,
    CLK_FREQ      => CLK_FREQ
  )
  port map(
    clk_i   => clk_i,
    rst_i   => rst_i,
    en_i    => en_i,
    data_i  => data_i,
    data_o  => data_o,
    valid_o => valid_o,
    depth_i => depth_i,
    rate_i  => rate_i,
    wave_i  => wave_i
  );

end architecture;
