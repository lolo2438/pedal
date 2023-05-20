--------------------------------------------------
--! \file tremolo.vhd
--! This tremolo module implements the formula
--! \f$y(t)=x(t)*\frac{1+A*w(t)}{1+A}f$
--! Where w(t) is a generated waveform
--!
--! Three parameters are available to the user:
--!   - Depth controls the amplitude of the modulation (A in the equation)
--!   - Rate controls the modulation frequency of the tremolo (TREMOLO_FMIN to TREMOLO_FMAX)
--!   - Wave controls the shape of the modulation. 5 Waves shape are available:
--!       sine, triangle, ramp, sawtooth and square.
--!
--! \author Laurent Tremblay
--! \version 1.0
--! \date 2023-02-
--------------------------------------------------
-- Log
--! \author Laurent tremblay
--! \version: 1.0
--! \brief Initial release
--------------------------------------------------

-- TODO: HARMONIC TREMOLO!! (HPF + LPF, signal dephasé + un tremolo)
-- TODO: VIBRATO!!! (un frequency shifter (un tremolo mais sur la frequence)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tremolo is
  generic(
    DATA_WIDTH  : natural;
    PARAM_WIDTH : natural;
    TREMOLO_FMAX : real;
    TREMOLO_FMIN : real;
    CLK_FREQ    : real
  );
  port(
    clk_i   : in  std_logic;
    rst_i   : in  std_logic;
    en_i    : in  std_logic;
    data_i  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    valid_o : out std_logic;
    depth_i : in  std_logic_vector(PARAM_WIDTH-1 downto 0); -- OK: Equation du tremolo
    rate_i  : in  std_logic_vector(PARAM_WIDTH-1 downto 0); -- OK: Frequence du waveform genere
    wave_i  : in  std_logic_vector(PARAM_WIDTH-1 downto 0)  -- OK: Type de waveform genere
  );
end entity;

architecture rtl of tremolo is

  -- WAVE PARAMETER
  -- TODO: LOG Wave
  type wave_shape_t is (WAVE_SINE, WAVE_TRIANGLE, WAVE_RAMP, WAVE_SAWTOOTH, WAVE_SQUARE);
  constant NB_WAVE_SHAPES : natural := 5;
  constant WAVE_SHAPE_DELTA : natural := 2**PARAM_WIDTH / NB_WAVE_SHAPES;
  signal wave_shape : wave_shape_t;

  constant W : real := 2.0 * MATH_PI * (2.0**DATA_WIDTH);
  constant COSW   : signed(DATA_WIDTH-1 downto 0) := to_signed(natural(ceil(cos(W)) * (2.0**DATA_WIDTH)), DATA_WIDTH);

  signal waveform : signed(DATA_WIDTH-1 downto 0);
  signal wave     : signed(DATA_WIDTH-1 downto 0);

  signal n1 : signed(DATA_WIDTH-1 downto 0);
  signal n : signed(DATA_WIDTH-1 downto 0);

  signal sine2    : signed(DATA_WIDTH-1 downto 0);
  signal sine1    : signed(DATA_WIDTH-1 downto 0);
  signal sine     : signed(DATA_WIDTH-1 downto 0);
  signal triangle : signed(DATA_WIDTH-1 downto 0);
  signal ramp     : signed(DATA_WIDTH-1 downto 0);
  signal sawtooth : signed(DATA_WIDTH-1 downto 0);
  signal square   : signed(DATA_WIDTH-1 downto 0);

  -- RATE PARAMETER
  constant PERIOD_FMIN_REAL       : real := (1.0/TREMOLO_FMIN);
  constant PERIOD_FMAX_REAL       : real := (1.0/TREMOLO_FMAX);

  constant RATE_COEFF         : natural := natural(((PERIOD_FMIN_REAL - PERIOD_FMAX_REAL) * CLK_FREQ) / (2.0**DATA_WIDTH * 2.0**PARAM_WIDTH));
  constant RATE_INITIAL       : natural := natural(PERIOD_FMAX_REAL * CLK_FREQ / 2.0**DATA_WIDTH);
  constant PERIOD_CNTR_WIDTH  : natural := natural(ceil(log2(real(RATE_COEFF*(2**PARAM_WIDTH)+RATE_INITIAL))));
  signal rate_delta         : unsigned(PERIOD_CNTR_WIDTH-1 downto 0);
  signal rate_cntr          : unsigned(PERIOD_CNTR_WIDTH-1 downto 0);

  -- DEPTH PARAMETER + TREMOLO
  signal tremolo_mod : signed(2*DATA_WIDTH+PARAM_WIDTH-1 downto 0);
  signal tremolo_add : signed(2*DATA_WIDTH+PARAM_WIDTH-1 downto 0);

begin

  assert PERIOD_FMAX_REAL > PERIOD_FMIN_REAL report "FMAX <= FMIN" severity failure;


  p_rate_delta: -- TODO: Register
  rate_delta <= RATE_COEFF * unsigned(rate_i) + RATE_INITIAL;


  p_rate_cntr:
  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        rate_cntr <= rate_delta;
      elsif en_i = '1' then
        if rate_cntr = 0 then
          rate_cntr <= rate_delta;
        else
          rate_cntr <= rate_cntr - 1;
        end if;
      end if;
    end if;
  end process;


  p_n_counter:
  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_i = '1' then
        n <= (others => '0');
      elsif en_i = '1' then
        if rate_cntr = 0 then
          n <= n + 1;
        end if;
      end if;
    end if;
  end process;


  p_sine_ff:
  process(clk_i)
  begin
    if rst_i = '1' then
      sine1 <= (others => '0');
      sine2 <= (others => '0');
      n1 <= (others => '0');
    elsif rising_edge(clk_i) then
      if en_i = '1' then
        sine1 <= sine;
        sine2 <= sine1;
        n1 <= n;
      end if;
    end if;
  end process;

  -- Waveforms
  -- FIXME: Optimisation, cosw2 = cosw shift right de 1
  sine <= n - (COSW * n1) + (2*COSW*sine1) - sine2; --FIXME: Data width and stuff

  triangle <= n when n(n'left) = '0' else not n;

  ramp <= not n;

  sawtooth <= n;

  -- Highest bit will be high or low half the time
  square <= (others => n(n'left));


  -- Priority encoder
  p_waveform_shape:
  wave_shape <= WAVE_SINE      when unsigned(wave_i) < 1*WAVE_SHAPE_DELTA else
                WAVE_TRIANGLE  when unsigned(wave_i) < 2*WAVE_SHAPE_DELTA else
                WAVE_RAMP      when unsigned(wave_i) < 3*WAVE_SHAPE_DELTA else
                WAVE_SAWTOOTH  when unsigned(wave_i) < 4*WAVE_SHAPE_DELTA else
                WAVE_SQUARE;


  with wave_shape select
    waveform <= sine      when WAVE_SINE,
                triangle  when WAVE_TRIANGLE,
                ramp      when WAVE_RAMP,
                sawtooth  when WAVE_SAWTOOTH,
                square    when WAVE_SQUARE,
                (others => '1') when others;


  wave <= waveform when rising_edge(clk_i) and en_i = '1';


  -- FIXME: Equation plus bonne
  p_tremolo_mod:
  tremolo_mod <= signed(unsigned(signed(data_i) * wave) * unsigned(depth_i));

  p_tremolo_add:
  tremolo_add <= signed(data_i) + tremolo_mod;

  p_tremolo_out:
  data_o <= std_logic_vector(unsigned(tremolo_add) / unsigned(depth_i));

end architecture;
