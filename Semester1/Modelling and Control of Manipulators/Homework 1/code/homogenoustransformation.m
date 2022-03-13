function [t]=homogenoustransformation(a,alpha,d,thetha)
t=[cos(thetha) -sin(thetha) 0 a;
    sin(thetha)*cos(sym(alpha)) cos(thetha)*cos(sym(alpha)) -sin(sym(alpha)) -d*sin(sym(alpha));
    sin(thetha)*sin(sym(alpha)) cos(thetha)*sin(sym(alpha)) cos(sym(alpha)) d*cos(sym(alpha));
    0 0 0 1
    ];
t=simplify(t);
end