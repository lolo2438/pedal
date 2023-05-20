library ieee;
use ieee.math_real.all;

package wb_pkg is

  -- BUS DATA
  constant WB_BUS_DATA_WIDTH      : natural := 32;
  constant WB_BUS_SEL_WIDTH       : natural := natural(log2(real(WB_BUS_DATA_WIDTH)));

  -- BUS ADDRESS
  constant WB_BUS_ADDR_WIDTH      : natural := 32;

  -- DATA TAGS
  constant WB_BUS_DATA_TAG_WIDTH  : natural := 4;

  -- ADDRESS TAGS
  constant WB_BUS_ADDR_TAG_WIDTH  : natural := 4;

  -- CYCLE TAGS
  constant WB_BUS_CYCLE_TAG_WIDTH : natural := 4;

end package;
