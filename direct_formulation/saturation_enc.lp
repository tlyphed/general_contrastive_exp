atom(A) :- lit(_,A,_).

% guess s', s'' and t
{ s'(A,t)  ; s'(A,f)  } <= 1 :- atom(A).
{ s''(A,t) ; s''(A,f) } <= 1 :- atom(A).
{ t(A,t)   ; t(A,f)   } <= 1 :- atom(A).

% s entails s'
:- s'(A,V), not s(A,V).

% s entails t
:- t(A,V), not s(A,V).

% s'' & t is sat
:- s''(A,V1), t(A,V2), V1 != V2.


% s' & t entail fact & -foil

% aux
w1(A,V) :- s'(A,V).
w1(A,V) :- t(A,V).

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


% s'' & t entail -fact & foil

% aux
w2(A,V) :- s''(A,V).
w2(A,V) :- t(A,V).

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


% distance s' to s''
add(A) :- s'(A,V), not s''(A,_).
rem(A) :- s''(A,V), not s'(A,_).
flip(A) :- s''(A,V1), s'(A,V2), V1!=V2.
:~ add(A). [1,A]
:~ rem(A). [1,A]
:~ flip(A). [1,A]

% size
:~ s'(A,V). [1,A,s']
:~ s''(A,V). [1,A,s'']


#show s'/2.
#show s''/2.
% #show t/2.
