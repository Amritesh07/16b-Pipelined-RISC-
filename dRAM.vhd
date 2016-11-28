library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use work.components.all;

entity dRAM is
  port (
    clock   : in  std_logic;
    mem_ctr : in std_logic_vector(7 downto 0);
    Din_mem: in matrix16(7 downto 0);
    Dout_mem: out matrix16(7 downto 0);
    Addr_mem: in matrix16(7 downto 0);
    pathway: in std_logic;
    writeEN: in std_logic;
    load_mem: in std_logic;
    mem_loaded: out std_logic;
    ai_mem: in std_logic_vector(15 downto 0);
    di_mem: in std_logic_vector(15 downto 0);
    do_mem: out std_logic_vector(15 downto 0)
  );
end entity dRAM;

architecture dRTL of dRAM is

   type ram_type is array (0 to 511) of std_logic_vector(15 downto 0);
type hram_type is array (0 to 26) of std_logic_vector(15 downto 0);

   signal ram : ram_type;
   signal read_address : std_logic_vector(0 to 15);
   signal masking_vec : std_logic_vector(15 downto 0) := "0000000111111111";
   signal r_address,r0_address,r1_address,r2_address,r3_address,r4_address,r5_address,r6_address,r7_address:std_logic_vector(15 downto 0):="0000000000000000";
function CONV_INTEGER(x: std_logic_vector) return integer is
      variable ret_val: integer:=0;
      alias lx : std_logic_vector (x'length-1 downto 0) is x;
	variable pow: integer:=1;
  begin
	for I in 0 to x'length-1 loop
		if (lx(I) = '1') then
      			ret_val := ret_val + pow;
		end if;
		pow:=pow*2;
	end loop;
      return(ret_val);
  end CONV_INTEGER;
  signal ram_data: std_logic_vector(15 downto 0);
  signal wr_flag:std_logic:='1';
 signal in_array: hram_type:= (
"0011001000000010", --0
"0011010000000010", --1
"0011101000000010", --2
"0011011000000010", --3
"0100000010000001", --4
"0000000000100000", --5
"0100100101000010", --6
"0100000010000011", --7
"0000100100110001", --8
"0000001000011001", --9
"0000001000010010", --10
"0101000011000010", --11
"0100010011000010", --12
"0101011010000001", --13
"0110000000111111", --14
"0001111000011001", --15
"0001111111011001", --16
"0100100110000000", --17
"0010011110100001", --18
"0010101110001000", --19
"0000000000000000",--256,20
"0000000000000010",--257,21
"0000000000000110",--258,22
"0000000100000000",--259,23
"0000000000000101",--260,24
"0000000000000110",--261,25
"0000000100000000"--262 ,26
);

begin

	r_address <= ai_mem and masking_vec;
  r0_address <= Addr_mem(0) and masking_vec;
  r1_address <= Addr_mem(1) and masking_vec;
  r2_address <= Addr_mem(2) and masking_vec;
  r3_address <= Addr_mem(3) and masking_vec;
  r4_address <= Addr_mem(4) and masking_vec;
  r5_address <= Addr_mem(5) and masking_vec;
  r6_address <= Addr_mem(6) and masking_vec;
  r7_address <= Addr_mem(7) and masking_vec;
	do_mem <= ram(CONV_INTEGER(r_address));
  Dout_mem(0) <= ram(CONV_INTEGER(r0_address));
  Dout_mem(1) <= ram(CONV_INTEGER(r1_address));
  Dout_mem(2) <= ram(CONV_INTEGER(r2_address));
  Dout_mem(3) <= ram(CONV_INTEGER(r3_address));
  Dout_mem(4) <= ram(CONV_INTEGER(r4_address));
  Dout_mem(5) <= ram(CONV_INTEGER(r5_address));
  Dout_mem(6) <= ram(CONV_INTEGER(r6_address));
  Dout_mem(7) <= ram(CONV_INTEGER(r7_address));


  RamProc: process(clock,wr_flag) is
  variable address_in: integer:=0;
  variable address_in_r:integer:=0;
  begin
    if rising_edge(clock) then
      	if (writeEN = '1' and pathway ='0' )then
        	ram(CONV_INTEGER(ai_mem)) <= di_mem;
        end if;
        if (writeEN = '1' and mem_ctr(0) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(0))) <= Din_mem(0);
        end if;
        if (writeEN = '1' and mem_ctr(1) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(1))) <= Din_mem(1);
        end if;
        if (writeEN = '1' and mem_ctr(2) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(2))) <= Din_mem(2);
        end if;
        if (writeEN = '1' and mem_ctr(3) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(3))) <= Din_mem(3);
        end if;
        if (writeEN = '1' and mem_ctr(4) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(4))) <= Din_mem(4);
        end if;
        if (writeEN = '1' and mem_ctr(5) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(5))) <= Din_mem(5);
        end if;
        if (writeEN = '1' and mem_ctr(6) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(6))) <= Din_mem(6);
        end if;
        if (writeEN = '1' and mem_ctr(7) ='1' and pathway='1')then
            ram(CONV_INTEGER(Addr_mem(7))) <= Din_mem(7);
        end if;
  --dataout <= "0000000000000000";
	--else
	--dataout <= ram(CONV_INTEGER(address));

	     if((load_mem = '1') and (wr_flag='1')) then

  		     ram(address_in_r) <= in_array(address_in);
    		     if(address_in = 26) then
               mem_loaded <='1';
               wr_flag<='0';
             else
              mem_loaded<='0';
            end if;
    		      if(address_in_r=19) then
                address_in_r:=256;
    		      else
                address_in_r:= address_in_r+1;
    		      end if;
	          address_in:=address_in+1;

        end if;

end if;
  end process RamProc;



end architecture dRTL;
