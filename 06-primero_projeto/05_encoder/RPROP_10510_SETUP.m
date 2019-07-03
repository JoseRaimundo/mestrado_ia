% CEFET/PB/GTEMA, Joao Pessoa, 8/11/2005.
% PROJETO DE REDES NEURAIS SEM REALIMENTACÄO 
% ARQUITETURA: REDE MLP - Multilayer Perceptrons 
% CONFIGURACÄO: UMA CAMADA OCULTA - Ns NEURÔNIOS DE SAÍDA SIGMÓIDE
% ALGORITMO: RPROP 
% APLICACAO: Codificaçäo Ortogonal 10-5-10 (SETUP)
% AUTOR: Dr. PAULO HENRIQUE DA FONSECA SILVA
clear all, close all, clc,help rprop_10510.m, global grafico legenda
epochmax=50; epochexb=1; 
Ni=11; Nh=5; Ns=10; WMED=1; DELTA0=1; TA1=1.2; TA2=0.5; TAMIN=1E-6; TAMAX=1; 
load encoder10510_dataset;  % xtreino dtreino 
Wji=randn(Nh,Ni).*WMED; Wkj=randn(Ns,Nh+1).*WMED;
TAWji=ones(Nh,Ni).*DELTA0;       TAWkj=ones(Ns,Nh+1).*DELTA0;
for epoca=1:epochmax
    E=[]; grWkj=0; grWji=0; deltaWji=zeros(size(Wji)); deltaWkj=zeros(size(Wkj));
    for n=1:N
      xi=[-1 xtreino(n,:)]'; d=dtreino(n,:); netj=Wji*xi;  yj=(1)./(1+exp(-netj'));  
      netk=Wkj*[-1 yj]';
      z=(1)./(1+exp(-netk));  
      for u=1:Ns
          if z(u)>0.6,  Z(n,u)=1; 
          elseif z(u)<0.4,  Z(n,u)=0; 
          else, Z(n,u)=z(u); end
      end
      e=d'-z; 
      gradz=-e.*(z.*(1-z));  
      grady=(yj.*(1-yj)).*(gradz'*Wkj(:,2:Nh+1)); 
      grWkj=grWkj+gradz*[-1 yj]; 
      grWji=grWji+grady'*xi';  
      E(n)=0.5*sum((d-Z(n,:)).^2)/Ns; 
    end
    MSE=sum(E)/N;    SSE(epoca)=MSE;
    if rem(epoca,epochexb)==0,
      encoder10510_plot; pause(1)
    end
    if MSE==0, break; end
   if epoca==1
    Wkj=Wkj-DELTA0.*grWkj; 
    Wji=Wji-DELTA0.*grWji; 
    encoder10510_plot
    gWji=sign(grWji); 
    gWkj=sign(grWkj);
    
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
      else, gWji(i,j)=0;  deltaWji(i,j)=-deltaWji0(i,j);end
    end,end
    
    for i=1:q,  for j=1:r,
      if DV(i,j)<0,       TAWkj(i,j)=min([TAWkj(i,j)*TA1  TAMAX]); 
      elseif DV(i,j)>0,   TAWkj(i,j)=max([TAWkj(i,j)*TA2 TAMIN]);       end
      if DV(i,j)<=0,      deltaWkj(i,j)=-TAWkj(i,j)*(gWkj(i,j));
      else, gWkj(i,j)=0;  deltaWkj(i,j)=-deltaWkj0(i,j);end
    end,end
    Wkj=Wkj+deltaWkj;
    Wji=Wji+deltaWji;
end
gWji0=gWji; gWkj0=gWkj;  deltaWji0=deltaWji; deltaWkj0=deltaWkj; 
end
