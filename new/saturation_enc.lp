atom(A) :- lit(_,A,_).

% guess 
{ theta(A,t)  ; theta(A,f)  } <= 1 :- atom(A).
{ theta'(A,t) ; theta'(A,f) } <= 1 :- atom(A).
{ chi(A,t)    ; chi(A,f)    } <= 1 :- atom(A).


% theta & chi equiv fact & -foil

% guess countermodel
cm1(A,t) | cm1(A,f) :- atom(A).
u :- cm1(A,V1), cm1(A,V2), V1 != V2.

% check theta
theta_sat1 :- cm1(A,V) : theta(A,V).
theta_viol1 :- theta(A,V1), cm1(A,V2), V1 != V2.

% check chi
chi_sat1 :- cm1(A,V) : chi(A,V).
chi_viol1 :- chi(A,V1), cm1(A,V2), V1 != V2.

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


% theta' & chi equiv -fact & foil

% guess countermodel
cm2(A,t) | cm2(A,f) :- atom(A).
v :- cm2(A,V1), cm2(A,V2), V1 != V2.

% check theta
theta_sat2 :- cm2(A,V) : theta'(A,V).
theta_viol2 :- theta'(A,V1), cm2(A,V2), V1 != V2.

% check chi
chi_sat2 :- cm2(A,V) : chi(A,V).
chi_viol2 :- chi(A,V1), cm2(A,V2), V1 != V2.

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
:~ theta(A,V). [1,A,theta]
:~ theta'(A,V). [1,A,theta']
:~ chi(A,V). [1,A,chi]


#show theta/2.
#show theta'/2.
#show chi/2.
