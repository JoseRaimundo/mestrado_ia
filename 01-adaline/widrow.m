% Campina Grande, 03 de novembro de 2000.
% Rede PERCEPTRON E ADALINE como CLASSIFICADORES DE PADRÕES
% Contornos de Decisão para o caso bodimensional.
% entradas: [x1 x2]    
% saídas: y1>y2  (classe C1) 
%         y1<y2  (classe C2).
for run=1:10
    clear all, close all, clc, home
ss = get(0, 'ScreenSize');
Fig1=figure(1);
set(Fig1,'Position',[ss(1) ss(2) ss(3) ss(4)],'Color',[1 1 1],'NextPlot','add');

% EXEMPLO I:

N=100;			% NÚMERO DE EXEMPLOS DE TREINAMENTO
Nteste=2000;		% NÚMERO DE EXEMPLOS DE TESTE 
Wini=randn([1,3]).*1E-6;	% VALOR MÉDIO DOS PESOS INICIAIS ALEATÓRIOS
TA=.0007;			% TAXA DE APRENDIZADO
epochmax=100;		% MÁXIMO NÚMERO DE ÉPOCAS
xma=0; xmb=1;		% VALORES MÉDIOS
xva=.27; xvb=xva;	% DESVIOS MÉDIOS
% MSE			% MEAN SQUARED ERROR

x1a=xma+xva.*randn([1,N]); 
x2a=xma+xva.*randn([1,N]);	% CLASSE A
x1b=xmb+xvb.*randn([1,N]);
x2b=xmb+xvb.*randn([1,N]);	% CLASSE B

% EXEMPLOS DE TREINAMENTO
x=[[x1a x1b]' [x2a x2b]'];   

d=[ones([1,N]) -ones([1,N])];

xmin=-1;
xmax=2;



% ADALINE


% GRÁFICO DO CONJUNTO DE TREINAMENTO

a=plot(x1a,x2a,'bo',x1b,x2b,'r+'); 
set(a,'markersize',12,'linewidth',4); 
xlabel('x1'),ylabel('x2'), title('Contornos de Decisão (ADALINE)','Color',[0 0 0]);
axis([-1 2 -1 2])
axis square
pause(4)

[SSEadaline,Wadaline]=adaline(x,d,TA,epochmax,Wini)  

% GRÁFICO DOS CONTORNOS DE DECISÃO
idex=length(Wadaline); linha=[];
x11=[xmin xmax];

% x22=(Wadaline(idex,1)-Wadaline(idex,2).*x11)./Wadaline(idex,3);
% linha=line(x11,x22); 
% set(linha,'Linewidth',2,'Color',[0 0 0]);

lin=[];
for f=1:idex
 x22=(Wadaline(f,1)-Wadaline(f,2).*x11)./Wadaline(f,3);
 linha(f)=line(x11,x22); 
 set(linha(f),'Linewidth',2,'Color',[0 0 0]); 
 if (f>1) , delete(linha(f-1)); end
 pause(.1); drawnow;
end

disp(['Número de Contornos' num2str(idex)]);
ctn=1;

% for f=1:length(ctn)
%  x22=(Wadaline(ctn(f),1)-Wadaline(ctn(f),2).*x11)./Wadaline(ctn(f),3);
%  lin(f)=line(x11,x22); 
%  set(lin(f),'Linewidth',1,'Color',[0 0 0]); 
% end
axis([-1 2 -1 2])
pause(2)
end
