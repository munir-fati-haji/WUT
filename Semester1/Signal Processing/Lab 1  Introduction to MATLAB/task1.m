% Task 1 
% Create two vectors: v1=[0,0.1,0.2,0.3,...,1], v2=[1,1.1,1.2,1.3,...,2]

v1=(0:0.1:1)
v2=(1:0.1:2)

% Compute element-per-element product of the vectors.
%where ep is cross element-per-element product
ep=v1.*v2

% Compute dot product of the vectors.
%where dp is dot product
dp=dot(v1,v2)

% Compute cross product of the first three elements of the vectors (use cross function).

% First lets separate the three first elements of each vector

v13=v1(1,[1,2,3]);
v23=v2(1,[1,2,3]);
%where cp is cross product
cp=cross(v13,v23)

%Task2
%Create the following matrix:
A=[1 2 3 ; 4 10 6; 7 8 -2]

%Create a vector b 
b=[1,5,8];

%solve the set of linear quations
x=inv(A)*transpose(b)

%Task3
%Using matrix A create a new matrix B(use vertical concatenation ):
% aa is the row we are going to add
aa=[3 12 -5];
B=vertcat(A,aa);

%Create a vector c = [1, 5, 8, 6] using the previously defined vector b (use horizontal concatenation operator ).
c=horzcat(b,6)

%Solve the set of linear equations using the least-squares method:
y=(inv((transpose(B))*B))*transpose(B)*transpose(c)
