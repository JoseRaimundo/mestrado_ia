

## Atividade 5
### 1 - Alterar formas de treinamento
Alterar a forma de treinamento do algoritmo MLP (originalmente como batch) para treinamento online, e alterar a forma de treinamento do algoritmo RBF (originalmente online) para batch, e comparar o ajuste da curva do original com a versão modificada.

> !AVISO!: todos os testes foram realizados com a seguinte configuração:
> PARÂMETROS DO PROJETO<br>   Exemplos de Treinamento: 51<br>   Exemplos de Teste: 5000<br>   Taxa de aprendizado: 0.01<br>   Pesos, valor médio inicial: 0.07<br>CONFIGURACÄO DA REDE NEURAL <br>  Número de Neurönios por Camada<br>   Entrada:      2<br>   Escondida: 15<br>   Saída:          1<br>


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
##### Resultado

|Batch  | Online |
|--|--|
|![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/mlp_online_treino.png?raw=true)  |![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/mlp_online_treino.png?raw=true) |
|3. TREINAMENTO<br>   Número de épocas: 20000<br>   Erro médio quadrático: 0.0006475<br>   Duraçäo do Treinamento: 1.7415 min<br>4. TESTE<br>   Erro absoluto máximo: 0.17034<br>   Erro médio quadrático: 0.00045172<br> Duraçäo do Teste: 0.05 s<br> | 3. TREINAMENTO<br>   Número de épocas: 20000<br>   Erro médio quadrático: 0.0001772<br>   Duraçäo do Treinamento: 1.4943 min<br>4. TESTE<br>   Erro absoluto máximo: 0.12541<br>   Erro médio quadrático: 0.00040524<br>   Duraçäo do Teste: 0.062 s|


#### 1.2 - Abordagem utilizada para modificar o RBF online para Batch: 
Foi eliminado a indexação aleatória dos exemplos e criado uma alimentação (conjunto de exemplos) de tamanho estático, essa alimentação é apresentada ao algoritmo por um novo laço adicionado dentro do laço que interage as épocas, também foi adicionado variáveis globais que ajudam no armazenamento do ajuste da variáveis **t**, **v** e **Sigma**. Estas variáveis são incrementadas a cada época com os valores de variáveis locais, que por sua vez se ajustam continuamente durante o treinamento. [Código compleo aqui](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/rbf_batch.m)

	%% Variáveis globais
	for epoca=1:epochmax
		for i=1:N
			...
			% AJUSTE DOS PESOS, CENTROS E LARGURAS DA REDE RBF

			t=t+global_t+(2*etat*e).*V(2:Nh+1).*y(2:Nh+1).*(xi-t)./(sigma.^1);
			sigma=sigma+global_sigma+(etas*e).*V(2:Nh+1).*y(2:Nh+1).*norma./(sigma.^2);
			V=V+global_v+(etav*e).*y;
			E(i)=0.5*e^2;
		end
	global_sigma = global_sigma + sigma;
	global_v = global_v + v;
	global_t = global_t + t;
	end

##### Resultado

| RBF Online | RBF Batch |
|--|--|
| ![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/rbf_online_treino.png?raw=true) | ![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/05-aprendizado_online_batch/img/rbf_batch_treino.png?raw=true) |
|Treinamento:<br>Número de épocas: 20000<br>Erro médio quadrático : 0.00048196<br>Duraçäo: 120.687 s<br>Generalizaçäo:<br>Erro absoluto máximo : 0.15509<br>Erro médio quadrático: 0.00030956|Treinamento:<br>Número de épocas: 20000<br>Erro médio quadrático : 0.00052886<br>Duraçäo: 117.813 s<br>Generalizaçäo:<br>Erro absoluto máximo : 0.16001<br>Erro médio quadrático: 0.00034722|



#### 1.3 - Comparação dos algoritmos

Para a comparação, os algoritmos foram executados 3 vezes cadas.





### 2 - Adicionar o termo momento (alpha) no algoritmo MLP.

O termo momento, consiste em uma constante positiva que controla a influência do ajuste anterior sobre o ajuste atual dos pesos. Dada pela equação:

<a href="https://www.codecogs.com/eqnedit.php?latex=\large&space;\Delta&space;w(n)=-\eta&space;\frac{\partial&space;E}{\partial&space;w}(n)&plus;\alpha&space;\Delta&space;w(n-1)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\large&space;\Delta&space;w(n)=-\eta&space;\frac{\partial&space;E}{\partial&space;w}(n)&plus;\alpha&space;\Delta&space;w(n-1)" title="\large \Delta w(n)=-\eta \frac{\partial E}{\partial w}(n)+\alpha \Delta w(n-1)" /></a>

> AVISO: Esta não é uma técnica geral para ganhos de estabilidade e aceleração da convergência

Para analisar os impactos provocados pelo termo momento, foram utilizados diferentes alphas e observado os valores gerados pela rede MLP.

| Valores para alpha | Saída da MLP |
|--|--|
| 0.1 | Erro médio quadrático: 0.0042301 <br>   Duraçäo do Treinamento: 1.6255 min <br>TESTE <br>   Erro absoluto máximo: 0.17114 <br>   Erro médio quadrático: 0.0040505 <br>   Duraçäo do Teste: 0.063 s |
| 0.01 | Erro médio quadrático: 0.015026 <br>  Duraçäo do Treinamento: 1.5849 min <br>  TESTE <br>   Erro absoluto máximo: 0.42001<br>   Erro médio quadrático: 0.015093<br>   Duraçäo do Teste: 0.063 s |
| 0.001 | Erro médio quadrático: 0.10541<br>    Duraçäo do Treinamento: 1.5864 min<br> TESTE<br>   Erro absoluto máximo: 1.043<br>    Erro médio quadrático: 0.1073<br>   Duraçäo do Teste: 0.046 s |

### 3 - Adaptar a taxa de aprendizado durante o treinamento no algoritmo MLP.

Para ajuste da taxa de aprendizado, foi utilizado o seguinte comando.

	      eta = (ajuste_n * ((1+(ajuste_k/ajuste_n)+(i/ajuste_t))/(1+(ajuste_k/ajuste_n)*(i/ajuste_t)+ajuste_t*(i/ajuste_t)^2)));

Em que ajuste_n, ajuste_t e ajuste_k são constantes positivas e com valores entre 0 e 1, abstraídos da equação:


##### Resultados

|Teste| Valor das constantes | Resultados |
|--|--|--|
|1| ajuste_n = 0.2<br>ajuste_t = 0.1<br>ajuste_k = 0.1  | Erro médio quadrático: 0.007329<br>   Duraçäo do Treinamento: 1.0344 min<br>   Erro absoluto máximo: 0.35799<br>   Erro médio quadrático: 0.0066418<br>   Duraçäo do Teste: 0.047 s |
|2| ajuste_n = 0.2<br>ajuste_t = 0.2<br>ajuste_k = 0.1  | Erro médio quadrático: 0.0035996<br>   Duraçäo do Treinamento: 1.0781 min<br>  Erro absoluto máximo: 0.25204<br>Erro médio quadrático: 0.0032459<br>   Duraçäo do Teste: 0.047 s |
|3| ajuste_n = 0.2<br>ajuste_t = 0.2<br>ajuste_k = 0.2  |Número de épocas: 20000<br>   Erro médio quadrático: 0.0015072<br>   Duraçäo do Treinamento: 1.074 min<br>   Erro absoluto máximo: 0.11178<br>   Erro médio quadrático: 0.0014597<br>   Duraçäo do Teste: 0.047 s  |



