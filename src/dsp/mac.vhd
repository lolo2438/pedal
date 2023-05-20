library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac is
  generic(
    INPUT_REG  : boolean;
    DATA_WIDTH : natural;
    ACC_WIDTH  : natural
  );
  port(
    clk_i : in  std_logic;
    rst_i : in  std_logic;
    op1_i : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    op2_i : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    res_o : out std_logic_vector(ACC_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of mac is

  signal op1, op2 : signed(DATA_WIDTH-1 downto 0);
  signal mul_reg  : signed(2*DATA_WIDTH-1 downto 0);
  signal acc_reg  : signed(ACC_WIDTH-1 downto 0);

begin

  g_input_reg:
  if INPUT_REG = true generate
    op1 <= signed(op1_i) when rising_edge(clk_i);
    op2 <= signed(op2_i) when rising_edge(clk_i);
  else generate
    op1 <= signed(op1_i);
    op2 <= signed(op2_i);
  end generate;


  p_mac:
  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        mul_reg <= (others => '0');
        acc_reg <= (others => '0');
      else
        mul_reg <= op1 * op2;
        acc_reg <= mul_reg + acc_reg;
      end if;
    end if;
  end process;


  res_o <= std_logic_vector(acc_reg);

end architecture;
