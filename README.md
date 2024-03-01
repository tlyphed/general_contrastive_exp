# General Contrastive Explanation

Prototypical implementations of general contrastive explanations.

The direct formulation is encoded in [direct_formulation/saturation_enc.lp](direct_formulation/saturation_enc.lp). Where the input formulas $\varphi,\psi$ have to be given in CNF.

**Input Facts:**
* `s/2`: The total interpretation, where the first term is the atom and the second `t` (true) or `f` (false)
* `fact_cl/1`: Specifies a fact clause, i.e., one in $\varphi$
* `foil_cl/1`: Specifies a foil clause, i.e., one in $\psi$
* `lit/3`: A literal contained in a clause, given as a tuple (clause, atom, sign), where sign is `t` (true) or `f` (false)

**Output Atoms:**
* `s'/2`: Atom and truth value
* `s''/2`: Atom and truth value

The toy example from the draft can be run with:
```
clingo direct_formulation/saturation_enc.lp direct_formulation/toy.lp
````

The optimal answer set is then:
```
s'(p2,t) s''(p2,f) s''(p4,t)
```

This can read as $s'=p_2$ and $s''=\neg p_2 \land p_4$.

Another very simple example is given in [direct_formulation/crow.lp](direct_formulation/crow.lp), where $\varphi=\mathit{feathers} \land \mathit{birdShape} \land \mathit{beak} \land \mathit{blackWings}$ and $\psi=\mathit{feathers} \land \mathit{birdShape} \land \mathit{beak} \land \mathit{whiteWings}$.
Intuitively, $\varphi$ encodes a crow and $\psi$ a magpie. $s$ here is simply equal to $\varphi$.

The optimal answer set is then:
```
s'(blackWings,t) s''(whiteWings,t)
```
Standing for $s'=\mathit{blackWings}$ and $s''=\mathit{whiteWings}$.