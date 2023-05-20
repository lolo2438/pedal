library ieee;
use ieee.std_logic_1164.all;

--use tb.fn_pkg.all;

entity i2s_tb is
end entity;

architecture tb of i2s_tb is

  constant DATA_WIDTH : positive := 24;
  signal rst : std_logic := '0';
  signal sck : std_logic := '0';
  signal dr_rx : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal dl_rx : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal dl_tx : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal dr_tx : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  signal ws  : std_logic := '0';
  signal ws_rx : std_logic := '0';
  signal sd  : std_logic := '0';

  component i2s_ctrl is
    generic(
      DATA_WIDTH : positive
    );
    port(
      rst_i : in  std_logic;
      sck_i : in  std_logic;
      ws_o  : out std_logic
    );
  end component;

  component i2s_rx is
    generic(
      DATA_WIDTH : positive
    );
    port(
      dl_o  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      dr_o  : out std_logic_vector(DATA_WIDTH-1 downto 0);
      ws_o  : out std_logic;
      sck_i : in  std_logic;
      ws_i  : in  std_logic;
      sd_i  : in  std_logic
    );
  end component;

  component i2s_tx is
    generic(
      DATA_WIDTH : positive
    );
    port(
      dl_i  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      dr_i  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      sck_i : in  std_logic;
      ws_i  : in  std_logic;
      sd_o  : out std_logic
    );
  end component;

  procedure clk_gen(signal clk      : out std_logic;
                      constant FREQ   : real;
                      constant PHASE  : time := 0 fs) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin
      -- Check the arguments
    assert (HIGH_TIME /= 0 fs)
    report "clk_gen: High time is zero; time resolution to large for frequency"
    severity FAILURE;

      -- Clock generator
    clk <= '0';
    wait for PHASE;

    loop
      clk <= '1';
      wait for HIGH_TIME;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

begin

  clk_gen(sck, 48000.0);

  main:
  process
  begin
    rst <= '1';
    wait for 1 ms;
    wait until rising_edge(sck);
    rst <= '0';

    dr_tx <= x"ABCDEF";
    dl_tx <= x"012345";
    wait for 100 ms;
    assert false severity failure;
  end process;

  CTRL_DUT : i2s_ctrl
  generic map (DATA_WIDTH => DATA_WIDTH)
  port map(rst_i => rst, sck_i => sck, ws_o => ws);

  RX_DUT: i2s_rx
  generic map (DATA_WIDTH => DATA_WIDTH)
  port map (dl_o => dl_rx, dr_o => dr_rx, sck_i => sck, ws_i => ws, ws_o => ws_rx, sd_i => sd);

  TX_DUT: i2s_tx
  generic map (DATA_WIDTH => DATA_WIDTH)
  port map (dl_i => dl_tx, dr_i => dr_tx, sck_i => sck, ws_i => ws, sd_o => sd);

end architecture;
