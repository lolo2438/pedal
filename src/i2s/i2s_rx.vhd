library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity i2s_rx is
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
end entity;

architecture rtl of i2s_rx is

  signal cnt : unsigned(natural(ceil(log2(real(DATA_WIDTH))))-1 downto 0);

  signal dl, dr, shift_reg : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal wsd, wsd_ff, wsp : std_logic;

begin

  wsd <= ws_i when rising_edge(sck_i);
  wsd_ff <= wsd when rising_edge(sck_i);
  wsp <= wsd xor wsd_ff;

  p_cntr:
  process(sck_i)
  begin
    if falling_edge(sck_i) then
      if wsp = '1' then
        cnt <= to_unsigned(DATA_WIDTH-1, cnt'length);
      else
        cnt <= cnt - 1;
      end if;
    end if;
  end process;

  p_shift_reg:
  process(sck_i)
  begin
    if rising_edge(sck_i) then
      if wsp = '1' then
        if wsd_ff = '1' then
          dr <= shift_reg;
        else
          dl <= shift_reg;
        end if;

        shift_reg(DATA_WIDTH-2 downto 0) <= (others => '0');
        shift_reg(DATA_WIDTH-1) <= sd_i;
      else
        shift_reg(to_integer(cnt)) <= sd_i;
      end if;
    end if;
  end process;

  dl_o <= dl;
  dr_o <= dr;
  ws_o <= not wsd_ff;

end architecture;
