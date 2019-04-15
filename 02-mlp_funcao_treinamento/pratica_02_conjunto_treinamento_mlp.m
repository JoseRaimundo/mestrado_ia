
% CEFET/PB/GTEMA, Joao Pessoa, 18/10/2005.
% PROJETO DE REDES NEURAIS SEM REALIMENTAC�O 
% ARQUITETURA: REDE MLP - Multilayer Perceptrons
% CONFIGURAC�O: UMA CAMADA OCULTA - UM NEUR�NIO DE SA�DA LINEAR
% ALGORITMO: BACKPROPAGATION
% APLICACAO: Aproxima��o de Fun��es
% AUTOR: Dr. PAULO HENRIQUE DA FONSECA SILVA

clear all, close all, clc,help mlp_backpropagation.m, global grafico legenda

to=clock; 
epochmax=20000; 
epochexb=100; 
Ni=2; 
Nh=15; 
Ns=1; 
WMED=.07; 
eta=0.01; 


%load('fun_dataset.mat');  % N xmax xtreino dtreino xteste dteste   
%display(dtreino)

xtreino = [0:1/50:1]; %size 1 - 51
dtreino = [0:1/50:1];
%dtreino = rand(51,1);
vec_treino = [0:1/50:1]
%Alimentando o conjunto de treinamento com um array exponencial
dtreino = vec_treino.^2;
N = 51; %51

NT = 5000; %5000
xmax = 1; %6

%display(dtreino) 
%display(N) 
%grafico_dataset(xtreino,dtreino);
Wji=randn(Nh,Ni).*WMED; Wkj=randn(Ns,Nh+1).*WMED;

for epoca=1:epochmax
    
    E=[]; deltaWkj=0; deltaWji=0;
    
    for i=1:N
      xi=[-1 xtreino(i)]; 
      d=dtreino(i); 
      netj=Wji*xi';  
      yj=(1)./(1+exp(-netj'));  
      z(i)=Wkj*[-1 yj]';
      e=d-z(i); etae=-eta*e;  
      deltaWkj=deltaWkj-etae*[-1 yj];
      deltaWji=deltaWji-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi; 
      E(i)=0.5*e^2; 
    end

    Wkj=Wkj+deltaWkj; Wji=Wji+deltaWji;
  
    SSE(epoca)=sum(E)/N;    
    grafico_treino(xtreino,xmax,dtreino,z,epoca,epochexb,SSE(epoca));
end

TBP=etime(clock,to)/60;	grafico_sse(SSE,TBP);
to=clock; 
for n=1:length(xteste)
    xi=[-1 xteste(n)]';     netj=Wji*xi;     yj=(1)./(1+exp(-netj'));        zteste(n)=Wkj*[-1 yj]';
end

TBP1=etime(clock,to);
eteste=abs(dteste-zteste); EMAX=max(eteste); EAV=sum(eteste.^2)./(2*length(eteste));
figure(2)
grafico_teste(xteste,xmax,dteste,zteste,TBP1)
relatorio(N,xteste,eta,WMED,Ni,Nh,Ns,SSE,TBP,EMAX,EAV,TBP1);
