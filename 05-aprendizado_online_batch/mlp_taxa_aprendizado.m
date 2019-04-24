

clear all, close all, clc,help mlp_backpropagation.m, global grafico legenda

to=clock; epochmax=20000; epochexb=100; Ni=2; Nh=15; Ns=1; WMED=.07; eta=0.01; 

load fun_dataset;  % N xmax xtreino dtreino xteste dteste   
%grafico_dataset(xtreino,dtreino);

Wji=randn(Nh,Ni).*WMED; Wkj=randn(Ns,Nh+1).*WMED;
ajuste_n = 0.2;
ajuste_t = 0.2;
ajuste_k = 0.2;

for epoca=1:epochmax
    
    E=[]; deltaWkj=0; deltaWji=0;
    
    for i=1:N
      xi=[-1 xtreino(i)]; d=dtreino(i); 
      netj=Wji*xi';  yj=(1)./(1+exp(-netj'));  z(i)=Wkj*[-1 yj]';
      e=d-z(i); 
      eta = (ajuste_n * ((1+(ajuste_k/ajuste_n)+(i/ajuste_t))/(1+(ajuste_k/ajuste_n)*(i/ajuste_t)+ajuste_t*(i/ajuste_t)^2)));
      etae=-eta*e;  
      deltaWkj=deltaWkj-etae*[-1 yj];
      deltaWji=deltaWji-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi; 
      E(i)=0.5*e^2; 
    end

    Wkj=Wkj+deltaWkj; Wji=Wji+deltaWji;
  
    SSE(epoca)=sum(E)/N;    grafico_treino(xtreino,xmax,dtreino,z,epoca,epochexb,SSE(epoca));
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
