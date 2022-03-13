clear
close all
clc
% Task 1
%Generate a random noise digital signal having normal distribution with different parameter sets 

n=512; % Number of Sample
m=[0 2]; % Mean Values for N1 and N2
s=[1 2]; % Standard Deviation values for S1 and S2
z=[1 3]; % Interval for the uniformly distributed signal 

N1=random_noise(m,s,n,1);
N2=random_noise(m,s,n,2);
U=uni_ditributed_signal(z,n);

N=[N1, N2, U];

meanG=mean(N); %Is the generated real means of the generated signal(N1, N2, U)
stdG=std(N);  %Is the generated real standard deviation of the generated signal(N1, N2, U)

meanDifference=[0 1 2]-meanG
stdDifference=[1 2 0.5]-stdG

plot(1:n,N(:,1:end))
legend({'N1','N2','U'},'Location','northeast')
xlim([0 512])

% Task 2
% For the signals N1, N2 and U generated in the previous exercise compute their running statistics (mean and standard deviation) and plot the results.
[RM1,RS1]=running_statistics(N1);
[RM2,RS2]=running_statistics(N2);
[RM3,RS3]=running_statistics(U);

figure
figu(RM1,1,'b','Running Mean N1')
figu(RM2,2,'g','Running Mean N2')
figu(RM3,3,'r','Running Mean U')
figu(RS1,4,'b','Running SD N1')
figu(RS2,5,'g','Running SD N2')
figu(RS3,6,'r','Running SD U')

%Task 3

figure
figh(N1,1,10,'N1. 10 bins')
figh(N2,2,10,'N2. 10 bins')
figh(U,3,10,'U. 10 bins')
figh(N1,4,90,'N1. 90 bins')
figh(N2,5,90,'N2. 90 bins')
figh(U,6,90,'U. 90 bins')

%Task 4
U1x128=generate(1);
U2x128=generate(2);
U4x128=generate(4);
U6x128=generate(6);
U8x128=generate(8);
U10x128=generate(10);

figure
figur(U1x128,1,'Adding 1')
figur(U2x128,2,'Adding 2')
figur(U4x128,3,'Adding 4')
figur(U6x128,4,'Adding 6')
figur(U8x128,5,'Adding 8')
figur(U10x128,6,'Adding 10')
% From the histogram I have observed that I almost have similar distribution curves but the ranges are different
%for the 128x1 the ranges are from 0,1
%for the 128x2 the ranges are from 0,2
%for the 128x4 the ranges are from 0,4
%for the 128xn the ranges are from 0,n
%this is because we are adding consecutive n elements which have range 0,1



%-----------------------------------------------------%
%This function is used to plot histogram with equation x ,subplot number n,and title t
function figur(x,n,t)
    subplot(2,3,n)
    histogram(x)
    title(t)
end
%This function is used to generate random 128xmult matrix in the interval of 0 and 1; and sum mult consecutive elements in the matrix(row) and return the vector of 128x1
function res=generate(mult)
        z=[0 1];
        %generate 128xmult random number in the interval of 0 and 1
        A=z(1)+(z(2)-z(1))*rand(128,mult);
        %prepare ouput vector
        res=zeros(size(A:1));
        %sum the consecutive n elements and return 128x1 vector
        for n=1:length(A)
            res(n)=sum(A(n,:));
        end
end
%This function is used to plot histogram with equation x ,subplot number n, bin b and title t
function figh(x,n,b,t)
    subplot(2,3,n)
    histogram(x,b)
    title(t)
end
%This function is used to plot equation x ,subplot number n, color c and title t
function figu(x,n,c,t)
    subplot(2,3,n)
    plot(x,c)
    title(t)
    xlim([0 512])
end

function[N]=random_noise(m,s,n,i)
    N=s(i)*randn(n,1)+m(i);
end
% This function is used to create uniformly distributed signal with interval z and n number of samples
function[U]=uni_ditributed_signal(z,n)
    U=z(1)+(z(2)-z(1))*rand(n,1);
end
%This function is return the running statistics of function x
function [RM, RS] = running_statistics(x)
  % prepare output vectors
  RM = zeros(size(x));
  RS = zeros(size(x));

  % calculate running statistics
  for i = 1:length(x)
    RM(i) = mean(x(1:i));
    RS(i) = std(x(1:i));
  end
  end