function Y = symbolic(X,x1,x2,x3,x4,x5,x6)

Y= subs(X, [cos(x1),sin(x1),cos(x2),sin(x2),cos(x3),sin(x3),cos(x4),sin(x4),cos(x5),sin(x5),cos(x6),sin(x6), cos(x2+x3),sin(x2+x3)], ...
    [sym('c1'),sym('s1'),sym('c2'),sym('s2'),sym('c3'),sym('s3'),sym('c4'),sym('s4'),sym('c5'),sym('s5'),sym('c6'),sym('s6'),sym('c23'),sym('s23')]);


end