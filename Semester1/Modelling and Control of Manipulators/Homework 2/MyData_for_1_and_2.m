clear

Jm=5.5e-4;
Kb=0.105;
Km=0.105;
L=0.9e-3;
R=0.76;
Bm=4e-4;
r=156;
Vmin=-35;
Vmax=35;
w=60;
zeta=1;
B=Bm+(Kb*Km/R);
Kp=(R/Km)*(Jm*(w^2));
Kd=(R/Km)*((2*Jm*w*zeta)-B);