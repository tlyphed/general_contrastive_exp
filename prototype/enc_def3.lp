atom(A) :- lit(_,A,_).

truth_val(t;f).

#const n_clauses = 5.
#const n_lits = 3.

theta_cl(1..n_clauses).
theta_p_cl(1..n_clauses).
chi_cl(1..n_clauses).

% guess
{ theta_lit(C,A,T) : atom(A), truth_val(T)   } <= n_lits :- theta_cl(C).
{ theta_p_lit(C,A,T) : atom(A), truth_val(T) } <= n_lits :- theta_p_cl(C).
{ chi_lit(C,A,T) : atom(A), truth_val(T)     } <= n_lits :- chi_cl(C).

% no contradictions
:- theta_lit(C,A,T1), theta_lit(C,A,T2), T1 != T2.
:- theta_p_lit(C,A,T1), theta_p_lit(C,A,T2), T1 != T2.
:- chi_lit(C,A,T1), chi_lit(C,A,T2), T1 != T2.

% no redundant literals
:- theta_lit(C1,A,T1), theta_lit(C2,A,T2), C1 != C2, T1 != T2.
:- theta_p_lit(C1,A,T1), theta_p_lit(C2,A,T2), C1 != C2, T1 != T2.
:- chi_lit(C1,A,T1), chi_lit(C2,A,T2), C1 != C2, T1 != T2.

% sym breaking
theta_cl_min_atom(C,A) :- theta_cl(C), atom(A), A = #min{ A' : theta_lit(C,A',_) }.
:- theta_cl(C1), theta_cl(C2), C1 > C2, theta_cl_min_atom(C1,A1), theta_cl_min_atom(C2,A2), A1 < A2.
theta_p_cl_min_atom(C,A) :- theta_p_cl(C), atom(A), A = #min{ A' : theta_lit(C,A',_) }.
:- theta_p_cl(C1), theta_p_cl(C2), C1 > C2, theta_p_cl_min_atom(C1,A1), theta_p_cl_min_atom(C2,A2), A1 < A2.
chi_cl_min_atom(C,A) :- chi_cl(C), atom(A), A = #min{ A' : theta_lit(C,A',_) }.
:- chi_cl(C1), chi_cl(C2), C1 > C2, chi_cl_min_atom(C1,A1), chi_cl_min_atom(C2,A2), A1 < A2.



theta_cl_empty(C) :- theta_cl(C), not theta_lit(C,_,_).
theta_p_cl_empty(C) :- theta_p_cl(C), not theta_p_lit(C,_,_).
chi_cl_empty(C) :- chi_cl(C), not chi_lit(C,_,_).

:- theta_cl_empty(C1), theta_cl(C2), C2 > C1, theta_lit(C2,_,_).
:- theta_p_cl_empty(C1), theta_p_cl(C2), C2 > C1, theta_p_lit(C2,_,_).
:- chi_cl_empty(C1), chi_cl(C2), C2 > C1, chi_lit(C2,_,_).

% theta & chi equiv fact & -foil

% guess countermodel
cm1(A,t) | cm1(A,f) :- atom(A).
u :- cm1(A,V1), cm1(A,V2), V1 != V2.

% check theta
theta_cl_sat1(C) :- theta_cl_empty(C).
theta_cl_sat1(C) :- theta_cl(C), theta_lit(C,A,V), cm1(A,V).
theta_cl_viol1(C) :- theta_cl(C), not theta_cl_empty(C),
                                  cm1(A,f) : theta_lit(C,A,t);
                                  cm1(A,t) : theta_lit(C,A,f).

theta_sat1 :- theta_cl_sat1(C) : theta_cl(C).
theta_viol1 :- theta_cl_viol1(C).

% check chi
chi_cl_sat1(C) :- chi_cl_empty(C).
chi_cl_sat1(C) :- chi_cl(C), chi_lit(C,A,V), cm1(A,V).
chi_cl_viol1(C) :- chi_cl(C), not chi_cl_empty(C),
                              cm1(A,f) : chi_lit(C,A,t);
                              cm1(A,t) : chi_lit(C,A,f).

chi_sat1 :- chi_cl_sat1(C) : chi_cl(C).
chi_viol1 :- chi_cl_viol1(C).

% check fact and foil
foil_cl_sat1(C) :- foil_cl(C), lit(C,A,V), cm1(A,V).
fact_cl_viol1(C) :- fact_cl(C), cm1(A,f) : lit(C,A,t);
                               cm1(A,t) : lit(C,A,f).

fact_cl_sat1(C) :- fact_cl(C), lit(C,A,V), cm1(A,V).
foil_cl_viol1(C) :- foil_cl(C), cm1(A,f) : lit(C,A,t);
                               cm1(A,t) : lit(C,A,f).

fact_sat1 :- fact_cl_sat1(C) : fact_cl(C).
foil_viol1 :- foil_cl_viol1(C).
foil_sat1 :- foil_cl_sat1(C) : foil_cl(C).
fact_viol1 :- fact_cl_viol1(C).

% cm satisfies theta & chi and fact & -foil -> saturate
u :- theta_sat1, chi_sat1, fact_sat1, foil_viol1.
% cm falsifies theta & chi and fact & -foil -> saturate
u :- theta_viol1, fact_viol1.
u :- theta_viol1, foil_sat1.
u :- chi_viol1, fact_viol1.
u :- chi_viol1, foil_sat1.

% saturation
cm1(A,t) :- u, atom(A).
cm1(A,f) :- u, atom(A).
:- not u.

% :- not cm1(p2,t).
% :- not cm1(p3,t).
% :- not cm1(p4,t).


% theta_p & chi equiv -fact & foil

% guess countermodel
cm2(A,t) | cm2(A,f) :- atom(A).
v :- cm2(A,V1), cm2(A,V2), V1 != V2.

% check theta
theta_cl_sat2(C) :- theta_p_cl_empty(C).
theta_cl_sat2(C) :- theta_p_cl(C), theta_p_lit(C,A,V), cm2(A,V).
theta_cl_viol2(C) :- theta_p_cl(C), not theta_p_cl_empty(C),
                                   cm2(A,f) : theta_p_lit(C,A,t);
                                   cm2(A,t) : theta_p_lit(C,A,f).

theta_sat2 :- theta_cl_sat2(C) : theta_p_cl(C).
theta_viol2 :- theta_cl_viol2(C).

% check chi
chi_cl_sat2(C) :- chi_cl_empty(C).
chi_cl_sat2(C) :- chi_cl(C), chi_lit(C,A,V), cm2(A,V).
chi_cl_viol2(C) :- chi_cl(C), not chi_cl_empty(C),
                              cm2(A,f) : chi_lit(C,A,t);
                              cm2(A,t) : chi_lit(C,A,f).

chi_sat2 :- chi_cl_sat2(C) : chi_cl(C).
chi_viol2 :- chi_cl_viol2(C).

% check fact and foil
foil_cl_sat2(C) :- foil_cl(C), lit(C,A,V), cm2(A,V).
fact_cl_viol2(C) :- fact_cl(C), cm2(A,f) : lit(C,A,t);
                               cm2(A,t) : lit(C,A,f).

fact_cl_sat2(C) :- fact_cl(C), lit(C,A,V), cm2(A,V).
foil_cl_viol2(C) :- foil_cl(C), cm2(A,f) : lit(C,A,t);
                               cm2(A,t) : lit(C,A,f).

fact_sat2 :- fact_cl_sat2(C) : fact_cl(C).
foil_viol2 :- foil_cl_viol2(C).
foil_sat2 :- foil_cl_sat2(C) : foil_cl(C).
fact_viol2 :- fact_cl_viol2(C).

% cm satisfies theta & chi and -fact & foil -> saturate
v :- theta_sat2, chi_sat2, fact_viol2, foil_sat2.
% cm falsifies theta & chi and -fact & foil -> saturate
v :- theta_viol2, fact_sat2.
v :- theta_viol2, foil_viol2.
v :- chi_viol2, fact_sat2.
v :- chi_viol2, foil_viol2.

% saturation
cm2(A,t) :- v, atom(A).
cm2(A,f) :- v, atom(A).
:- not v.



% size
:~ theta_lit(C,A,V). [1@2,C,A,theta]
:~ theta_p_lit(C,A,V). [1@2,C,A,theta_p]
:~ chi_lit(C,A,V). [1@2,C,A,chi]
:~ chi_lit(C,A,V). [-1@1,C,A,chi_max]


#show theta_lit/3.
#show theta_p_lit/3.
#show chi_lit/3.

