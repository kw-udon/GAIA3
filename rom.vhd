library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.types.all;
use work.data.all;

entity rom is

  port (
    clk     : in  std_logic;
    rom_in  : in  rom_in_type;
    rom_out : out rom_out_type);

end entity;

architecture behavioral of rom is

  constant rom : rom_type := bootloader_prog;

  signal addr_reg : std_logic_vector(31 downto 0) := (others => '0');
  signal addr_reg2 : std_logic_vector(31 downto 0) := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      addr_reg  <= rom_in.addr;
      addr_reg2 <= rom_in.addr2;
    end if;
  end process;

  rom_out.rx  <= rom(conv_integer(addr_reg(13 downto 2)))
                  when x"80000000" <= addr_reg and addr_reg < x"80001000"
                  else (others => 'Z');
  rom_out.rx2 <= rom(conv_integer(addr_reg2(13 downto 2)))
                  when x"80000000" <= addr_reg2 and addr_reg2 < x"80001000"
                  else (others => 'Z');

end architecture;
