% CEFET/PB/GTEMA, Joao Pessoa, 18/10/2005.
% PROJETO DE REDES NEURAIS SEM REALIMENTACÄO 
% ARQUITETURA: REDE MLP - Multilayer Perceptrons
% CONFIGURACÄO: UMA CAMADA OCULTA - UM NEURÔNIO DE SAÍDA LINEAR
% ALGORITMO: REGRA DELTA-DELTA
% APLICACAO: Aproximaçäo de Funçöes
% AUTOR: Dr. PAULO HENRIQUE DA FONSECA SILVA
clear all, close all, clc,help mlprprop.m, global grafico legenda
to=clock; epochmax=2000; epochexb=5; Ni=3; Nh=17; Ns=1; WMED=0.05; 
eta=1e-7; TA1=1.2; TA2=0.5; 
TAMIN=1E-7; TAMAX=.1; 
load mesfet_dataset;  % xmax dmax xtreino dtreino par
NP=length(par); N=length(dtreino); NC=N/NP;
X=xtreino(1:NC,1).*xmax; D=dtreino.*dmax;

grafico2D_dataset(xtreino(1:NC,1).*xmax,dtreino.*dmax);
Wji=randn(Nh,Ni).*WMED; Wkj=randn(Ns,Nh+1).*WMED;
Wji(1,:)=zeros(size(Wji(1,:))); Wkj(1,:)=zeros(size(Wkj(1,:)));
TAWji=ones(Nh,Ni).*eta;       TAWkj=ones(Ns,Nh+1).*eta;
save rpropini.mat Wji Wkj 
for epoca=1:epochmax
    E=[]; grWkj=0; grWji=0; deltaWji=zeros(size(Wji));; deltaWkj=zeros(size(Wkj));
    for n=1:N
      xi=[-1 xtreino(n,:)]'; d=dtreino(n,:); netj=Wji*xi;  yj=(1)./(1+exp(-netj'));  
      NETkj=Wkj.*[-1 yj];
      z(n)=sum(NETkj);
      e=d-z(n);
      gradz=-e;  
      grady=(yj.*(1-yj)).*(gradz.*Wkj(:,2:Nh+1)); 
      grWkj=grWkj+gradz*[-1 yj]; 
      grWji=grWji+grady'*xi';  
      E(n)=0.5*e^2;
    end
    SSE(epoca)=sum(E)/N;    
    if rem(epoca,epochexb)==0,
      grafico2D_treino(X,D,z.*dmax,NC,NP,epoca,SSE(epoca));
    end
    
   if epoca==1
    Wkj=Wkj-eta.*grWkj; 
    Wji=Wji-eta.*grWji; 
    grafico2D_treino(X,D,z.*dmax,NC,NP,epoca,SSE(epoca));
    gWji=grWji; 
    gWkj=grWkj;
    
   elseif epoca>1
    gWji=sign(grWji);  
    gWkj=sign(grWkj);
    
    DW=-gWji.*gWji0;     
    DV=-gWkj.*gWkj0;
   
    [m p]=size(Wji); [q r]=size(Wkj);

    for i=1:m,  for j=1:p,
      if DW(i,j)<0,       TAWji(i,j)=min([TAWji(i,j)*TA1 TAMAX]); 
      elseif DW(i,j)>0,   TAWji(i,j)=max([TAWji(i,j)*TA2 TAMIN]);       end
      if DW(i,j)<=0,      deltaWji(i,j)=-TAWji(i,j)*(gWji(i,j));
      else, gWji(i,j)=0;  end
    end,end
    
    for i=1:q,  for j=1:r,
      if DV(i,j)<0,       TAWkj(i,j)=min([TAWkj(i,j)*TA1  TAMAX]); 
      elseif DV(i,j)>0,   TAWkj(i,j)=max([TAWkj(i,j)*TA2 TAMIN]);       end
      if DV(i,j)<=0,      deltaWkj(i,j)=-TAWkj(i,j)*(gWkj(i,j));
      else, gWkj(i,j)=0;  end
    end,end
    Wkj=Wkj+deltaWkj;
    Wji=Wji+deltaWji;
end
gWji0=gWji; gWkj0=gWkj;  
end
TDD=etime(clock,to)/60;	grafico_sse(SSE,TDD);
save mlp_rprop.mat SSE Wji Wkj  
to=clock; 
X1=xteste(1:NC,1).*xmax;
for n=1:length(xteste)
    xi=[-1 xteste(n,:)]';     netj=Wji*xi;     yj=(1)./(1+exp(-netj'));        zteste(n)=sum(Wkj.*[-1 yj]);
end
TDD1=etime(clock,to);
grafico2D_teste(X,D,z.*dmax,NC,NP,epoca,SSE(epoca),X1,zteste.*dmax)
 
