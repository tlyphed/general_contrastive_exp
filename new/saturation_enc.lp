atom(A) :- lit(_,A,_).

% guess 
{ theta(A,t)  ; theta(A,f)  } <= 1 :- atom(A).
{ theta'(A,t) ; theta'(A,f) } <= 1 :- atom(A).
{ chi(A,t)    ; chi(A,f)    } <= 1 :- atom(A).

% theta & chi is sat
:- theta(A,V1), chi(A,V2), V1 != V2.

% theta' & chi is sat
:- theta'(A,V1), chi(A,V2), V1 != V2.

% theta & chi entail fact & -foil
w1(A,V) :- theta(A,V).
w1(A,V) :- chi(A,V).

% guess countermodel
cm1(A,t) | cm1(A,f) :- atom(A).
u :- cm1(A,V1), cm1(A,V2), V1 != V2.

% cm violates s' & t -> saturate
u :- cm1(A,V1), w1(A,V2), V1 != V2.

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

% aux
w2(A,V) :- theta'(A,V).
w2(A,V) :- chi(A,V).

% guess countermodel
cm2(A,t) | cm2(A,f) :- atom(A).
v :- cm2(A,V1), cm2(A,V2), V1 != V2.

% cm violates s' & t -> saturate
v :- cm2(A,V1), w2(A,V2), V1 != V2.

% cm violates s' & t -> saturate
v :- cm2(A,V1), w2(A,V2), V1 != V2.

% cm satisfies -fact & foil -> saturate
foil_cl_sat(C) :- foil_cl(C), lit(C,A,V), cm2(A,V).
fact_cl_viol(C) :- fact_cl(C), cm2(A,f) : lit(C,A,t);
                               cm2(A,t) : lit(C,A,f).

foil_sat :- foil_cl_sat(C) : foil_cl(C).
fact_viol :- fact_cl_viol(C).
v :- foil_sat, fact_viol.

% saturation
cm2(A,t) :- v, atom(A).
cm2(A,f) :- v, atom(A).
:- not v.



% size
:~ theta(A,V). [1,A,theta]
:~ theta'(A,V). [1,A,theta']
:~ chi(A,V). [1,A,chi]


#show theta/2.
#show theta'/2.
#show chi/2.
