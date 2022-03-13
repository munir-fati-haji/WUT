clear; clc;
syms x1 x2 x3 x4 x5 x6 a1 a2 a3 d1 d2 d3 d4 d6 r11 r12 r13 r14 r21 r22 r23 r24 r31 r32 r33 r34 r41 r42 r43 r44 px py pz

t01=homogenoustransformation(0,0,d1,x1);
t12=homogenoustransformation(0,3*pi/2,0,x2);
t23=homogenoustransformation(a2,0,0,x3);
t34=homogenoustransformation(a3,3*pi/2,d4,x4);
t45=homogenoustransformation(0,pi/2,0,x5);
t56=homogenoustransformation(0,3*pi/2,d6,x6);

t02= (t01*t12);
t03= (t02*t23);
t04= (t03*t34);
t05= (t04*t45);
t06= (t05*t56);

td=[r11 r12 r13 px;
    r21 r22 r23 py;
    r31 r32 r33 pz;
    0 0 0 1];

%% Direct Kinematics
% t01 = symbolic(t01,x1,x2,x3,x4,x5,x6)
% t12 = symbolic(t12,x1,x2,x3,x4,x5,x6)
% t23 = symbolic(t23,x1,x2,x3,x4,x5,x6)
% t34 = symbolic(t34,x1,x2,x3,x4,x5,x6)
% t45 = symbolic(t45,x1,x2,x3,x4,x5,x6)
% t56 = symbolic(t56,x1,x2,x3,x4,x5,x6)

X01 = symbolic(t01,x1,x2,x3,x4,x5,x6)
X02 = symbolic(t02,x1,x2,x3,x4,x5,x6)
X03 = symbolic(t03,x1,x2,x3,x4,x5,x6)
X04 = symbolic(t04,x1,x2,x3,x4,x5,x6)
X05 = symbolic(t05,x1,x2,x3,x4,x5,x6)
X06 = symbolic(t06,x1,x2,x3,x4,x5,x6)

%% Inverse Kinematic

t35d = simplify(orthinv(t03) * td*orthinv(t56) )
t35  = simplify(t34*t45)
eqns = t35d - t35;

eq11 = intersect(symvar(eqns(1,1)),[ x1,x2,x3,x4,x5,x6])
eq12 = intersect(symvar(eqns(1,2)),[ x1,x2,x3,x4,x5,x6])
eq13 = intersect(symvar(eqns(1,3)),[ x1,x2,x3,x4,x5,x6])
eq14 = intersect(symvar(eqns(1,4)),[ x1,x2,x3,x4,x5,x6])

eq21 = intersect(symvar(eqns(2,1)),[ x1,x2,x3,x4,x5,x6])
eq22 = intersect(symvar(eqns(2,2)),[ x1,x2,x3,x4,x5,x6])
eq23 = intersect(symvar(eqns(2,3)),[ x1,x2,x3,x4,x5,x6])
eq24 = intersect(symvar(eqns(2,4)),[ x1,x2,x3,x4,x5,x6])

eq31 = intersect(symvar(eqns(3,1)),[ x1,x2,x3,x4,x5,x6])
eq32 = intersect(symvar(eqns(3,2)),[ x1,x2,x3,x4,x5,x6])
eq33 = intersect(symvar(eqns(3,3)),[ x1,x2,x3,x4,x5,x6])
eq34 = intersect(symvar(eqns(3,4)),[ x1,x2,x3,x4,x5,x6])

eq41 = intersect(symvar(eqns(4,1)),[ x1,x2,x3,x4,x5,x6])
eq42 = intersect(symvar(eqns(4,2)),[ x1,x2,x3,x4,x5,x6])
eq43 = intersect(symvar(eqns(4,3)),[ x1,x2,x3,x4,x5,x6])
eq44 = intersect(symvar(eqns(4,4)),[ x1,x2,x3,x4,x5,x6]) 

% % For X1
% % 
% %eqns(2,3)
% % 
% [x1_sol,x1_params,x1_conds] = ...
%     solve(eqns(2,3),x1,'Real',true,'ReturnConditions',true);
% 
% x1_sol = subs(x1_sol,x1_params,0)

t35d = symbolic(t35d,x1,x2,x3,x4,x5,x6)
t35 = symbolic(t35,x1,x2,x3,x4,x5,x6)



%% Jacobian

[z1,p1]=jomega(t01)
[z2,p2]=jomega(t02)
[z3,p3]=jomega(t03)
[z4,p4]=jomega(t04)
[z5,p5]=jomega(t05)
[z6,p6]=jomega(t06)

zero=[0; 0; 0];

Jw=[z1 z2 z3 z4 z5 z6]

P1=simplify(p6-p1)
P2=simplify(p6-p2)
P3=simplify(p6-p3)
P4=simplify(p6-p4)
P5=simplify(p6-p5)
P6=simplify(p6-p6)

jv1=simplify(cross(z1,P1));
jv2=simplify(cross(z2,P2));
jv3=simplify(cross(z3,P3));
jv4=simplify(cross(z4,P4));
jv5=simplify(cross(z5,P5));
jv6=simplify(cross(z6,P6));


Jv=[jv1 jv2 jv3 jv4 jv5 jv6]

J=[Jv;Jw];
J=simplify(det(J))

J=symbolic(J,x1,x2,x3,x4,x5,x6)