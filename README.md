# Contrastive Explanations

Prototypical ASP-implementations of contrastive explanations as defined in [this work](https://arxiv.org/abs/2507.08454) for the case of propositional logic.

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
python prototype.py -p <problem definition> -n <number of explanations> -m <max num of clauses> -k <max num of literals>
```
The options for `p` are the different problems from the draft. The options are
* `GLOBAL_CE`: Global contrastive explanation problem.
* `CF_CE`: Counterfactual contrastive explanation problem.
* `CF_DIFF`: Counterfactual difference problem.
To run the simplified versions of `GF_CE` and `CF_DIFF`, set -m = 1.

The default for `n` is one and passing zero produces all explanations.

To reproduce the case studies done in the paper, just run the jupyter notebook `case_studies.ipynb`.

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