library ieee;
use ieee.math_real.all;

entity cosine is
end entity;

architecture test of cosine is
  constant PERIOD : time := 1 ns;
  signal y : real := 0.0;
  signal s : real := 0.0;

begin

  process
    variable y0, y1, y2 : real := 0.0;
    variable x0, x1 : real := 0.0;
    variable n : natural := 0;

    variable cosw : real := cos(2.0 * MATH_PI * 0.001);

    variable zo : real := 0.001;

  begin

    while true loop
      x1 := x0;
      x0 := real(n);

      y2 := y1;
      y1 := y0;
      y0 := x0 - (cosw * x1) + (2.0*cosw*y1) - y2;

      y <= y0;
      wait for PERIOD;
      n := n + 1;
      n := n mod 1000;
    end loop;

    wait;
  end process;

end architecture;
