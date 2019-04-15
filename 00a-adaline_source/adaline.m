% Campina Grande, 03 de novembro de 2000.
% ADALINE - ELEMENTO LINEAR ADAPTATIVO
% Algoritmo do LMS (Widrow-Hoff)
% matriz de exemplos de entrada: 	x    
% vetor de exemplos de sa�da: 		y  
% FUN��O DE ATIVA��O: LINEAR
% [SSE,W1]=adaline(x,d,TA,epochmax,Wini)  
% CRIT�RIO DE PARADA PELA VARIA��O DOS PESOS

function [SSE,W1]=adaline(x,d,TA,epochmax,Wini)       

% ALGORITMO DE WIDROW
N=length(d);
 
% INICIA PESOS
W=Wini; W1=W; W1(1,:)=W;

CP=0; SSE=[]; 

% APRESENTA epochmax �POCAS DE TREINAMENTO

for epoca=1:epochmax

 % CONJUNTO DE INTEIROS ALEAT�RIOS
  idc=randperm(N);
 
  CP=0;
 
% APRESENTA UMA �POCA DE TREINAMENTO (N EXEMPLOS)

 for n=1:N
  xt=[-1 x(idc(n),1) x(idc(n),2)]; 
  y=(W*xt'); 				% COMBINADOR LINEAR 
  e=d(idc(n))-y;			% ERRO INSTANT�NEO
  W=W+(TA*e).*xt;			% ADAPTA��O DOS PESOS  
  E(n)=0.5*e^2;				% ERRO QUADR�TICO INSTANT�NEO
 end
 
 W1(epoca+1,:)=W;
 SSE(epoca)=sum(E)/N;			% ERRO M�DIO QUADR�TICO

 % CRIT�RIO DE PARADA
 if epoca>1 
  dSSE=abs(SSE(epoca)-SSE(epoca-1));
  if dSSE<1E-6,CP=CP+1, end
 end
 if CP>3, break, end
end
 
