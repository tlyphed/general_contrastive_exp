import clingo
from clingo.control import Control
import re

ENC_PATH = "enc.lp"

def __parse_cnf(str):
    cnf = []
    for str_cl in str.split("&"):
        cl = []
        for str_lit in str_cl.split("|"):
            s = str_lit.strip()
            if s.startswith('-'):
                cl.append((s[1:],False))
            else:
                cl.append((s,True))
        cnf.append(cl)
    
    return cnf

def __cnf_to_facts(fact_cnf,foil_cnf):
    facts = []
    i = 1
    for cl in fact_cnf:
        facts.append(f"fact_cl({i}).")
        for l,t in cl:
            sign = "t" if t else "f"
            facts.append(f"lit({i},{l},{sign}).")
        i += 1
    for cl in foil_cnf:
        facts.append(f"foil_cl({i}).")
        for l,t in cl:
            sign = "t" if t else "f"
            facts.append(f"lit({i},{l},{sign}).")
        i += 1
        
    return facts


def __cnf_to_str(cnf):
    cl_str = []
    for cl in cnf:
        parse_lit = lambda l,s: l if s else f"-{l}" 
        cl_str.append(" | ".join([ parse_lit(l,s) for l,s in cl ]))
    
    return "  &  ".join(cl_str)


def __parse_answer_set(answer_set):
    theta = {}
    theta_p = {}
    chi = {}
    for sym in answer_set.symbols(shown=True):
        if sym.match('theta_lit',3):
            c = sym.arguments[0].number
            l = str(sym.arguments[1])
            s = str(sym.arguments[2])

            if c not in theta:
                theta[c] = []
            theta[c].append((l,s == "t"))
        elif sym.match('theta\'_lit',3):
            c = sym.arguments[0].number
            l = str(sym.arguments[1])
            s = str(sym.arguments[2])

            if c not in theta_p:
                theta_p[c] = []
            theta_p[c].append((l,s == "t"))
        elif sym.match('chi_lit',3):
            c = sym.arguments[0].number
            l = str(sym.arguments[1])
            s = str(sym.arguments[2])

            if c not in chi:
                chi[c] = []
            chi[c].append((l,s == "t"))
    
    return (list(theta.values()), list(theta_p.values()), list(chi.values()))


def __clingo_solve(encoding):
    ctl = Control(['-Wnone'])
    ctl.add(encoding)
    ctl.ground([("base", [])])
    answer_set = None
    def on_model(model):
        nonlocal answer_set
        answer_set = __parse_answer_set(model)
    ctl.solve(on_model=on_model)

    return answer_set

def main():
    fact_str = input("Fact Formula:\n")
    foil_str = input("Foil Formula:\n")

    fact = __parse_cnf(fact_str)
    foil = __parse_cnf(foil_str)

    print()

    encoding = "".join(__cnf_to_facts(fact,foil))
    with open(ENC_PATH, "r") as f:
        encoding += f.read()
    
    theta, theta_p, chi = __clingo_solve(encoding)
    print("Theta:")
    print(__cnf_to_str(theta))
    print("Theta':")
    print(__cnf_to_str(theta_p))
    print("Chi':")
    print(__cnf_to_str(chi))



if __name__ == '__main__':
    main()