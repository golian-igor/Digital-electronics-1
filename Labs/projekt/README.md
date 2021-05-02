# Projekt - Parkovací asistent

![Image](images/auto.png) 

## Členové týmu:
| **Jméno(ID)** | **GitHub** |
| :-: | :-: |
| Gmitter Jakub (220814)  | [Link](https://github.com/xgmitt00/Digital-electronics-1/tree/main/Labs) |
| Golian Igor (223288)    | [Link](https://github.com/golian-igor/Digital-electronics-1/tree/main/Labs/projekt) |
| Grenčík Dominik (220815)| [Link](https://github.com/DomikGrencik/Digital-electronics-1/tree/main/Labs) |
| Hála David (220889)     | [Link](https://github.com/DavidHala123/Digital-electronics-1/tree/main/Labs) |

## Zadání projektu:
Parkovací asistent s ultrazvukovým senzorem HC-SR04, zvuková signalizace pomocí PWM, signalizace pomocí LED bargrafu

## Cíl projektu:
Cílem projektu je vytvořit program  parkovací asistent, který bude napsaný v jazyce VHDL na desce A7-100T. Nejdůležitější částí programu tvoří ultrazvukový senzor HC-SR04, který zajišťuje vzdálenost od jednotlivých překážek. Senzor je doplněn LED bargrafem, který se bude postupně rozsvicovat podle dané vzdálenosti od překážek. Program také obsahuje zvukovou signalizaci pomocí bzučáku, který má za úkol upozornit na blížící se předmět. 

## Popis Hardwaru:
### Deska A7-100T
Deska je kompletní platforma pro vývoj digitálních obvodů. Založená na nejnovějším poli FPGA od společnosti Artix-7 ™. Díky velkému vysokokapacitnímu FPGA, velkorysým externím pamětím, kolekci USB, Ethernetu a dalších portů může Nexys A7 hostit designy od úvodních kombinačních obvodů až po výkonné vestavěné procesory.

#### Popis Desky:
![Image](images/deska.png)

![Image](images/popis.png)
  
### Senzor HC-SR04
Ultrazvukový senzor, který slouží především jako detektor překážek. Měřící vzdálenost je v rozsahu od 2cm do 4m. Obsahuje 4 pinový konektor se standartní roztečí 2,54mm. Piny: VCC, GND, TRIG, ECHO. Princip funkce senzoru: Nejprve vyšle 10us puls na pin Trigger, který následně vyšle 8 zvukových impulzů o frekvecni 40kHz. Poté co se vyslaný signál odrazí od překážky, vrátí se zpět na pin Echo. Pokud se překážka nachází nad 4m a signál se nevrátí do 38ms, pin Echo se nastaví automaticky na low.

#### Princip:
![Image](images/senzor.png)

### Bzučák
Pro zvukovou signalizaci pomocí PWM jsme zvolili jednoduchý piezo bzučák s napájecím napětím 3V - 5V.
![Image](images/buzzer.png) 

### LED bargraf
Pro signalizaci jsme zvolili 8 segmentový LED bargraf.
![Image](images/led.png) 

## Popis a simulace modulů VHDL:
### top
```vhdl
entity top is
  Port ( 
           CLK100MHZ : in STD_LOGIC;
          
           ja : in STD_LOGIC_VECTOR;     -- sensor in
           jb : out STD_LOGIC_VECTOR (8-1 downto 0);    -- ledbar
           jc : out STD_LOGIC_VECTOR (2-1 downto 0)    -- sensor out, buzzer           
  );
end top;

architecture Behavioral of top is

signal s_outputdistance : real := 0.0;
signal s_clk : std_logic;

begin

uut_sensor : entity work.sensor
        port map(
            clk_i     => CLK100MHZ,
            trig_o => jc(0),
            echo_i => ja(0),           
            outputdistace_o => s_outputdistance            
        );
        
uut_led_bar : entity work.led_bar
        port map(
            outputdistance_i => s_outputdistance,
            led_bar_o(0) => jb(0),
            led_bar_o(1) => jb(1),
            led_bar_o(2) => jb(2),
            led_bar_o(3) => jb(3),
            led_bar_o(4) => jb(4),
            led_bar_o(5) => jb(5),
            led_bar_o(6) => jb(6),
            led_bar_o(7) => jb(7)            
        );
        
uut_clock_buzzer : entity work.clock_buzzer
        port map(
            clk_i      => CLK100MHZ,                  
            clk_buzz_o    => s_clk      
        );            
        
uut_buzzer : entity work.buzzer
        port map(
            outputdistance_i => s_outputdistance,                                   
            buzzer_o => jc(1),
            clk_buzz_i => s_clk             
        );
                

end Behavioral;
```

### sensor
```vhdl
entity sensor is
    Port ( 
           trig_o : out STD_LOGIC;          --signal that will trigger the sensor
           echo_i : in STD_LOGIC;           --signal from the sensor
           clk_i  : in std_LOGIC;           --clock
           outputdistace_o : out real       --real value of distance
                 
           );
end sensor;

architecture Behavioral of sensor is

type   t_state_echo is (WAIT_TRIG, SEND_TRIG);      --state machine
signal s_state_echo  : t_state_echo;                --signal of state machine


signal   s_cnt  : unsigned(24 - 1 downto 0):= b"0000_0000_0000_0000_0000_0000";         --counter for state machine
constant c_DELAY_60ms : unsigned(24 - 1 downto 0) := b"0101_1011_1000_1101_1000_0000";  --constant 60ms
constant c_DELAY_10us : unsigned(24 - 1 downto 0) := b"0000_0000_0000_0011_1110_1000";  --constant 10us
constant c_ZERO       : unsigned(24 - 1 downto 0) := b"0000_0000_0000_0000_0000_0000";  --constant zero

signal s_trig : std_logic;              --signal of trig_o
signal s_count : integer := 0;          --counter of echo signal width
signal s_outputdistance : real := 0.0;  --signal of outputdistace_o

begin

p_send_trig : process (clk_i)
begin

if rising_edge (clk_i) then
    
    case (s_state_echo) is
                    when WAIT_TRIG =>
                        
                        if (s_cnt < c_DELAY_60ms) then
                            s_cnt <= s_cnt + 1;
                            trig_o <= '0';
                        else
                            s_state_echo <= SEND_TRIG;
                            s_cnt <= c_ZERO;
                        end if;    
                        
                    when SEND_TRIG => 
                    
                        if (s_cnt < c_DELAY_10us) then
                            s_cnt <= s_cnt + 1;
                            trig_o <= '1';
                        else
                            s_cnt <= c_ZERO;                            
                            s_state_echo <= WAIT_TRIG;
                        end if; 
    end case; 
end if;

end process p_send_trig;

p_get_echo : process (clk_i, echo_i)
begin

if echo_i = '1' then
    if rising_edge (clk_i) then    
        s_count <= s_count +1;
    end if;
end if;

if rising_edge (echo_i) then
    s_count <= 0;
end if;

if echo_i = '0' then
    s_outputdistance <= Real(s_count)*0.0001*0.017241379310344827;
end if;

end process p_get_echo;

outputdistace_o <= s_outputdistance;
trig_o <= s_trig;

end Behavioral;
```

### tb_sensor
```vhdl
entity tb_sensor is
--  Port ( );
end tb_sensor;

architecture Behavioral of tb_sensor is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    constant c_60ms : time := 60 ms;
    constant c_10us : time := 10 us;    

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_echo : std_logic;    
    signal s_time : time := 23200us;    
    
begin

    uut_sensor : entity work.sensor
        port map(
            clk_i   => s_clk_100MHz,
            echo_i  => s_echo                                          
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 660 ms loop   -- 4 sec of simulation
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
          
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
    s_echo <= '0';
    wait for c_60ms;
    while now < 660 ms loop   -- 4 sec of simulation
            s_echo <= '0';
            wait for c_10us;
            s_echo <= '1';
            wait for s_time;            
            s_echo <= '0';
            wait for c_60ms - s_time;
            s_time <= s_time - 2400 us;
        end loop;
        wait;

    end process p_stimulus;

end Behavioral;
```

### tb_senzor simulace
![Image](images/tb.senzor.png)

### led_bar
```vhdl
entity led_bar is
Port ( 
           outputdistance_i : in real;                          --real value of distance
           led_bar_o : out std_logic_vector(8 - 1 downto 0)     --BUS for led bar                 
                 
           );
end led_bar;

architecture Behavioral of led_bar is

signal s_led_bar : std_logic_vector(8 - 1 downto 0);            --signal of led_bar_o

begin

set_led_bar : process(outputdistance_i)
begin

if (outputdistance_i < 4.0 AND outputdistance_i >= 3.5) then
    s_led_bar <= "00000001";
elsif (outputdistance_i < 3.5 AND outputdistance_i >= 3.0) then
    s_led_bar <= "00000011";
elsif (outputdistance_i < 3.0 AND outputdistance_i >= 2.5) then
    s_led_bar <= "00000111";
elsif (outputdistance_i < 2.5 AND outputdistance_i >= 2.0) then
    s_led_bar <= "00001111";
elsif (outputdistance_i < 2.0 AND outputdistance_i >= 1.5) then
    s_led_bar <= "00011111";
elsif (outputdistance_i < 1.5 AND outputdistance_i >= 1.0) then
    s_led_bar <= "00111111";
elsif (outputdistance_i < 1.0 AND outputdistance_i >= 0.5) then
    s_led_bar <= "01111111";
elsif (outputdistance_i < 0.5 AND outputdistance_i > 0.0) then
    s_led_bar <= "11111111";
else 
s_led_bar <= "00000000";
end if;

end process set_led_bar;

led_bar_o <= s_led_bar;


end Behavioral;
```

### tb_led_bar
```vhdl
entity tb_led_bar is
--  Port ( );
end tb_led_bar;

architecture Behavioral of tb_led_bar is

    signal s_outputdistance : real;

begin

uut_led_bar : entity work.led_bar
        port map(
            outputdistance_i   => s_outputdistance                                          
        );
        
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        s_outputdistance <= 4.0;
        wait for 200ms;
        s_outputdistance <= 3.75;
        wait for 200ms;
        s_outputdistance <= 3.5;
        wait for 200ms;
        s_outputdistance <= 3.25;
        wait for 200ms;
        s_outputdistance <= 3.0;
        wait for 200ms;
        s_outputdistance <= 2.75;
        wait for 200ms;
        s_outputdistance <= 2.5;
        wait for 200ms;
        s_outputdistance <= 2.25;
        wait for 200ms;
        s_outputdistance <= 2.0;
        wait for 200ms;
        s_outputdistance <= 1.75;
        wait for 200ms;
        s_outputdistance <= 1.5;
        wait for 200ms;
        s_outputdistance <= 1.25;
        wait for 200ms;
        s_outputdistance <= 1.0;
        wait for 200ms;
        s_outputdistance <= 0.75;
        wait for 200ms;
        s_outputdistance <= 0.5;
        wait for 200ms;
        s_outputdistance <= 0.25;
   
        
        wait;

    end process p_stimulus;
   

end Behavioral;
```

### tb_led_bar
![Image](images/tb.ledbar.png)

### clock_buzzer
```vhdl
entity clock_buzzer is
port(
        clk_i      : in  std_logic;     --original clock input     
        clk_buzz_o   : out std_logic    --transformed clock output
    );
end clock_buzzer;

architecture Behavioral of clock_buzzer is

signal s_cnt : unsigned(16 - 1 downto 0):= b"0000_0000_0000_0000";      --counter
signal s_clk : std_logic := '0';                                        --signal of clk_buzz_o
    
constant c_freq : unsigned(16 - 1 downto 0):= b"1100_1101_0001_0100";   --constant (52500)

begin

p_clock_buzzer : process(clk_i)
    begin
    
    if s_cnt = c_freq then
        s_clk <= not(s_clk);
        s_cnt <= (others => '0');
    end if;
    
    if rising_edge(clk_i) then        
        s_cnt <= s_cnt + 1;       
    end if;
    
end process p_clock_buzzer;
    
    clk_buzz_o <= s_clk;

end Behavioral;
```

### tb_clock_buzzer
```vhdl
entity tb_clock_buzzer is
--  Port ( );
end tb_clock_buzzer;

architecture Behavioral of tb_clock_buzzer is

constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
   
signal s_clk_100MHz : std_logic;

begin

    uut_clock_buzzer : entity work.clock_buzzer
        port map(
            clk_i      => s_clk_100MHz            
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 4000 ms loop         -- 4 sec of simulation
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
   
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        
        wait;
    end process p_stimulus;
    

end Behavioral;
```

### tb_clock_buzzer simulace
![Image](images/tb.clockbuzzer.png)

### buzzer
```vhdl
entity buzzer is
Port ( 
           outputdistance_i : in real;          --real value of distance              
           clk_buzz_i : in std_LOGIC := '0';    --transformed clock input
           buzzer_o : out std_logic             --buzzer output
                 
           );
end buzzer;

architecture Behavioral of buzzer is

signal s_buzzer : std_logic := '0';             --signal of buzzer output
signal s_buzzer_freq : time := 0ms;             --time variable for buzzer frquency

begin

buzzer : process (clk_buzz_i)
begin

if rising_edge(clk_buzz_i) then
    if(s_buzzer_freq /= 0us) then
        s_buzzer <= '0';
        s_buzzer <= '1' after s_buzzer_freq;
    end if;
end if;

end process buzzer;

buzzer_freq : process(outputdistance_i)
begin

if (outputdistance_i < 4.0 AND outputdistance_i > 3.5) then
    s_buzzer_freq <= 1050us;
elsif (outputdistance_i < 3.5 AND outputdistance_i > 3.0) then
    s_buzzer_freq <= 900us;
elsif (outputdistance_i < 3.0 AND outputdistance_i > 2.5) then
    s_buzzer_freq <= 750us;
elsif (outputdistance_i < 2.5 AND outputdistance_i > 2.0) then
    s_buzzer_freq <= 600us;
elsif (outputdistance_i < 2.0 AND outputdistance_i > 1.5) then
    s_buzzer_freq <= 450us;
elsif (outputdistance_i < 1.5 AND outputdistance_i > 1.0) then
    s_buzzer_freq <= 300us;
elsif (outputdistance_i < 1.0 AND outputdistance_i > 0.5) then
    s_buzzer_freq <= 150us;
elsif (outputdistance_i < 0.5 AND outputdistance_i > 0.0) then
    s_buzzer_freq <= 0us;
end if;

end process buzzer_freq;

buzzer_o <= s_buzzer;

end Behavioral;
```

### tb_buzzer
```vhdl
entity tb_buzzer is
--  Port ( );
end tb_buzzer;

architecture Behavioral of tb_buzzer is

    constant c_buzz_freq : time := 525 us;
    signal s_outputdistance : real;
    signal s_clk_buzz : std_logic;

begin

    uut_buzzer : entity work.buzzer
        port map(
            outputdistance_i   => s_outputdistance,
            clk_buzz_i   => s_clk_buzz
        );
        
    p_clkbuzz : process
    begin
        while now < 4000 ms loop   -- 4 sec of simulation
            s_clk_buzz <= '0';
            wait for c_buzz_freq;
            s_clk_buzz <= '1';
            wait for c_buzz_freq;
        end loop;
        wait;
    end process p_clkbuzz;
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        s_outputdistance <= 4.0;
        wait for 200ms;
        s_outputdistance <= 3.75;
        wait for 200ms;
        s_outputdistance <= 3.5;
        wait for 200ms;
        s_outputdistance <= 3.25;
        wait for 200ms;
        s_outputdistance <= 3.0;
        wait for 200ms;
        s_outputdistance <= 2.75;
        wait for 200ms;
        s_outputdistance <= 2.5;
        wait for 200ms;
        s_outputdistance <= 2.25;
        wait for 200ms;
        s_outputdistance <= 2.0;
        wait for 200ms;
        s_outputdistance <= 1.75;
        wait for 200ms;
        s_outputdistance <= 1.5;
        wait for 200ms;
        s_outputdistance <= 1.25;
        wait for 200ms;
        s_outputdistance <= 1.0;
        wait for 200ms;
        s_outputdistance <= 0.75;
        wait for 200ms;
        s_outputdistance <= 0.5;
        wait for 200ms;
        s_outputdistance <= 0.25; 
    
        
        wait;

    end process p_stimulus;
    


end Behavioral;
```

### tb_buzzer simulace
![Image](images/tb.buzzer.png)

## Video:
[Link](https://www.youtube.com/watch?v=kZTGfLYYYpE)

## Použité zdroje:
1) Deska - [A7-100T](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual)
2) Ultrazvukový senzor - [HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf)

