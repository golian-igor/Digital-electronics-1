# Digital-electronics-1

## ***My Labs***

### Emphasis:
*Welcome to Github* <BR>
**Welcome to Github**<BR>
~~Welcome to Github~~
  
### Lists:
1. First ordered list item
2. Another item
3. And another item.

### Links:
[GitHub Pages](https://pages.github.com/)

[GitHub Manuals](https://medium.com/swlh/how-to-make-the-perfect-readme-md-on-github-92ed5771c061)

### Images:
![alt text](https://g.denik.cz/50/08/brno-vut-vysoke-uceni-technicke_denik-320-16x9.jpg "Logo Title Text 1")

### Table:
| **a** | **b** |**c** |
| :-: | :-: | :-: |
| 1 | 0 | 0 |
| 0 | 1 | 0 |
| 0 | 0 | 1 | 
### VHDL Source code:

```vhdl
architecture dataflow of gates is
begin
f_o     <= (not b_i and a_i) or (not c_i and not b_i);
f_nand_o <= not (not (not b_i and a_i) and not(not b_i and not c_i)); 
f_nor_o    <= not (b_i or not a_i) or not (c_i or b_i);
end architecture dataflow;
```
