library ieee;
use ieee.math_real.all;

entity ramp_gen is
end entity;

architecture test of ramp_gen is
  constant PERIOD : time := 1 ns;

  signal y : real := 0.0;
  constant k : natural := 10000;

begin

  process
    variable y0, y1, y2, x0, x1 : real := 0.0;
  begin
    for n in 0 to k loop

      x1 := x0;
      x0 := 1.0; --real(n);

      y2 := y1;
      y1 := y0;
      y0 := x1 + 2.0*y1 - y2;

      y <= y0;
      wait for PERIOD;
    end loop;
    wait;
  end process;


end architecture;
