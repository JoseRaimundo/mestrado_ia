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

Para a comparação, os algoritmos foram executados 3 vezes cadas, constando aqui apenas o melhor caso das execuções.

### 2 - Adicionar o termo momento (alpha) no algoritmo MLP.


### 3 - Adaptar a taxa de aprendizado durante o treinamento no algoritmo MLP.


