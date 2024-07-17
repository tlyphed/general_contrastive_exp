# General Contrastive Explanation

Prototypical implementations of general contrastive explanations.

The python tool uses the current formulation and accepts CNF input (`&` for conjunction and `|` for disjunction) of the form:
```
p1 | ... | -pk & ... &  pm | ... | -pn
```

It requires the `click` and `clingo` modules, which can be installed using `pip`:
```
pip install click clingo
```

The script can then be run with
```
python prototype.py -n <number of explanations>
```
The default for `n` is one and passing zero produces all explanations.

Example usage:
```
python prototype.py -n 1                                                                                        
Fact Formula:
-p2&p4
Foil Formula:
p3&p4

SOLUTION (cost [6, -1]):
Theta:
-p2  &  -p3
Theta':
p2  &  p3
Chi':
p4
```

