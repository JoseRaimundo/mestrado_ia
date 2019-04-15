% funcionando por neuronio
clear all, close all, clc,help mlp_backpropagation.m, global grafico legenda

to=clock;      
epochexb=100;  
epochmax=20000; 
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
%%% fun_dataset contem:
%%% --> xtreino - conjunto de treinamento 

%%% Gráfico que exite a curva do sinal gerado com as entradas fornecidas
% grafico_dataset(xtreino,dtreino);

Wji=rand(Nh,Ni).*WMED; 
Wkj=rand(Ns,Nh+1).*WMED;

%%% Alimentando com valores aleatórios entre 0.001 e 1 
beta_j 	= 0.01 * rand(Ns, Nh);
alfa_j  = 0.01 * rand(Ns, Nh);
k_j     = 0.01 * rand(Ns, Nh) ;

for epoca=1:epochmax
    
    E=[]; 
    deltaWkj=0; 
    deltaWji=0;

    for i=1:N
      xi=[-1 xtreino(i)]; 
      d=dtreino(i); 
      netj=Wji*xi';  
      %yj=(1)./(1+exp(-netj'));
      yj = alfa_j .* (1 - beta_j .* exp(-k_j .* netj'));
      z(i)=Wkj*[-1 yj]';
      e=d-z(i); 
      etae=-eta*e;  
      deltaWkj=deltaWkj-etae*[-1 yj];
      deltaWji=deltaWji-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi; 
      E(i)=0.5*e^2; 
      
      alfa_j = -etae * (1- beta_j .* exp(-k_j .* netj'));
      beta_j = etae  * (alfa_j .* exp(-k_j .* netj'));     
      k_j    = -etae * (beta_j .* netj' .* exp(-k_j .* netj'));
          
      
    end
    display(etae);
   %display(alfa_j);
   % display(beta_j);
   % display(k_j);
    
    Wkj=Wkj+deltaWkj; 
    Wji=Wji+deltaWji;
    SSE(epoca)=sum(E)/N;    
    
    grafico_treino(xtreino, xmax, dtreino, z, epoca,epochexb, SSE(epoca));
end

TBP=etime(clock,to)/60;	
grafico_sse(SSE,TBP);
to=clock; 
for n=1:length(xteste)
    xi=[-1 xteste(n)]';     
    netj=Wji*xi;    
    yj=(1)./(1+exp(-netj'));        
    zteste(n)=Wkj*[-1 yj]';
end


TBP1=etime(clock,to);
eteste=abs(dteste-zteste); 
EMAX=max(eteste); 
EAV=sum(eteste.^2)./(2*length(eteste));
figure(2)
%%% Gerando gráfico que ilustra o teste da rede já treinada
%grafico_teste(xteste,xmax,dteste,zteste,TBP1)

%%% Gerando relátorio com as informações do processmanto da rede
relatorio(N,xteste,eta,WMED,Ni,Nh,Ns,SSE,TBP,EMAX,EAV,TBP1);

