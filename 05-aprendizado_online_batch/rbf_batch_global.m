
clear all, close all, clc,help mlpbp_treino.m
epochmax=20000; epochexb=50;
Ni=1; Nh=12; Ns=1; WMED=.01; etat=0.001; etas=0.0001; etav=0.007; 

load fun_dataset  % N xmax xtreino dtreino xteste dteste   

  % INICIALIZAÇÃO DOS PESOS
  V=randn(Ns,Nh+1).*WMED;

  global_v=randn(Ns,Nh+1).*WMED;
  % INICIALIZAÇÃO DOS CENTROS VARIA
  % ESCOLHIDOS ALEATORIAMENTE DO CONJUNTO DE TREINAMENTO
  idx=randperm(Nh);
  for j=1:Nh
   global_t(j)=xtreino(idx(j));
   t(j)=xtreino(idx(j));

  end 
  
  % INICIALIZAÇÃO DAS LARGURAS 
  % IGUAIS PARA TODAS AS RBFs 
  DEmax=0;
  for j=1:Nh
   for i=1:Nh
    if i>j
     DE=(global_t(i)-global_t(j))^2;
     if DE>DEmax
      DEmax=DE;
     end
    end
   end
  end
  
  sigma=rand([1,Nh]).*((DEmax^2)/Nh)*100;

  global_sigma=rand([1,Nh]).*((DEmax^2)/Nh)*100;
  % ÉPOCAS DE TREINAMENTO
  to=clock; 

  for epoca=1:epochmax
    E=[];


    % APRESENTAÇÃO DE UMA ÉPOCA DE TREINAMENTO PARA A REDE NEURAL
    for i=1:N    
      % COMPUTAÇÃO NO SENTIDO DIRETO
        xi=xtreino(i);
        d=dtreino(i); 
        norma=(xi-t).^2;  		% x: escalar, t: vetor
        y=[1 exp(-norma./sigma)];
        z(i)=V*y';

        % COMPUTAÇÃO NO SENTIDO REVERSO
        e=d-z(i); 

        % AJUSTE DOS PESOS, CENTROS E LARGURAS DA REDE RBF
        t=t+global_t+(2*etat*e).*V(2:Nh+1).*y(2:Nh+1).*(xi-t)./(sigma.^1);
        sigma=sigma+global_sigma+(etas*e).*V(2:Nh+1).*y(2:Nh+1).*norma./(sigma.^2);
        V=V+ global_v +(etav*e).*y;
        E(i)=0.5*e^2;
    end
    
    global_sigma = global_sigma + sigma;
    global_t = global_t + t;
    global_v = global_v + V;
    
    SSE(epoca)=sum(E)/N;
    if epoca==1
      set(gcf,'Position',[1 33 800 494]); 
      axs=axes;
      set(axs,'NextPlot','Add','Box','On') 
      a=plot(xtreino.*xmax,dtreino,'bo',xtreino.*xmax,z,'k',0,0,'w');set(a,'LineWidth',2)  
      xla=xlabel('xi'); 
      yla=ylabel('yj');
      tit=title('Treinamento: RBF - Método do Gradiente');
      eptxt=num2str(epoca);
      SSEtxt=num2str(SSE(epoca));
      leg=legend('Conjunto de treinamento','Saída da rede RBF',['Eav(' eptxt ') = ' SSEtxt]);
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
      leg=legend('Conjunto de treinamento','Saída da rede RBF',['Eav(' eptxt ') = ' SSEtxt]);
      set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
    end
    drawnow;
  end
 TFBP=etime(clock,to);	
 pause,close
 
 set(gcf,'Position',[1 33 800 494],'Color',[1 1 1]);
 se=semilogy(1:length(SSE),SSE,0,0,'w',0,0,'w',0,0,'w',0,0,'w');set(se,'LineWidth',2); grid on;
 set(se,'LineWidth',2);    
 leg=legend('Erro médio quadrático - Eav',['Épocas de treinamento = ' num2str(epoca)],...
 ['Duraçäo do treinamento = ' num2str(TFBP/60) ' minutos'],...
 ['Eav(mínimo) = ' num2str(min(SSE))],['Eav (final) = ' num2str(SSE(epoca))]); 
 xla=xlabel('Épocas de treinamento'); yla=ylabel('Eav - Erro médio quadrático');
 tit=title('Desempenho da rede RBF');
 set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
 set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
 set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
 set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
 pause, close
  
  % TESTE DA REDE RBF

  % COMPUTAÇÃO NO SENTIDO DIRETO
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
   leg=legend('Conjunto de teste', 'Saída da rede RBF',...
   ['Erro absoluto máximo : ' num2str(Emax)],['Erro médio quadrático: ' num2str(Eav)]);
   xla=xlabel('xi'); 
   yla=ylabel('yj');
   tit=title('Generalizaçäo: yj=F(xi,tj,sigma,Vj)');
   set(axs,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
   set(leg,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
   set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
    
disp('REDE RBF -  ALGORITMO MÉTODO DO GRADIENTE')
disp('__________________________________________________________________________')

  
disp('RELATÓRIO DE PROJETO');
disp(['Exemplos de Treinamento: ' num2str(N)]);
disp(['Exemplos de Teste: ' num2str(length(xteste))]);
disp(['Taxa de aprendizado:' num2str(etav)]);
disp(['Pesos, valor médio inicial:' num2str(WMED)]);
disp('Configuração:'); 
disp('Camada       / Número de Neurönios');
disp (['Entrada        / ' num2str(Ni)]);
disp(['Escondida  / ' num2str(Nh)]);
disp(['Saída           / ' num2str(Ns)']);         
disp('Treinamento:');
disp(['Número de épocas: ' num2str(epoca)]);
disp(['Erro médio quadrático : ' num2str(SSE(epoca))]);
disp(['Duraçäo: ' num2str(TFBP) ' s']);
disp('Generalizaçäo:');
disp(['Erro absoluto máximo : ' num2str(Emax)]);
disp(['Erro médio quadrático: ' num2str(Eav)]);   
save rbfbp_netdata.mat N NT etat etas etav WMED Ni Nh Ns SSE TFBP Emax Eav t sigma V   
