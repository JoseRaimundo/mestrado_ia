% CEFET/PB/GTEMA, Joao Pessoa, 18/10/2005.
% ARQUITETURA: REDE RBF - Radial Basis Function
% CONFIGURACAO: UM NEUR�NIO DE ENTRADA - UM NEUR�NIO DE SA�DA LINEAR
% ALGORITMO: BACKPROPAGATION
% APLICACAO: Treinamento e Teste em Aproxima��o de Fun��es
% AUTOR: Dr. PAULO HENRIQUE DA FONSECA SILVA

clear all, close all, clc,help mlpbp_treino.m
epochmax=50000; epochexb=50;
Ni=1; Nh=12; Ns=1; WMED=.01; etat=0.001; etas=0.0001; etav=0.007; 

%CONJUNTO DE TREINAMENTO
load fun_dataset  % N xmax xtreino dtreino xteste dteste   

set(gcf,'Position',[1 33 800 494]); 
axs=axes;
set(axs,'NextPlot','Add','Box','On') 
a=plot(xtreino,dtreino,'ro');set(a,'LineWidth',2)  
xla=xlabel('x'); 
yla=ylabel('d');
tit=title('Conjunto de Treinamento: (x, d)');
leg=legend([num2str(N) ' Exemplos de treinamento' ]);
set(axs,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
pause(2),close

  % INICIALIZA��O DOS PESOS
  V=randn(Ns,Nh+1).*WMED;
  
  % INICIALIZA��O DOS CENTROS VARIA
  % ESCOLHIDOS ALEATORIAMENTE DO CONJUNTO DE TREINAMENTO
  idx=randperm(Nh);
  for j=1:Nh
   t(j)=xtreino(idx(j));
  end 
  
  % INICIALIZA��O DAS LARGURAS 
  % IGUAIS PARA TODAS AS RBFs 
  DEmax=0;
  for j=1:Nh
   for i=1:Nh
    if i>j
     DE=(t(i)-t(j))^2;
     if DE>DEmax
      DEmax=DE;
     end
    end
   end
  end
  
  sigma=rand([1,Nh]).*((DEmax^2)/Nh)*100;
  
  % �POCAS DE TREINAMENTO
  to=clock; 
  for epoca=1:epochmax
     
    % GERA��O DE �NDICES ALEAT�RIOS E APRESENTA��O DE EXEMPLOS DE TREINAMENTO
    
    idc=randperm(N);
    E=[];
   
    % APRESENTA��O DE UMA �POCA DE TREINAMENTO PARA A REDE NEURAL
    for n=1:N
      i=idc(n);
      
  % COMPUTA��O NO SENTIDO DIRETO
    xi=xtreino(i);
    d=dtreino(i); 
    norma=(xi-t).^2;  		% x: escalar, t: vetor
    y=[1 exp(-norma./sigma)];
    z(i)=V*y';
     
    % COMPUTA��O NO SENTIDO REVERSO
    e=d-z(i); E(n)=0.5*e^2;
    
    % AJUSTE DOS PESOS, CENTROS E LARGURAS DA REDE RBF
    t=t+(2*etat*e).*V(2:Nh+1).*y(2:Nh+1).*(xi-t)./(sigma.^1);
    sigma=sigma+(etas*e).*V(2:Nh+1).*y(2:Nh+1).*norma./(sigma.^2);
    V=V+(etav*e).*y;    
    end
    
    SSE(epoca)=sum(E)/N;
    if epoca==1
      set(gcf,'Position',[1 33 800 494]); 
      axs=axes;
      set(axs,'NextPlot','Add','Box','On') 
      a=plot(xtreino.*xmax,dtreino,'bo',xtreino.*xmax,z,'k',0,0,'w');set(a,'LineWidth',2)  
      xla=xlabel('xi'); 
      yla=ylabel('yj');
      tit=title('Treinamento: RBF - M�todo do Gradiente');
      eptxt=num2str(epoca);
      SSEtxt=num2str(SSE(epoca));
      leg=legend('Conjunto de treinamento','Sa�da da rede RBF',['Eav(' eptxt ') = ' SSEtxt]);
      set(axs,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
    set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
    elseif rem(epoca,epochexb)==0
      delete(a); delete(leg)
      a=plot(xtreino.*xmax,dtreino,'bo',xtreino.*xmax,z,'k',0,0,'w');set(a,'LineWidth',2)  
      eptxt=num2str(epoca);
      SSEtxt=num2str(SSE(epoca));
      leg=legend('Conjunto de treinamento','Sa�da da rede RBF',['Eav(' eptxt ') = ' SSEtxt]);
      set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
    end
    drawnow;
  end
 TFBP=etime(clock,to);	
 pause,close
 
 set(gcf,'Position',[1 33 800 494],'Color',[1 1 1]);
 se=semilogy(1:length(SSE),SSE,0,0,'w',0,0,'w',0,0,'w',0,0,'w');set(se,'LineWidth',2); grid on;
 set(se,'LineWidth',2);    
 leg=legend('Erro m�dio quadr�tico - Eav',['�pocas de treinamento = ' num2str(epoca)],...
 ['Dura��o do treinamento = ' num2str(TFBP/60) ' minutos'],...
 ['Eav(m�nimo) = ' num2str(min(SSE))],['Eav (final) = ' num2str(SSE(epoca))]); 
 xla=xlabel('�pocas de treinamento'); yla=ylabel('Eav - Erro m�dio quadr�tico');
 tit=title('Desempenho da rede RBF');
 set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
 set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
 set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
 set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
 pause, close
  
  % TESTE DA REDE RBF

  % COMPUTA��O NO SENTIDO DIRETO
  for n=1:length(xteste)
     xi=xteste(n);
     norma=(xi-t).^2;  		% x: escalar, t: vetor
    y=[1 exp(-norma./sigma)];
    zteste(n)=V*y'; 
  end
  eteste=abs(dteste-zteste);
  Emax=max(eteste);
  Eav=sum(eteste.^2)./(2*length(eteste));
  set(gcf,'Position',[1 33 800 494]); 
  axs=axes;
  set(axs,'NextPlot','Add','Box','On') 
  a=plot(xteste.*xmax,dteste,'r.',xteste.*xmax,zteste,'k');set(a,'LineWidth',2)  
   leg=legend('Conjunto de teste', 'Sa�da da rede RBF',...
   ['Erro absoluto m�ximo : ' num2str(Emax)],['Erro m�dio quadr�tico: ' num2str(Eav)]);
   xla=xlabel('xi'); 
   yla=ylabel('yj');
   tit=title('Generaliza��o: yj=F(xi,tj,sigma,Vj)');
   set(axs,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
   set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
    
disp('REDE RBF -  ALGORITMO M�TODO DO GRADIENTE')
disp('__________________________________________________________________________')

  
disp('RELAT�RIO DE PROJETO');
disp(['Exemplos de Treinamento: ' num2str(N)]);
disp(['Exemplos de Teste: ' num2str(length(xteste))]);
disp(['Taxa de aprendizado:' num2str(etav)]);
disp(['Pesos, valor m�dio inicial:' num2str(WMED)]);
disp('Configura��o:'); 
disp('Camada       / N�mero de Neur�nios');
disp (['Entrada        / ' num2str(Ni)]);
disp(['Escondida  / ' num2str(Nh)]);
disp(['Sa�da           / ' num2str(Ns)']);         
disp('Treinamento:');
disp(['N�mero de �pocas: ' num2str(epoca)]);
disp(['Erro m�dio quadr�tico : ' num2str(SSE(epoca))]);
disp(['Dura��o: ' num2str(TFBP) ' s']);
disp('Generaliza��o:');
disp(['Erro absoluto m�ximo : ' num2str(Emax)]);
disp(['Erro m�dio quadr�tico: ' num2str(Eav)]);   
save rbfbp_netdata.mat N NT etat etas etav WMED Ni Nh Ns SSE TFBP Emax Eav t sigma V   



