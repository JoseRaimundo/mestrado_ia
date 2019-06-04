% Example 5.4  Write a M-file for adaptive system identification using adaline network.
% Solution  The adaline network for adaptive system identification is developed using MATLAB programming techniques by assuming necessary parameters .
% Program
% Adaptive System Identification
clear all; close all; clc;
% Input signal x(t)
f = 0.8 ;      %  Hz
ts = 0.005 ; % 5 msec -- sampling time
N1 = 800 ; N2 = 400 ; N = N1 + N2 ;
t1 = (0:N1-1)*ts ;  % 0 to 4 sec
t2 = (N1:N-1)*ts ;  % 4 to 6 sec
t = [t1 t2] ;       % 0 to 6 sec
xt = sin(1*t.*sin(2*pi*f*t)) ;
p = 3 ; % Dimensionality of the system
b1 = [ 1  -0.6 0.4] ; % unknown system parameters during  t1
b2 = [0.9 -0.5 0.7] ; % unknown system parameters during  t2
 [d1, stt] = filter(b1, 1, xt(1:N1) ) ;
 d2 =  filter(b2, 1, xt(N1+1:N), stt) ;
 dd = [d1 d2] ; %  output signal
% formation of the input matrix X of size  p by N
X = convmtx(xt, p) ; X = X(:, 1:N) ;
% Alternatively, we could calculated D as
d = [b1*X(:,1:N1) b2*X(:,N1+1:N)] ;
 y  = zeros(size(d)) ;   % memory allocation for y
eps = zeros(size(d)) ;   % memory allocation for eps
eta = 0.2  ; % learning rate/gain
w = 2*(rand(1, p)  -0.5) ; % Initialisation of the weight vector
for n = 1:N  %  learning loop
 y(n) = w*X(:,n) ;      % predicted output signal
 eps(n) = d(n) - y(n) ; % error signal
 w = w + eta*eps(n)*X(:,n)' ;
 if n == N1-1, w1 = w ; 
end
end
figure(1)
subplot(2,1,1)
plot(t, xt), grid, title('Input Signal, x(t)'), xlabel('time sec')
subplot(2,1,2)
plot(t, d, 'b', t, y, '-r'), grid, ... 
title('target and predicted signals'), xlabel('time [sec]')
figure(2)
plot(t, eps), grid, title(['prediction error for eta = ', num2str(eta)]), ... 
xlabel('time [sec]')
 [b1; w1]
[b2;  w]
