# 08-traffic_lights
### 1)Preparation tasks

#### Completed table:
| **Input P** | `0` | `0` | `1` | `1` | `0` | `1` | `0` | `1` | `1` | `1` | `1` | `0` | `0` | `1` | `1` | `1` |
| :-- | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **Clock** | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) | ![rising](images/sipka.png) |
| **State** | A | A | B | C | C | D | A | B | C | D | D | A | A | B | C | D |
| **Output R** | `0` | `0` | `0` | `0` | `0` | `1` | `0` | `0` | `0` | `1` | `1` | `0` | `0` | `0` | `0` | `1` |

#### Figure with connection of RGB LEDs:
![Image](images/funkce.png)
	
| **RGB LED** | **Artix-7 pin names** | **Red** | **Yellow** | **Green** |
| :-: | :-: | :-: | :-: | :-: |
| LD16 | N15, M16, R12 | `1,0,0` | `1,1,0` | `0,1,0` |
| LD17 | N16, R11, G14 | `1,0,0` | `1,1,0` | `0,1,0` |

### 2)Traffic light controller

#### State diagram:
![State diagram](images/diagram.png)

#### Listing of VHDL code of sequential process:
```vhdl
p_traffic_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then       -- Synchronous reset
                s_state <= STOP1 ;      -- Set initial state
                s_cnt   <= c_ZERO;      -- Clear all bits

            elsif (s_en = '1') then
                -- Every 250 ms, CASE checks the value of the s_state 
                -- variable and changes to the next state according 
                -- to the delay value.
                case s_state is

                    -- If the current state is STOP1, then wait 1 sec
                    -- and move to the next GO_WAIT state.
                    when STOP1 =>
                        -- Count up to c_DELAY_1SEC
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= WEST_GO;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;

                    when WEST_GO =>
                        -- Count up to c_DELAY_4SEC
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= WEST_WAIT;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                        
                    when WEST_WAIT =>
                        -- Count up to c_DELAY_2SEC
                        if (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= STOP2;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                        
                    when STOP2 =>
                        -- Count up to c_DELAY_1SEC
                        if (s_cnt < c_DELAY_1SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= SOUTH_GO;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                        
                    when SOUTH_GO =>
                        -- Count up to c_DELAY_4SEC
                        if (s_cnt < c_DELAY_4SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= SOUTH_WAIT;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;
                        
                    when SOUTH_WAIT =>
                        -- Count up to c_DELAY_4SEC
                        if (s_cnt < c_DELAY_2SEC) then
                            s_cnt <= s_cnt + 1;
                        else
                            -- Move to the next state
                            s_state <= STOP1;
                            -- Reset local counter value
                            s_cnt   <= c_ZERO;
                        end if;


                    -- It is a good programming practice to use the 
                    -- OTHERS clause, even if all CASE choices have 
                    -- been made. 
                    when others =>
                        s_state <= STOP1;

                end case;
            end if; -- Synchronous reset
        end if; -- Rising edge
    end process p_traffic_fsm;
```

#### Listing of VHDL code of combinatorial process:
```vhdl
p_output_fsm : process(s_state)
    begin
        case s_state is
            when STOP1 =>
                south_o <= "100";   --Red (RGB = 100)
                west_o  <= "100";   --Red (RGB = 100)
                
            when WEST_GO =>
                south_o <= "100";   --Red   (RGB = 100)
                west_o  <= "010";   --Green (RGB = 010)
                
            when WEST_WAIT =>
                south_o <= "100";   --Red    (RGB = 100)
                west_o  <= "110";   --Yellow (RGB = 110)
                
            when STOP2 =>
                south_o <= "100";   --Red (RGB = 100)
                west_o  <= "100";   --Red (RGB = 100)      
                
            when SOUTH_GO =>
                south_o <= "010";   --Green (RGB = 010)
                west_o  <= "100";   --Red   (RGB = 100)  
                
            when SOUTH_WAIT =>
                south_o <= "110";   --Yellow (RGB = 110)
                west_o  <= "100";   --Red    (RGB = 100) 

            when others =>
                south_o <= "100";   --Red
                west_o  <= "100";   --Red
        end case;
    end process p_output_fsm;
```

#### Screenshot waveforms:
![Time waveforms](images/prubeh1.png)

### 3)Smart controller

#### State table:
| **State** | **Out** | **No Cars** | **West Cars** | **South Cars** | **Both Cars** |
| :-- | :-: | :-: | :-: | :-: | :-: |
| `STOP`       | 100/100 | S_GO   | W_GO  | S_GO   | W_GO   |
| `SOUTH_GO`   | 010/100 | S_GP   | S_WAIT| S_GO   | S_WAIT |
| `SOUTGH_WAIT`| 110/100 | W_GO   | W_GO  | STOP   | STOP   |
| `WEST_GO`    | 100/010 | W_WAIT | W_GO  | W_WAIT | W_WAIT |
| `WEST_WAIT`  | 100/110 | S:GO   | STOP  | S_GO   | S_GO   |

#### State diagram:
![State diagram](images/diagram2.png)

####Listing of VHDL code of sequential process:
```vhdl
 p_smart_traffic_fsm : process(clk)
    begin
    if rising_edge(clk) then
        if (reset = '1') then       
            s_state <= STOP ;       
            s_cnt   <= c_ZERO;
                  
            elsif (s_en = '1') then
            
                if ( south_sensor = '0' and west_sensor = '0') then
                 case s_state is
                     when STOP =>
                          s_state <= SOUTH_GO;
                     when SOUTH_GO =>
                          s_state <= SOUTH_GO;
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_GO =>
                          s_state <= WEST_GO; 
                     when WEST_WAIT =>
                      
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                          
                elsif ( south_sensor = '1' and west_sensor = '0') then
                  case s_state is
                    when STOP =>
                        s_state <= SOUTH_GO;
                  
                    when SOUTH_GO =>          
                          s_state <= SOUTH_GO;
                          
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_GO =>
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                     
                elsif ( south_sensor = '0' and west_sensor = '1') then
                 case s_state is
                    when STOP =>
                        s_state <= WEST_GO;
                  
                    when WEST_GO =>          
                          s_state <= WEST_GO;
                          
                     when SOUTH_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;
                     when SOUTH_GO =>
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= SOUTH_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT =>
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;     
                     end case;
                     
                elsif ( south_sensor = '1' and west_sensor = '1') then
                 case s_state is 
                    when STOP =>                     
                     if( s_cnt < c_DELAY_2SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_GO;
                          s_cnt <= c_ZERO;  
                     end if;   
                     when WEST_GO => 
                      
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= WEST_WAIT;
                          s_cnt <= c_ZERO;  
                     end if;
                     when WEST_WAIT => 
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= SOUTH_GO;
                          s_cnt <= c_ZERO;  
                     end if;   
                     when SOUTH_GO => 
                       
                     if( s_cnt < c_DELAY_3SEC) then
                          s_cnt <= s_cnt + 1;
                     else
                          s_state <= SOUTH_WAIT;
                          s_cnt <= c_ZERO;  
                     end if; 
                     when SOUTH_WAIT => 
                       
                     if( s_cnt < c_DELAY_05SEC) then
                          s_cnt <= s_cnt + 1/2;
                     else
                          s_state <= STOP;
                          s_cnt <= c_ZERO;  
                     end if;  
                     end case;      
            end if;
        end if; 
    end if; 
    end process p_smart_traffic_fsm;
```
