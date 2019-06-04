% Example 5.5  Develop a MATLAB program for adaptive noise cancellation using adaline network.
% Solution  For adaptive noise cancellation in signal processing, adaline network is used and the performance is noted. The necessary parameters to be used are assumed.
% Program
% Adaptive Noise Cancellation
clear all; close all; clc;
% The useful signal u(t) is a frequency and amplitude  modulated sinusoid
f  = 4e3 ;       %  signal frequency 
fm = 300 ;      % frequency modulation
fa  = 200 ;     % amplitude modulation
ts = 2e-5 ;  % sampling time
N =  400 ;   % number of sampling points
t = (0:N-1)*ts ;  % 0  to 10 msec
ut = (1+0.2*sin(2*pi*fa*t)).*sin(2*pi*f*(1+0.2*cos(2*pi*fm*t)).*t) ;
% The noise xt and the filtered noise vt
%xt = 2*sawtooth(2*pi*1e3*t, 0.7) ;
xt=3*sin(2*pi*1e3*t);
%xt=0.05*randn(size(ut));
b = [ 1  -0.7 -0.7];
vt = filter(b, 1, xt);
% noisy signal dt = ut+vt ;
dt=ut+vt;
figure(1)
subplot(2,1,1)
plot(1e3*t, ut,'k:', 1e3*t, dt,'k'), grid, ...
title('Input  u(t)  and noisy input signal  d(t)'), xlabel('time -- msec')
subplot(2,1,2)
plot(1e3*t, xt, 1e3*t, vt), grid, ...
title('Noise  x(t)  and colored noise  v(t)'), xlabel('time -- msec')
p = 4 ; % dimensionality of the input space
% formation of the input matrix X of size  p by N

X = convmtx(xt, p) ; X = X(:, 1:N) ;

y  = zeros(1,N) ;   % memory allocation for y
eps = zeros(1,N) ;   % memory allocation for uh = eps
eta = 0.05  ; % learning rate/gain
w = 2*(rand(1, p)  -0.5) ; % Initialisation of the weight vector
for c = 1:100
for n = 1:N  %  learning loop
y(n) = w*X(:,n) ;      % predicted output signal
eps(n) = dt(n) - y(n) ; % error signal
w = w + eta*eps(n)*X(:,n)' ;
end
eta = 0.9*eta ;
end
figure(2)
subplot(2,1,1)
plot(1e3*t, ut, 1e3*t, eps,'k--'), grid, ...
title('Input signal  u(t)  and estimated signal  uh(t)'), ...
xlabel('time -- msec')
subplot(2,1,2)
plot(1e3*t(p:N), ut(p:N)-eps(p:N),'k--'), grid, ... 
title('estimation error'), xlabel('time --[msec]')
w

