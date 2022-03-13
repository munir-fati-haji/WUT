clear; clc;
syms x1 x2 x3 x4 x5 x6 a1 a2 a3 d2 d4 d6 r11 r12 r13 r14 r21 r22 r23 r24 r31 r32 r33 r34 r41 r42 r43 r44 px py pz

t01=[cos(x1) -sin(x1) 0 0;
    sin(x1) cos(x1) 0 0;
    0 0 1 0;
    0 0 0 1];

t12=[cos(x2) -sin(x2) 0 0;
    0 0 -1 -d2;
    sin(x2) cos(x2) 0 0;
    0 0 0 1];

t23=[cos(x3) -sin(x3) 0 0;
    0 0 -1 0;
    sin(x3) cos(x3) 1 0;
    0 0 0 1];

% t34=[cos(x4) -sin(x4) 0 a3;
%     0 0 1 d4;
%     -sin(x4) -cos(x4) 0 0;
%     0 0 0 1];
% 
% t45=[cos(x5) -sin(x5) 0 0;
%     0 0 -1 0;
%     sin(x5) cos(x5) 0 0;
%     0 0 0 1];
% 
% t56=[cos(x6) -sin(x6) 0 0;
%     0 0 1 d6;
%     -sin(x6) -cos(x6) 0 0;
%     0 0 0 1];
% 
% td=[r11 r12 r13 px;
%     r21 r22 r23 py;
%     r31 r32 r33 pz;
%     0 0 0 1];


%t01d=orthinv(t01);

% t05d=td*orthinv(t56);
% t05=simplify(t01*t12*t23*t34*t45);

% t03= t01*t12*t23;
% t36d= simplify(orthinv(t03) *td);
% t36 = simplify(t34*t45*t56);

% t02= t01*t12;
% t25d= simplify(orthinv(t02) *td * orthinv(t56))
% t25 = simplify(t23*t34*t45)

% eqns = t36 - t36d;
% 
% eq11 = intersect(symvar(eqns(1,1)),[ x1, x2, x3, x4, x5, x6])
% eq12 = intersect(symvar(eqns(1,2)),[ x1, x2, x3, x4, x5, x6])
% eq13 = intersect(symvar(eqns(1,3)),[ x1, x2, x3, x4, x5, x6])
% eq14 = intersect(symvar(eqns(1,4)),[ x1, x2, x3, x4, x5, x6])
% 
% eq21 = intersect(symvar(eqns(2,1)),[ x1, x2, x3, x4, x5, x6])
% eq22 = intersect(symvar(eqns(2,2)),[ x1, x2, x3, x4, x5, x6])
% eq23 = intersect(symvar(eqns(2,3)),[ x1, x2, x3, x4, x5, x6])
% eq24 = intersect(symvar(eqns(2,4)),[ x1, x2, x3, x4, x5, x6])
% 
% eq31 = intersect(symvar(eqns(3,1)),[ x1, x2, x3, x4, x5, x6])
% eq32 = intersect(symvar(eqns(3,2)),[ x1, x2, x3, x4, x5, x6])
% eq33 = intersect(symvar(eqns(3,3)),[ x1, x2, x3, x4, x5, x6])
% eq34 = intersect(symvar(eqns(3,4)),[ x1, x2, x3, x4, x5, x6])
% 
% eq41 = intersect(symvar(eqns(4,1)),[ x1, x2, x3, x4, x5, x6])
% eq42 = intersect(symvar(eqns(4,2)),[ x1, x2, x3, x4, x5, x6])
% eq43 = intersect(symvar(eqns(4,3)),[ x1, x2, x3, x4, x5, x6])
% eq44 = intersect(symvar(eqns(4,4)),[ x1, x2, x3, x4, x5, x6])
% 
% 
% 
% 
% %% For X5
% 
% eqns(2,3)
% 
% [x5_sol,x5_params,x5_conds] = ...
%     solve(eqns(2,3),x5,'Real',true,'ReturnConditions',true);
% 
% x5_sol = subs(x5_sol,x5_params,0);
% 
% %% For X4
% 
% eqns(3,3)
% 
% [x4_sol,x4_params,x4_conds] = ...
%     solve(eqns(3,3),x4,'Real',true,'ReturnConditions',true);
% 
% x4_sol = subs(x4_sol,x4_params,0);
% 
% 
% %% For X6
% 
% eqns(3,1)
% 
% [x6_sol,x6_params,x6_conds] = ...
%     solve(eqns(3,1),x6,'Real',true,'ReturnConditions',true);
% 
% x6_sol = subs(x6_sol,x6_params,0);

%% For X2


% [x2_sol,x2_params,x2_conds] = ...
%     solve(eqns(1,4),x2,'Real',true,'ReturnConditions',true)
% % x2_sol = subs(x2_sol,x2_params,0)
% 
% [x2_sol1,x2_params1,x2_conds1] = ...
%     solve(eqns(2,4),x2,'Real',true,'ReturnConditions',true)
% % x2_sol1 = subs(x2_sol1,x2_params1,0)
% 
% LHS= x2_sol(1,1)
% RHS=x2_sol1(1,1)
% Final= simplify(LHS-RHS)
% 
% 
% [x3_sol,x3_params,x3_conds] = ...
%     solve(Final,x3,'Real',true,'ReturnConditions',true,'IgnoreAnalyticConstraints', true)
% x3_sol = subs(x3_sol,x3_params,0)

t12= subs(t12, [cos(x1),sin(x1),cos(x2),sin(x2),cos(x3),sin(x3),cos(x4),sin(x4),cos(x5),sin(x5),cos(x6),sin(x6), cos(x2+x3),sin(x2+x3)], ...
    [sym('c1'),sym('s1'),sym('c2'),sym('s2'),sym('c3'),sym('s3'),sym('c4'),sym('s4'),sym('c5'),sym('s5'),sym('c6'),sym('s6'),sym('c23'),sym('s23')]);

t14_= subs(t1, [cos(x1),sin(x1),cos(x2),sin(x2),cos(x3),sin(x3),cos(x4),sin(x4),cos(x5),sin(x5),cos(x6),sin(x6), cos(x2+x3),sin(x2+x3)], ...
    [sym('c1'),sym('s1'),sym('c2'),sym('s2'),sym('c3'),sym('s3'),sym('c4'),sym('s4'),sym('c5'),sym('s5'),sym('c6'),sym('s6'),sym('c23'),sym('s23')]);

X1= subs(x1_sol, [cos(x1),sin(x1),cos(x2),sin(x2),cos(x3),sin(x3),cos(x4),sin(x4),cos(x5),sin(x5),cos(x6),sin(x6), cos(x2+x3),sin(x2+x3)], ...
    [sym('c1'),sym('s1'),sym('c2'),sym('s2'),sym('c3'),sym('s3'),sym('c4'),sym('s4'),sym('c5'),sym('s5'),sym('c6'),sym('s6'),sym('c23'),sym('s23')]);


