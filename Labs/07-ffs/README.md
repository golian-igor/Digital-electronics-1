# 07-ffs
### 1)Preparation tasks

| **clk** | **d** | **q(n)** | **q(n+1)** | **Comments** |
| :-: | :-: | :-: | :-: | :-- |
| ![rising](images/sipka.png) | 0 | 0 |  |  |
| ![rising](images/sipka.png) | 0 | 1 |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |

| **clk** | **j** | **k** | **q(n)** | **q(n+1)** | **Comments** |
| :-: | :-: | :-: | :-: | :-: | :-- |
| ![rising](images/sipka.png) | 0 | 0 | 0 | 0 | No change |
| ![rising](images/sipka.png) | 0 | 0 | 1 | 1 | No change |
| ![rising](images/sipka.png) | 0 |   |  |  |  |
| ![rising](images/sipka.png) | 0 |   |  |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |  |

| **clk** | **t** | **q(n)** | **q(n+1)** | **Comments** |
| :-: | :-: | :-: | :-: | :-- |
| ![rising](images/sipka.png) | 0 | 0 |  |  |
| ![rising](images/sipka.png) | 0 | 1 |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |
| ![rising](images/sipka.png) | 1 |   |  |  |


#### Characteristic equations and completed tables for D, JK, T flip-flops:

### 2)D latch

#### Listing of VHDL code of the process:
```vhdl
```

#### Listing of VHDL reset and stimulus processes from the testbench
##### Reset:
```vhdl
```

##### Stimulus processes:
```vhdl
```

#### Screenshot waveforms:
![Time waveforms](images/prubehy.png)

### 3)Flip-flops

#### Listing of VHDL code of the process:
```vhdl
```

#### Listing of VHDL clock, reset and stimulus processes from the testbench
##### Clock:
```vhdl
```

##### Reset:
```vhdl
```

##### Stimulus processes:
```vhdl
```

#### Screenshot waveforms:
![Time waveforms](images/prubehy.png)

### 4)Shift register

#### Image of the shift register schematic:
![Time waveforms](images/prubehy.png)

