


# Teoria
## Introdução
### Inteligência Computacional
### Tipos de Aprendizado
### Tipo de Treinamento 
## Redes Neurais
### Neurônio Artificial
### Conceito de Redes Neurais
### Rede MLP

E(n)=\frac{1}{2Q}\sum_{q=1}^{Q}e_{q}^{2}(n)


### Rede RBF




# Prática
Nesta seção são abordadas as práticas codificadas em MATLAB.

### Indices de atividades

|Atividade  |Descrição  |Data |
|--|--|--|
|Alterar 1-a|  Alterar a taxa de ruído do algoritmo Adaline e observar a taxa de acerto no processo de identificação de dígitos||
|Alterar 1-b|  Alterar a entrada de dígitos para letras (de A até J) e modificar a taxa de ruído, observar a taxa de acerto||
|Alterar 2|  Alterar a função de alimentação no exemplo da rede MLP para uma função própria e não-linear||
|Alterar 3|  Alterar a função de ativação do algoritmo para uma fornecida (função fornecida - monomolecular)||
|Alterar 4|  Alterar a função de alimentação no exemplo da rede RBF para uma função própria e não-linear||
|Alterar 5|  Alterar a abordagem de aprendizado do algoritmo fornecido de RBF-> Para treinamento online e MLP->Para treinamento em batch||

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




## Synchronize a file

Once your file is linked to a synchronized location, StackEdit will periodically synchronize it by downloading/uploading any modification. A merge will be performed if necessary and conflicts will be resolved.

If you just have modified your file and you want to force syncing, click the **Synchronize now** button in the navigation bar.

> **Note:** The **Synchronize now** button is disabled if you have no file to synchronize.

## Manage file synchronization

Since one file can be synced with multiple locations, you can list and manage synchronized locations by clicking **File synchronization** in the **Synchronize** sub-menu. This allows you to list and remove synchronized locations that are linked to your file.







