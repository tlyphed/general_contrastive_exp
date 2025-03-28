truth_val(t;f).
#const n_clauses = 5.
#const n_lits = 3.

atom(A) :- lit(_,A,_).

theta_cl(1..n_clauses).
theta_p_cl(1..n_clauses).
chi_cl(1..n_clauses).

% guess
{ theta_lit(C,A,T) : atom(A), truth_val(T)   } <= n_lits :- theta_cl(C).
{ theta_p_lit(C,A,T) : atom(A), truth_val(T) } <= n_lits :- theta_p_cl(C).
{ chi_lit(C,A,T) : atom(A), truth_val(T)  }    <= n_lits :- chi_cl(C).

% no contradictions
:- theta_lit(C,A,T1), theta_lit(C,A,T2), T1 != T2.
:- theta_p_lit(C,A,T1), theta_p_lit(C,A,T2), T1 != T2.
:- chi_lit(C,A,T1), chi_lit(C,A,T2), T1 != T2.

theta_cl_empty(C) :- theta_cl(C), not theta_lit(C,_,_).
theta_p_cl_empty(C) :- theta_p_cl(C), not theta_p_lit(C,_,_).
chi_cl_empty(C) :- chi_cl(C), not chi_lit(C,_,_).

:- theta_cl_empty(C1), theta_cl(C2), C2 > C1, theta_lit(C2,_,_).
:- theta_p_cl_empty(C1), theta_p_cl(C2), C2 > C1, theta_p_lit(C2,_,_).
:- chi_cl_empty(C1), chi_cl(C2), C2 > C1, chi_lit(C2,_,_).


% theta & chi entail fact & -foil

% guess countermodel
cm1(A,t) | cm1(A,f) :- atom(A).
u :- cm1(A,V1), cm1(A,V2), V1 != V2.

% cm violates theta & chi -> saturate
theta_cl_viol(C) :- theta_cl(C), not theta_cl_empty(C),
                    cm1(A,f) : theta_lit(C,A,t);
                    cm1(A,t) : theta_lit(C,A,f).
chi_cl_viol(C) :- chi_cl(C), not chi_cl_empty(C),
                  cm1(A,f) : chi_lit(C,A,t);
                  cm1(A,t) : chi_lit(C,A,f).
u :- theta_cl_viol(C).
u :- chi_cl_viol(C).

% cm satisfies fact & -foil -> saturate
fact_cl_sat(C) :- fact_cl(C), lit(C,A,V), cm1(A,V).
foil_cl_viol(C) :- foil_cl(C), cm1(A,f) : lit(C,A,t);
                               cm1(A,t) : lit(C,A,f).

fact_sat :- fact_cl_sat(C) : fact_cl(C).
foil_viol :- foil_cl_viol(C).

u :- fact_sat, foil_viol.

% saturation
cm1(A,t) :- u, atom(A).
cm1(A,f) :- u, atom(A).
:- not u.


% theta' & chi entail -fact & foil

% guess countermodel
cm2(A,t) | cm2(A,f) :- atom(A).
v :- cm2(A,V1), cm2(A,V2), V1 != V2.

% cm violates theta' & chi -> saturate
theta_p_cl_viol(C) :- theta_p_cl(C), not theta_p_cl_empty(C),
                      cm2(A,f) : theta_p_lit(C,A,t);
                      cm2(A,t) : theta_p_lit(C,A,f).
theta_p_cl_sat(C) :- theta_p_cl_empty(C).
theta_p_cl_sat(C) :- theta_p_cl(C), theta_p_lit(C,A,V), cm2(A,V).
theta_p_sat :- theta_p_cl_sat(C) : theta_p_cl(C).
chi_cl_viol2(C) :- chi_cl(C), not chi_cl_empty(C),
                   cm2(A,f) : chi_lit(C,A,t);
                   cm2(A,t) : chi_lit(C,A,f).
v :- theta_p_cl_viol(C).
v :- chi_cl_viol2(C).

% cm satisfies -fact & foil -> saturate
foil_cl_sat2(C) :- foil_cl(C), lit(C,A,V), cm2(A,V).
fact_cl_viol2(C) :- fact_cl(C), cm2(A,f) : lit(C,A,t);
                                cm2(A,t) : lit(C,A,f).

foil_sat2 :- foil_cl_sat2(C) : foil_cl(C).
fact_viol2 :- fact_cl_viol2(C).

v :- fact_viol2, foil_sat2.


% saturation
cm2(A,t) :- v, atom(A).
cm2(A,f) :- v, atom(A).
:- not v.


% instance equivalent to theta & chi

% guess countermodel
cm3(A,t) | cm3(A,f) :- atom(A).
w :- cm3(A,V1), cm3(A,V2), V1 != V2.

% check theta
theta_cl_sat3(C) :- theta_cl_empty(C).
theta_cl_sat3(C) :- theta_cl(C), theta_lit(C,A,V), cm3(A,V).
theta_cl_viol3(C) :- theta_cl(C), not theta_cl_empty(C),
                                   cm3(A,f) : theta_lit(C,A,t);
                                   cm3(A,t) : theta_lit(C,A,f).

theta_sat :- theta_cl_sat3(C) : theta_cl(C).
theta_viol :- theta_cl_viol3(C).

% check chi
chi_cl_sat3(C) :- chi_cl_empty(C).
chi_cl_sat3(C) :- chi_cl(C), chi_lit(C,A,V), cm3(A,V).
chi_cl_viol3(C) :- chi_cl(C), not chi_cl_empty(C),
                              cm3(A,f) : chi_lit(C,A,t);
                              cm3(A,t) : chi_lit(C,A,f).

chi_sat :- chi_cl_sat3(C) : chi_cl(C).
chi_viol :- chi_cl_viol3(C).

% check instance
instance_cl_sat(C) :- instance_cl(C), lit(C,A,V), cm3(A,V).
instance_cl_viol(C) :- instance_cl(C), cm3(A,f) : lit(C,A,t);
                       cm3(A,t) : lit(C,A,f).

instance_viol :- instance_cl_viol(C).
instance_sat :- instance_cl_sat(C) : instance_cl(C).

% cm violates instance -> saturate
w :- instance_viol.
% cm satisfies theta & chi -> saturate
w :- theta_sat, chi_sat.


% saturation
cm3(A,t) :- w, atom(A).
cm3(A,f) :- w, atom(A).
:- not w.


% theta' & chi is sat

{ model(A,t) ; model(A,f) } = 1 :- atom(A).
theta_p_cl_satisfiable(C) :- theta_p_cl_empty(C).
theta_p_cl_satisfiable(C) :- theta_p_cl(C), theta_p_lit(C,A,V), model(A,V).
theta_p_satisfiable :- theta_p_cl_satisfiable(C) : theta_p_cl(C).
:- not theta_p_satisfiable.

chi_cl_satisfiable(C) :- chi_cl_empty(C).
chi_cl_satisfiable(C) :- chi_cl(C), chi_lit(C,A,V), model(A,V).
chi_satisfiable :- chi_cl_satisfiable(C) : chi_cl(C).
:- not chi_satisfiable.


% size
:~ theta_lit(C,A,V). [1@2,C,A,theta]
:~ theta_p_lit(C,A,V). [1@2,C,A,theta_p]
:~ chi_lit(C,A,V). [1@2,C,A,chi]

:~ chi_lit(C,A,V). [-1@1,C,A,chi_max]


#show theta_lit/3.
#show theta_p_lit/3.
#show chi_lit/3.

