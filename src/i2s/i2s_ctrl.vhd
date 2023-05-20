library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity i2s_ctrl is
  generic(
    DATA_WIDTH : positive
  );
  port(
    rst_i : in  std_logic;

    sck_i : in  std_logic;
    ws_o  : out std_logic
  );
end entity;

architecture rtl of i2s_ctrl is
  signal ws : std_logic;
  signal cnt : unsigned(natural(ceil(log2(real(DATA_WIDTH))))-1 downto 0);

begin

  -- ws generator
  process(sck_i)
  begin
    if falling_edge(sck_i) then
      if rst_i = '1' then
        ws <= '0';
        cnt <= to_unsigned(DATA_WIDTH-1, cnt'length);
      else
        cnt <= cnt-1;

        if cnt = 0 then
          cnt <= to_unsigned(DATA_WIDTH-1, cnt'length);
          ws <= not ws;
        end if;

      end if;
    end if;
  end process;

  ws_o <= ws;

end architecture;
