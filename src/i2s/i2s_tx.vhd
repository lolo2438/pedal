library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity i2s_tx is
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
end entity;

architecture rtl of i2s_tx is

  signal shift_reg : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal wsd, wsd_ff, wsp : std_logic;

begin

  wsd <= ws_i when rising_edge(sck_i);
  wsd_ff <= wsd when rising_edge(sck_i);
  wsp <= wsd xor wsd_ff;

  p_shift_reg:
  process(sck_i)
  begin
    if falling_edge(sck_i) then
      if wsp = '1' then
        if wsd = '1' then
          shift_reg <= dr_i;
        else
          shift_reg <= dl_i;
        end if;
      else
        shift_reg <= shift_reg(DATA_WIDTH-2 downto 0) & '0';
      end if;
    end if;
  end process;

  sd_o <= shift_reg(DATA_WIDTH-1);

end architecture;
