function [I3]=crop_image(I2, Rout, pou)
X = pou(1,:);
Y = pou(2,:);

a=(X(1)-Rout.XWorldLimits(1));
b=(Y(1)-Rout.YWorldLimits(1));
c=(X(3)-Rout.XWorldLimits(1));
d=(Y(3)-Rout.YWorldLimits(1));
I3=imcrop(I2,[a b c-a d-b]);

end
