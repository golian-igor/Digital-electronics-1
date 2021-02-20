# 02-logic

## 1)Truth bable

| **Dec. equivalent** | **B[1:0]** | **A[1:0]** | **B is greater than A** | **B equals A** | **B is less than A** |
| :-: | :-: | :-: | :-: | :-: | :-: |
| 0  | 0 0 | 0 0 | 0 | 1 | 0 |
| 1  | 0 0 | 0 1 | 0 | 0 | 1 |
| 2  | 0 0 | 1 0 | 0 | 0 | 1 |
| 3  | 0 0 | 1 1 | 0 | 0 | 1 |
| 4  | 0 1 | 0 0 | 1 | 0 | 0 |
| 5  | 0 1 | 0 1 | 0 | 1 | 0 |
| 6  | 0 1 | 1 0 | 0 | 0 | 1 |
| 7  | 0 1 | 1 1 | 0 | 0 | 1 |
| 8  | 1 0 | 0 0 | 1 | 0 | 0 |
| 9  | 1 0 | 0 1 | 1 | 0 | 0 |
| 10 | 1 0 | 1 0 | 0 | 1 | 0 |
| 11 | 1 0 | 1 1 | 0 | 0 | 1 |
| 12 | 1 1 | 0 0 | 1 | 0 | 0 |
| 13 | 1 1 | 0 1 | 1 | 0 | 0 |
| 14 | 1 1 | 1 0 | 1 | 0 | 0 |
| 15 | 1 1 | 1 1 | 0 | 1 | 0 |

## 2) 2-Bit comparator

### Karnaugh maps:
![Tables](images/tabulky.png)

### Equations SoP and PoS:
![Functions](images/funkce2.png)

### EDA playground link:
https://www.edaplayground.com/x/nu76

## 3) 4-bit comparator

### VHDL architecture from design file:
```vhdl
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for 2-bit binary comparator
------------------------------------------------------------------------
entity comparator_2bit is
    port(
        a_i           : in  std_logic_vector(4 - 1 downto 0);
        b_i           : in  std_logic_vector(4 - 1 downto 0);


        -- COMPLETE THE ENTITY DECLARATION

	B_greater_A_o : out std_logic;       -- B is greater than A
        B_equals_A_o  : out std_logic;       -- B equals A
        B_less_A_o    : out std_logic        -- B is less than A
                  
    );
end entity comparator_2bit;

------------------------------------------------------------------------
-- Architecture body for 2-bit binary comparator
------------------------------------------------------------------------
architecture Behavioral of comparator_2bit is
begin
	B_greater_A_o   <= '1' when (b_i > a_i) else '0';
	B_equals_A_o    <= '1' when (b_i = a_i) else '0';
    	B_less_A_o      <= '1' when (b_i < a_i) else '0';


    -- WRITE "GREATER" AND "EQUALS" ASSIGNMENTS HERE


end architecture Behavioral;
```

### VHDL stimulus process from testbench file:
```vhdl
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_comparator_2bit is
    -- Entity of testbench is always empty
end entity tb_comparator_2bit;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_comparator_2bit is

    -- Local signals
    signal s_a       	 : std_logic_vector(4 - 1 downto 0);
    signal s_b       	 : std_logic_vector(4 - 1 downto 0);
    signal s_B_greater_A : std_logic;
    signal s_B_equals_A  : std_logic;
    signal s_B_less_A    : std_logic;

begin
    -- Connecting testbench signals with comparator_2bit entity (Unit Under Test)
    uut_comparator_2bit : entity work.comparator_2bit
        port map(
            a_i           => s_a,
            b_i           => s_b,
            B_greater_A_o => s_B_greater_A,
            B_equals_A_o  => s_B_equals_A,
            B_less_A_o    => s_B_less_A
        );

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;


        
        s_b <= "0000"; s_a <= "0000"; wait for 100 ns;       
        assert ((s_B_greater_A = '0') and (s_B_equals_A = '1') and (s_B_less_A = '0'))     
        report "Test failed for input combination: 0000, 0000" severity error;
        
        s_b <= "0000"; s_a <= "0001"; wait for 100 ns;     
        assert ((s_B_greater_A = '0') and (s_B_equals_A = '0') and (s_B_less_A = '1'))      
        report "Test failed for input combination: 0000, 0001" severity error;
        
        s_b <= "0000"; s_a <= "0010"; wait for 100 ns;      
        assert ((s_B_greater_A = '0') and (s_B_equals_A = '0') and (s_B_less_A = '1'))      
        report "Test failed for input combination: 0000, 0010" severity error;
        
        s_b <= "0000"; s_a <= "0011"; wait for 100 ns;       
        assert ((s_B_greater_A = '0') and (s_B_equals_A = '0') and (s_B_less_A = '1'))      
        report "Test failed for input combination: 0000, 0011" severity error;
        
        s_b <= "0000"; s_a <= "0100"; wait for 100 ns;
        assert ((s_B_greater_A = '0') and (s_B_equals_A = '0') and (s_B_less_A = '1'))
        report "Test failed for input combination: 0000, 0100" severity error;
        
        s_b <= "0001"; s_a <= "0000"; wait for 100 ns;
        assert ((s_B_greater_A = '1') and (s_B_equals_A = '0') and (s_B_less_A = '0'))
        report "Test failed for input combination: 0001, 0000" severity error;
        
        s_b <= "0010"; s_a <= "0000"; wait for 100 ns;
        assert ((s_B_greater_A = '1') and (s_B_equals_A = '0') and (s_B_less_A = '0'))
        report "Test failed for input combination: 0010, 0000" severity error;
        
        s_b <= "0011"; s_a <= "0000"; wait for 100 ns;
        assert ((s_B_greater_A = '1') and (s_B_equals_A = '0') and (s_B_less_A = '0'))
        report "Test failed for input combination: 0011, 0000" severity error;
        
        s_b <= "0100"; s_a <= "0000"; wait for 100 ns;
        assert ((s_B_greater_A = '1') and (s_B_equals_A = '0') and (s_B_less_A = '0'))
        report "Test failed for input combination: 0100, 0000" severity error;
        
        -----------Chyba
        s_b <= "1111"; s_a <= "1111"; wait for 100 ns;
        assert ((s_B_greater_A = '1') and (s_B_equals_A = '0') and (s_B_less_A = '0'))
        report "Test failed for input combination: 1111, 1111" severity error;
        
        
        -- WRITE OTHER TEST CASES HERE


        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture testbench;
```

### Console with one reported error:
```vhdl
[2021-02-20 18:37:12 EST] ghdl -i design.vhd testbench.vhd  && ghdl -m  tb_comparator_2bit && ghdl -r  tb_comparator_2bit   --vcd=dump.vcd && sed -i 's/^U/X/g; s/^-/X/g; s/^H/1/g; s/^L/0/g' dump.vcd 
analyze design.vhd
analyze testbench.vhd
elaborate tb_comparator_2bit
testbench.vhd:51:9:@0ms:(report note): Stimulus process started
testbench.vhd:93:9:@1us:(assertion error): Test failed for input combination: 1111, 1111
testbench.vhd:101:9:@1us:(report note): Stimulus process finished
Finding VCD file...
./dump.vcd
[2021-02-20 18:37:13 EST] Opening EPWave...
Done
```

### EDA playground link:
https://www.edaplayground.com/x/dB69