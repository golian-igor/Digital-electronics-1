# Exercises-1

### Links
[EDA](https://www.edaplayground.com/x/nYzc/)

**Source code:**

```vhdl
f_o     <= (not b_i and a_i) or (not c_i and not b_i);
f_nand_o <= not (not (not b_i and a_i) and not(not b_i and not c_i)); 
f_nor_o    <= not (b_i or not a_i) or not (c_i or b_i);
```
