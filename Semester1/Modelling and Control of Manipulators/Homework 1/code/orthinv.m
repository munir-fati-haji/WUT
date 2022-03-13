function [g] = orthinv(x)
p= [x(1,1) ,x(2,1), x(3,1);
    x(1,2) ,x(2,2), x(3,2);
    x(1,3) ,x(2,3), x(3,3)];
t = simplify( -p * [x(1,4) ;x(2,4); x(3,4)]);
f = [0 0 0 1];
q=cat(2,p,t);
g=cat(1,q,f);
end

