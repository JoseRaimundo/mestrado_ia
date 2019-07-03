% Campina Grande, 02 de novembro de 2000.
			
% Contornos de Decisão para o caso bodimensional.
% entradas: [x1 x2]    
% saída: y=1  (classe C1) 
%        y=-1 (classe C2).
clear all; clc; clf; close all; 
ss = get(0, 'ScreenSize');
Fig1=figure(1);
set(Fig1,'Position',[ss(1) ss(2) ss(3) ss(4)],'Color',[1 1 1],'NextPlot','add');
for repete=1:100
 roi=400;
 ctr=0; clin=0;		% CONTROLE
 xma=0; xmb=120;	% VALORES MÉDIOS
 xva=27; xvb=xva;	% DESVIOS MÉDIOS
 N=100;             % NÚMERO DE EXEMPLOS DE TREINAMENTO
 Nteste=2000;		% NÚMERO DE EXEMPLOS DE TESTE 
 Wini=1e-6;         % VALOR MÉDIO DOS PESOS INICIAIS ALEATÓRIOS
 TA=.000005;		% TAXA DE APRENDIZADO
 epochmax=200;		% MÁXIMO NÚMERO DE ÉPOCAS
 CP=0; CP1=0;	    % CRITÉRIO DE PARADA 
 W=[]; 	W1=[];		% PESOS SINÁPTICOS

 if repete>1, clf;end
 
 
 x1a=xma+xva.*randn([1,N]); 
 x2a=xma+xva.*randn([1,N]);
 x1b=xmb+xvb.*randn([1,N]);
 x2b=xmb+xvb.*randn([1,N]);
 hold on
a= plot(x1a,x2a,'ro',x1b,x2b,'b+');
set(a,'markersize',12,'linewidth',4); 
xlabel('x1'),ylabel('x2'), title('Contornos de Decisão (Perceptron de Rosenbllat)','Color',[0 0 0]);
axis equal
box on 
axis(roi.*[-1 1 -1 1])


%set(ax,'XColor',[0 0 0],'YColor',[0 0 0],'Box','On');
xmin=-roi;
xmax=roi;

 % ALGORITMO DE CONVERGÊNCIA DO PERCEPTRON
 
 % EXEMPLOS DE TREINAMENTO
 x=[[x1a x1b]' [x2a x2b]'];   
 d=[ones([1,N]) -ones([1,N])];
 
  
 
 % ALGORITMO DE ROSENBLLAT
 iter=0;
 
 % INICIA PESOS
 W=randn([1,3]).*1E-2;
 CP1=0; 
 for epoca=1:epochmax

  % GERAÇÃO DE UM CONJUNTO DE INTEIROS ALEATÓRIOS
  idc=randperm(2*N);

  % APRESENTA CONJUNTO DE TREINAMENTO
  CP=0;
  for n=1:(2*N)
   xt=[-1 x(idc(n),1) x(idc(n),2)]; 
    
   y=sign(W*xt'); 
   %y=(W*xt'); 
   % ADAPTAÇÃO DOS PESOS  
   ajuste=TA*(d(idc(n))-y).*xt;
   W=W+ajuste;

   if max(ajuste)==0, CP=CP+1; end

   % GRÁFICO DOS CONTORNOS DE DECISÃO
   x11=[xmin xmax];
   x22=(W(1)-W(2).*x11)./W(3);
  end
  
  if CP==2*N, CP1=CP1+1; end
  
  %if max(x22)<(2*xmax),
   if clin>5, delete(linha(clin-5)), end
   clin=clin+1; 
   linha(clin)=line(x11,x22); 
   set(linha(clin),'Linewidth',3,'Color',[0 0 0]);
   if clin>1,set(linha(clin-1),'Linewidth',1,'Color',[.7 .7 .7]);end 
   xlabel('x1'),ylabel('x2'), 
   title(['Contornos de Decisão (Perceptron de Rosenblatt) ' num2str(epoca)],'Color',[0 0 0]);
   drawnow 
   pause(.05),
   
  %end
  if CP1>15, pause(1),break, end
 end

 % TESTE DO PERCEPTRON / GENERALIZAÇÃO

 teste1=randn([1,Nteste]).*xmax;
 teste2=randn([1,Nteste]).*xmax;
 m=0; p=0; xa1=[]; xa2=[]; xb1=[]; xb2=[];
 for n=1:Nteste
  xteste=[-1 teste1(n) teste2(n)]; 
  y=sign(W*xteste'); 
 %y=(W*xteste'); 
  
  if y==1
   m=m+1; xa1(m)=teste1(n); xa2(m)=teste2(n);
  elseif y==-1
   p=p+1; xb1(p)=teste1(n); xb2(p)=teste2(n);
  end
 end
 
 a= plot(xa1,xa2,'ro',xb1,xb2,'b+');
 set(a,'markersize',8,'linewidth',2); 
 
 pause(4),drawnow
end