% Campina Grande, 03 de novembro de 2000.
% Rede MLP como CLASSIFICADOR DE PADRÕES
% Contornos de Decisão para o caso bidimensional.
% entradas: [x1 x2]    
% saídas: y1>y2 e d=[1 0] => (classe C1) 
%         y1<y2 e d=[0 1] => (classe C2).

clear all, close, clc, home, format short e 
xva=1; 			    % DESVIO MÉDIO DO CONJUNTO DE TREINAMENTO
exemplos=500;		% NÚMERO DE EXEMPLOS DE TREINAMENTO
Nteste=100;		  % NÚMERO DE EXEMPLOS DE TESTE
Wini=1e-6;		  % VALOR MÉDIO P/ PESOS INICIAIS ALEATÓRIOS
TA=.25;			    % TAXA DE APRENDIZADO
epochmax=500;		% MÁXIMO NÚMERO DE ÉPOCAS
epochexb=1;
CP=0; CP1=0;	  % CRITÉRIO DE PARADA 
W=[]; 	W1=[];	% PESOS SINÁPTICOS
X=[]; D=[]; q=0;% EXEMPLOS DE TREINAMENTO
Ni=3;			      % - # de Entradas
Nh=7; 			    % - # de Unidades Ocultas
Ns=2; 			    % - # de Saídas
WMED=1E-4;		  % VALOR MÉDIO DOS PESOS INICIAIS ALEATÓRIOS
figpos=[1 49 1024 634];
set(gcf,'units','Pixels','Position',figpos,'Color',[1 1 1]);
ax=axes; 

% CONJUNTO DE TREINAMENTO

% GERA DUAS CLASSES COM CONTORNO CIRCULAR
x1 =xva.*randn([1,exemplos]); 
x2 =xva.*randn([1,exemplos]); 
x3 =2*xva.*randn([1,2*exemplos]); 
x4 =2*xva.*randn([1,2*exemplos]); 
% EXEMPLOS DE TREINAMENTO

m=0; 
p=0; 
xa1=[]; 
xa2=[]; 
xb1=[]; 
xb2=[];

for n=1:exemplos
    if sqrt(x1(n)^2+x2(n)^2)>1
        m=m+1; 
        xa1(m)=x1(n); 
        xa2(m)=x2(n); 
        D(n,:)=[1 0];
    else
        p=p+1; 
        xb1(p)=x1(n); 
        xb2(p)=x2(n); 
        D(n,:)=[0 1];
    end
    X(n,:)=[-1 x1(n) x2(n)];
end

% TREINAMENTO DO PMC PELO ALGORITMO DA BACKPROPAGATION
carry(31); disp('__________________________________________________________')
disp('Fase de treinamento, aguarde . . .'),carry(1),pause(2)

to=clock; 			% MARCA INICIAL DE TEMPO
SSE=[]; 

% INICIA PESOS E LIMIARES
W=randn(Nh,Ni).*WMED; V=randn(Ns,Nh+1).*WMED;
%W=zeros([Nh,Ni]); V=zeros([Ns,Nh+1]);
% APRESENTAÇÃO DE epochmax ÉPOCAS DE TREINAMENTO PARA A REDE MLP
for epoca=1:epochmax

    % GERAÇÃO DE ÍNDICES ALEATÓRIOS PARA APRESENTAÇÃO DE EXEMPLOS DE TREINAMENTO
    idc=epoche(exemplos);
    E=[];

    % APRESENTAÇÃO DE UMA ÉPOCA DE TREINAMENTO PARA A REDE MLP

    for n=1:exemplos

        % COMPUTAÇÃO NO SENTIDO DIRETO
        x=[X(idc(n),:)]';
        d=D(idc(n),:); 
        nety=W*x;
        y=(1)./(1+exp(-nety'));	% CAMADA OCULTA
        netz=V*[-1 y]';
        z=(1)./(1+exp(-netz));	% CAMADA DE SAÍDA

        % COMPUTAÇÃO NO SENTIDO REVERSO
        e=d'-z;
        gradz=e.*z.*(1-z);
        grady=(y.*(1-y)).*(gradz'*V(:,2:Nh+1));
        V=V+TA.*(gradz*[-1 y]);
        W=W+TA.*(grady'*x');    
        E(n)=0.5*sum(e.^2); 
    end
    SSE(epoca)=sum(E)/exemplos;

    % EXIBE RESULTADOS DE TREINAMENTO
    if epoca == 1, 
        disp('  # de épocas       SSE'); 
    end
    if rem(epoca,epochexb)==0 | epoca==epochmax, 
        disp([epoca SSE(epoca)]); 
    end

    % GRÁFICO DA RESPOSTA DO MLP
    m=0; 
    p=0; 
    x=[]; 
    xa1=[]; 
    xa2=[]; 
    xb1=[]; 
    xb2=[];

    for n=1:(2*exemplos)
        % COMPUTAÇÃO NO SENTIDO DIRETO
        x=[-1 x3(n) x4(n)]';
        nety=W*x;
        y=(1)./(1+exp(-nety'));	% CAMADA OCULTA
        netz=V*[-1 y]';
        z=(1)./(1+exp(-netz));	% CAMADA DE SAÍDA 

        if z(1)>z(2)
            m=m+1; 
            xa1(m)=x3(n); 
            xa2(m)=x4(n); 
        else
            p=p+1; 
            xb1(p)=x3(n); 
            xb2(p)=x4(n); 
        end
    end
    if rem(epoca,epochexb)==0
        ap=plot(xa1,xa2,'b.',xb1,xb2,'ko'); 
        set(ap,'markerSize',11);
        xla=xlabel('x1');
        yla=ylabel('x2'); 
        tit=title(['RESPOSTA DO MLP, época=' num2str(epoca)]);
        set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
        set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
        set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
        axis([-4 4 -4 4]);
        drawnow
    end
end

tf=etime(clock,to);		% TEMPO DE COMPUTAÇÃO DA FASE DE TREINAMENTO
disp('Fim da fase de treinamento !'), 

pause,clf
plot(SSE)
tit=title('Desempenho do MLP - Classificação de Padrões')
set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
xla=xlabel('Épocas de treinamento'); yla=ylabel('MSE');
set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')