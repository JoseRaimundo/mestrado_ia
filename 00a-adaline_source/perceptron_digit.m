clear all, close all, clc
XX = zeros (9,4,10); %10 9x4 matrices; for display as graph and later transfer to P0
 XX(:,:,1) = [0 0 0 1; ...   % The binary expression of digit "1", 
             0 0 0 1; ...   % before turning it into a vector 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1]; 
XX(:,:,2) = [1 1 1 1; ...   % The binary expression of digit "2", 
             0 0 0 1; ...   % before turning it into a vector 
             0 0 0 1; ... 
             0 0 0 1; ... 
             1 1 1 1; ... 
             1 0 0 0; ... 
             1 0 0 0; ... 
             1 0 0 0; ... 
             1 1 1 1]; 
XX(:,:,3) = [1 1 1 1; ...   % The binary expression of digit "3", 
             0 0 0 1; ...   % before turning it into a vector 
             0 0 0 1; ... 
             0 0 0 1; ... 
             1 1 1 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             1 1 1 1]; 
XX(:,:,4) = [1 0 0 1; ...   % The binary expression of digit "4", 
             1 0 0 1; ...   % before turning it into a vector 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1]; 
XX(:,:,5) = [1 1 1 1; ...   % The binary expression of digit "5", before 
             1 0 0 0; ...   % turning it into a vector 
             1 0 0 0; ... 
             1 0 0 0; ... 
             1 1 1 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             1 1 1 1]; 
XX(:,:,6) = [1 1 1 1; ...   % The binary expression of digit "6", 
             1 0 0 0; ...   % before turning it into a vector 
             1 0 0 0; ... 
             1 0 0 0; ... 
             1 1 1 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1]; 
XX(:,:,7) = [1 1 1 1; ...   % The binary expression of digit "7", 
             0 0 0 1; ...   % before turning it into a vector 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1]; 
XX(:,:,8) = [1 1 1 1; ...   % The binary expression of digit "8", 
             1 0 0 1; ...   % before turning it into a vector 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1]; 
XX(:,:,9) = [1 1 1 1; ...   % The binary expression of digit "9", 
             1 0 0 1; ...   % before turning it into a vector 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1; ... 
             0 0 0 1]; 
XX(:,:,10)= [1 1 1 1; ...   % The binary expression of digit "0", 
             1 0 0 1; ...   % before turning it into a vector 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 0 0 1; ... 
             1 1 1 1]; 

%Convert the digits to bipolar
 XX = 2*XX - 1;
 
%Digit identifiers for ploting graph below
 digitID = [1 2 3 4 5 6 7 8 9 0];

%Plot the digits to check
 for i = 1:10


subplot(2,5,i) 
%SUBPLOT(mnp), breaks the Figure window into an m-by-n matrix of small axes, selects the p-th axes for the current plot, and returns the axis handle.
 imagesc(~hardlim(XX(:,:,i) - 0.5)); 
%scale data and display as image; IMAGESC(...,CLIM) where CLIM = [CLOW CHIGH] can specify the scaling.
 colormap('hot'); %Color look-up table.
 set (gca, 'PlotBoxAspectRatio', [4 9 1]);
 set(gca,'XTick',[],'YTick',[]); 
xlabel(sprintf('Digit %d',digitID(i))); 
%SET(H,'PropertyName',PropertyValue) sets the value of the specified property for the graphics object with handle H.

end

%create the input pattern matrix
 P0 = zeros(36,10);
 for i = 1:10
 P0(:,i) = reshape (XX(:,:,i), 36, 1); 
% RESHAPE(X,M,N) returns the M-by-N matrix whose elements are taken columnwise from X. 
end

%Create the Bipolar target value
 T = 2 * eye(10) - ones(10);
 % EYE(N) is the N-by-N identity matrix. ONES(N) is an N-by-N matrix of ones.

%TP [learning rate, max no iterations, mean square error goal] = training parameters
 %P: N x Q matrix of Q input vectors; 
%T: M x Q matrix of target values;
 %W: weights; E: error trajectory;

Tp = [0.01 2000 0.1]; %TP [learning rate, max no iterations, mean square error goal] 

P = [ones(1,10); P0]; %add a row of ones as bias 

[N, Q] = size(P)
 [M, Q] = size(T)
 W = 0.001 * randn(M, N); %10 x 37, initialize the weight matrix of small values

iter = 0;
 MSE = [];

while iter < Tp(2)


iter = iter + 1;
 SEr = 0; %mean square error

for k = 1:Q


yout = tansig (W*P(:,k)); %output = f(w(k)' *x(k)), w(k) is declared transposed
 SEr = SEr + 1/Q * norm((yout - T(:,k)))^2; %mean squared error
 W = W - Tp(1) * diag (1-yout.^2) * (yout - T(:,k)) * P(:,k)'; % update Weight, important, .^ means array power

end

MSE = [MSE SEr];

if SEr < Tp(3)
 break;
 end

end

%display the epochs
 disp (sprintf ('Epochs to converge = %i', iter));
 % Display the ending MSE 
disp(sprintf('Ending MSE = %f',MSE(1,end))); 
  
% Plot the MSE performance 
figure; 
plot(MSE); 
title('MSE performance'); 
xlabel('Epochs'); 
ylabel('MSE'); 

% experiment with noise
 pn = 0.105; % rate of noise 
  
% Create some noisy data 

 for i = 1:10 
     XX_noisy(:,:,i) = XX(:,:,i).*hardlims(rand(size(XX(:,:,i)))-pn); %.^ means array times

    noisyP0(:,i) = reshape(XX_noisy(:,:,i),36,1); 
end 

% Augment the pattern matrix with a row of ones 
noisyP = [ones(1,10);noisyP0]; 

recog = zeros(10,1);
 SEr = 0;
 for k = 1:Q 


yout = tansig (W*noisyP(:,k));
 SEr = SEr + 1/Q * norm((yout - T(:,k)))^2; %mean squared error
 [junk, recog(k)] = max(yout);

end

 MSE = [MSE SEr];
 disp(sprintf('MSE on noisy input = %f',MSE(1,end))); 

figure;
 for i = 1:10
 subplot(2,5,i);
 imagesc(~hardlim(XX_noisy(:,:,i)-0.5)); colormap('gray');
 set(gca,'PlotBoxAspectRatio',[4 9 1]);
 set(gca,'XTick',[],'YTick',[]);
 xlabel(sprintf('Digit %d',digitID(recog(i))));
 end 

