function H=calculate_homography(points_in, points_out)

X = points_out(1,:);
Y = points_out(2,:);

hx=zeros(4,8);
hy=zeros(4,8);

for i=1:1:size(points_in,2)
hx(i,:)=[points_in(1,i) points_in(2,i) 1 0 0 0 -points_in(1,i)*points_out(1,i) -points_in(2,i)*points_out(1,i)];
hy(i,:)=[0 0 0 points_in(1,i) points_in(2,i) 1 -points_in(1,i)*points_out(2,i) -points_in(2,i)*points_out(2,i)];
end
h=[hx;hy];

pout=[X Y]';

U=h\pout;

H=[ U(1) U(2) U(3);
    U(4) U(5) U(6);
    U(7) U(8) 1];

end