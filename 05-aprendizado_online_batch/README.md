
## Atividade 5
### 1 - Alterar formas de treinamento
Alterar a forma de treinamento do algoritmo MLP (originalmente como batch) para treinamento online, e alterar a forma de treinamento do algoritmo RBF (originalmente online) para batch, e comparar o ajuste da curva do original com a versão modificada.


#### 1.1 - Abordagem utilizada para modificar o MLP Batch para online: 

Foi eliminado o segundo laço da da etapa de treinamento do algoritmo original e compensando as interações adicionando **N** vezes de Interações na época, também foi adicionado um contador **i** que é zerado por um **if** quando chega a um valor de 50, para evitar que o algoritmo tente utilizar um exemplo que não existe (fora do conjunto de treinamento que possuí 50 exemplos), o **if** também evita que o programa trave ao atualizar o gráfico [Código completo aqui](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/MLPBackpropagationOnline.m). 

    for epoca=1:epochmax * N %% Compensando interações do laço internet
		i = i + 1;
		...
		Wkj=Wkj+(-etae*[-1 yj]);
		Wji=Wji+(-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi);
		if i == 51 %% Atualizando o gráfico de ajuste da curva
			exibi_epoca = exibi_epoca + 1;
			SSE(exibi_epoca)=sum(E)/N;
			grafico_treino(xtreino, xmax, dtreino, z, exibi_epoca,epochexb, SSE(exibi_epoca));
			i = 0;
		end;
	end


#### 1.2 - Abordagem utilizada para modificar o RBF online para Batch: 
Foi eliminado a indexação aleatória dos exemplos e criado uma alimentação (conjunto de exemplos) de tamanho estático, essa alimentação é apresentada ao algoritmo por um novo laço adicionado dentro do laço que interage as épocas, também foi adicionado variáveis globais que ajudam no armazenamento do ajuste da variáveis **t**, **v** e **Sigma**. Estas variáveis são incrementadas a cada época com os valores de variáveis locais, que por sua vez se ajustam continuamente durante o treinamento. [Código compleo aqui](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/rbf_batch.m)

	%% Variáveis globais
	global_t = 0;
	global_v = 0;
	global_sigma = 0;

	for epoca=1:epochmax
		for i=1:N
			...
			% AJUSTE DOS PESOS, CENTROS E LARGURAS DA REDE RBF

			t=t+(2*etat*e).*V(2:Nh+1).*y(2:Nh+1).*(xi-t)./(sigma.^1);
			sigma=sigma+(etas*e).*V(2:Nh+1).*y(2:Nh+1).*norma./(sigma.^2);
			V=V+(etav*e).*y;
			E(i)=0.5*e^2;
		end
	end


#### 1.3 - Comparação dos algoritmos

Para a comparação, os algoritmos foram executados 3 vezes cadas, constando aqui apenas o melhor caso das execuções. Cada execução corresponde à 20000 épocas, cada época consta com 50 exemplos. Os pesos inicial são gerados aleatoriamente. 

|Original  | Online |
|--|--|
|![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/mlp_original.png?raw=true)  | ![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/mlp_online.png?raw=true) |
|1. PARÂMETROS DO PROJETO<br>Exemplos de Treinamento: 51<br>Exemplos de Teste: 5000<br>Taxa de aprendizado: 0.01<br>Pesos, valor médio inicial: 0.07<br>2. CONFIGURACÄO DA REDE NEURAL<br>   Número de Neurönios por Camada<br>   Entrada:      2<br>   Escondida: 15<br>   Saída:          1<br>3. TREINAMENTO<br>   Número de épocas: 20000<br>   Erro médio quadrático: 8.6948e-05<br>   Duraçäo do Treinamento: 1.8279 min<br>4. TESTE<br>   Erro absoluto máximo: 0.088139<br>   Erro médio quadrático: 0.00025574<br>   Duraçäo do Teste: 0.062 s<br>||



### 2 - Adicionar o termo momento (alpha) no algoritmo MLP.

O termo momento, consiste em uma constante positiva que controla a influência do ajuste anterior sobre o ajuste atual dos pesos. Dada pela equação:

<a href="https://www.codecogs.com/eqnedit.php?latex=\large&space;\Delta&space;w(n)=-\eta&space;\frac{\partial&space;E}{\partial&space;w}(n)&plus;\alpha&space;\Delta&space;w(n-1)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\large&space;\Delta&space;w(n)=-\eta&space;\frac{\partial&space;E}{\partial&space;w}(n)&plus;\alpha&space;\Delta&space;w(n-1)" title="\large \Delta w(n)=-\eta \frac{\partial E}{\partial w}(n)+\alpha \Delta w(n-1)" /></a>

> AVISO: Esta não é uma técnica geral para ganhos de estabilidade e aceleração da convergência

Para analisar os impactos provocados pelo termo momento, foram utilizados diferentes alphas e observado os valores gerados pela rede MLP.

| Valores para alpha | Taxa de erro |
|--|--|
| 0.1 |  |
| 0.01 |  |
| 0.001 |  |

### 3 - Adaptar a taxa de aprendizado durante o treinamento no algoritmo MLP.


