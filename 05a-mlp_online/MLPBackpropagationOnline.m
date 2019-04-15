%%% Descrição
%%% Este código implementa uma rede neural MLP com alimentação, abordagem em betch
%%% Comandos de inicialização do matlab - ignore
clear all, close all, clc,help mlp_backpropagation.m, global grafico legenda

%%% 
to=clock;       %% Usado para calcular o tempo de processamento - ignore
epochexb=100;   %% Quantidade de épocas ilustradas no gráfico - ignore

epochmax=20000; %% Quantidade máxima de épocas

%%% Dimensões das matrizes dos pesos
Ni=2; 
Nh=15; 
Ns=1; 

%%% Bias
WMED=.07; 
eta=0.01; 

load('fun_dataset.mat');


Wji=rand(Nh,Ni).*WMED; 
Wkj=rand(Ns,Nh+1).*WMED;
E = 0;
i = 0;

z = [];
exibi_epoca = 0;
for epoca=1:epochmax * N
    i = i + 1;
    xi=[-1 xtreino(i)]; 
    d=dtreino(i); 
    netj=Wji*xi';  
    yj=(1)./(1+exp(-netj'));  
    z(i)=Wkj*[-1 yj]';
    e=d-z(i); 
    etae=-eta*e;  
    E = 0.5*e^2; 
    
    Wkj=Wkj+(-etae*[-1 yj]);
    Wji=Wji+(-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi); 
     
    
    if i == 51 
        exibi_epoca = exibi_epoca + 1;
        SSE(exibi_epoca)=sum(E)/N; 
        grafico_treino(xtreino, xmax, dtreino, z, exibi_epoca,epochexb, SSE(exibi_epoca));
        i = 0;
    end;
    
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
grafico_teste(xteste,xmax,dteste,zteste,TBP1)

%%% Gerando relátorio com as informações do processmanto da rede
relatorio(N,xteste,eta,WMED,Ni,Nh,Ns,SSE,TBP,EMAX,EAV,TBP1);

