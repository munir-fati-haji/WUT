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
zeta=1;
B=Bm+(Kb*Km/R);

w = 50;
Kp = (w^2*Jm*R)/Km;
Kd = R*(2*w*Jm-B)/Km;

addpath('trajectories');
run('trajectories\trajectoryData.m')




