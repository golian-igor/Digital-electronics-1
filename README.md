# Digital-electronics-1

## ***My Labs***

### Emphasis

### Links
[GitHub Pages](https://pages.github.com/)

[GitHub Manuals](https://medium.com/swlh/how-to-make-the-perfect-readme-md-on-github-92ed5771c061)

### Images
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

### Table
| **a** | **b** |**c** |
| :-: | :-: | :-: |
| 1 | 0 | 0 |
| 0 | 1 | 0 |
| 0 | 0 | 1 | 
### VHDL Source code:

```vhdl
f_o     <= (not b_i and a_i) or (not c_i and not b_i);
f_nand_o <= not (not (not b_i and a_i) and not(not b_i and not c_i)); 
f_nor_o    <= not (b_i or not a_i) or not (c_i or b_i);
```
