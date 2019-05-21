

% CEFET/PB/GTEMA, Joao Pessoa, 18/10/2005.
% PROJETO DE REDES NEURAIS SEM REALIMENTACÄO 
% ARQUITETURA: REDE MLP - Multilayer Perceptrons
% CONFIGURACÄO: UMA CAMADA OCULTA - UM NEURÔNIO DE SAÍDA LINEAR
% ALGORITMO: BACKPROPAGATION
% APLICACAO: Aproximaçäo de Funçöes
% AUTOR: Dr. PAULO HENRIQUE DA FONSECA SILVA

clear all, close all, clc,help mlp_backpropagation.m, global grafico legenda

to=clock; epochmax=20000; epochexb=100; Ni=2; Nh=15; Ns=1; WMED=.07; eta=0.01; 

load fun_dataset;  % N xmax xtreino dtreino xteste dteste  
x = linspace(0,1.5)*2;
y = 8.^sin(x);
cont = 1
for valor=1:99
    if mod(valor,2) == 1
        dtreino(cont) = y(valor);
        dteste(cont) = y(valor);
        zteste(cont) = y(valor);
        cont = cont + 1;
    end
end
dtreino(cont) = y(valor);
dteste(cont) = y(valor);
zteste(cont) = y(valor);

% grafico_dataset(xtreino,dtreino);

% NT = 5000; %5000
% xmax = 1; %6
%%% fun_dataset contem:
%%% --> xtreino - conjunto de treinamento 

%%% Gráfico que exite a curva do sinal gerado com as entradas fornecidas
% grafico_dataset(xtreino,dtreino);

Wji=rand(Nh,Ni).*WMED; 
Wkj=rand(Ns,Nh+1).*WMED;

%%% Alimentando com valores aleatórios entre 0.001 e 1 
beta_j = 0.01 * [0:1/50:1];
alfa_j  = 0.01 * [0:1/50:1];
k_j     = 0.01 * [0:1/50:1];

for epoca=1:epochmax
    
    E=[]; 
    deltaWkj=0; 
    deltaWji=0;

    for i=1:N
      xi=[-1 xtreino(i)]; 
      d=dtreino(i); 
      netj=Wji*xi';  
      %yj=(1)./(1+exp(-netj'));
      yj = alfa_j(i) .* (1 - beta_j(i) .* exp(-k_j(i) .* netj'));
      z(i)=Wkj*[-1 yj]';
      e=d-z(i); 
      etae=-eta*e;  
      deltaWkj=deltaWkj-etae*[-1 yj];
      deltaWji=deltaWji-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi; 
      E(i)=0.5*e^2; 
      
      for key = 1:Nh
          alfa_j(i) = -etae * (1- beta_j(i) .* exp(-k_j(i) .* netj(key)));
          beta_j(i) = etae  * (alfa_j(i) .* exp(-k_j(i) .*  netj(key)));     
          k_j(i)    = -etae * (beta_j(i) .*  netj(key) .* exp(-k_j(i) .*  netj(key)));
      end
      
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
   % yj=(1)./(1+exp(-netj'));        
    yj = alfa_j(n) .* (1 - beta_j(n) .* exp(-k_j(n) .* netj'));
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

