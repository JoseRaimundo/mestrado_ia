## Atividade 5
### 1 - Alterar formas de treinamento
Alterar a forma de treinamento do algoritmo MLP (originalmente como batch) para treinamento online, e alterar a forma de treinamento do algoritmo RBF (originalmente online) para batch, e comparar o ajuste da curva do original com a versão modificada.


Abordagem utilizada para modificar o RBF online para Batch: Foi eliminado o segundo laço da da etapa de treinamento do algoritmo original e compensando as interações adicionando **N** vezes de Interações na época, também foi adicionado um contador **i** que é zerado por um **if** quando chega a um valor de 50, esta abordagem evita que o programa trave ao atualizar o gráfico além de possibilitar.

    for epoca=1:epochmax * N %% Compensando interações do laço internet
	i = i + 1;
	...
	Wkj=Wkj+(-etae*[-1 yj]);
	Wji=Wji+(-etae.*(Wkj(:,2:Nh+1).*yj.*(1-yj))'*xi);
		if i == 51 %% Atualizando o gráfico de ajuste da curva
			exibi_epoca = exibi_epoca + 1;
			SSE(exibi_epoca)=sum(E)/N;
			grafico_treino(xtreino, xmax, dtreino, z, 	exibi_epoca,epochexb, SSE(exibi_epoca));
		i = 0;
		end;
	end

