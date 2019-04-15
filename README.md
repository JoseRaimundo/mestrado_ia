### Forma de usar os códigos

Cada atividades possuí dependências de funções presentes no do código base. Para utilizar, basta adicionar o código da atividades dentro da pasta com o código base (00x-xxxx_sourse), e executar normalmente a partir do arquivo da atividade.

### Entendendo o código base MLP


Abaixo está o código fornecido e explicado detalhadamente, apenas o código funcional da rede foi mantido, o restante (relatórios, gráficos e etc) foi removido para reduzir a explicação. As linhas que iniciam com **%%%** Correspondem a comentários, e não são executadas pelo MATLAB.


	epochexb=100;   %% Quantidade de épocas ilustradas no gráfico - ignore

	epochmax=20000; %% Quantidade máxima de épocas
	%%% Dimensões das matrizes dos pesos
	Ni=2; Nh=15; Ns=1; 

	%%% Bias
	WMED=.07; 
	eta=0.01; 

	%%% Carregamento dos dados de entrada a partir do arquivo fornecido
	load fun_dataset; 
	%%% fun_dataset contem:
	%%% --> xtreino - conjunto de treinamento 

	%%% Pesos da redes = Alimentação dos pesos com valores aleatáorios
	Wji=randn(Nh,Ni).*WMED; 
	Wkj=randn(Ns,Nh+1).*WMED;

	%%% Entrada das epocas de treinamento
	for epoca=1:epochmax
	    %%% Variáveis locais para erro  e acumulo do ajuste dos pesos
	    E=[]; 
	    deltaWkj=0; 
	    deltaWji=0;
	    
	    %%% Entrada dos exemplos (alimentação dos neuronios um por vez)
	    for i=1:N
	      %%% xi recebe uma entrada de treinamento da base de dados fornecida por vez
	      xi=[-1 xtreino(i)]; 
	      %%% d recebe a respectiva saída em relação a xi
	      d=dtreino(i); 
	      %%% netj recebe seus pesos sinápticos, que é a o valor de x vezes o pesos das suas conexões (entre cada neuronio)
	      netj=Wji*xi';  
	      %%% yj recebe o valor obtido pela função de ativação
	      yj=(1)./(1+exp(-netj'));  
	      %%% z recebe a saída do neuronio atual
	      z(i)=Wkj*[-1 yj]';
	      %%% e recebe o erro, que corresponde à saída esperada menos a saída obetida
	      e=d-z(i); 
	      %%% etae recebe o erro local multiplicado mais o bias 
	      etae=-eta*e;  
	      %%% Acumulando o valor de ajuste para o peso sináptico
	      deltaWkj=deltaWkj-etae*[-1 yj];
	      deltaWji=deltaWji-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi; 
	      %%% Erro quadrático de cada entrada
	      E(i)=0.5*e^2; 
	    end
	    
	    %%% Atualizando o pesos sináptico da conecção do neuronio k para j e do neuronio j para i
	    Wkj=Wkj+deltaWkj; 
	    Wji=Wji+deltaWji;

	    %%% Acumundo o erro global
	    SSE(epoca)=sum(E)/N;    
	end

	%%% Realizando teste da rede com os pesos sinápticos Wji e Wkj já ajustados no treinamento
	for n=1:length(xteste)
	    xi=[-1 xteste(n)]';     
	    netj=Wji*xi;    
	    yj=(1)./(1+exp(-netj'));        
	    zteste(n)=Wkj*[-1 yj]';
	end

