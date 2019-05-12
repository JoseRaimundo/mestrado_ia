#### 1. Alterar o conjunto de dados do classificador

Neste trabalho, foi utilizado uma rede neural artificial do tipo MLP para classificação binária de pontos em duas classes, correspondentes a pontos dentro ou fora da área de uma forma semelhante à uma letra. Para gerar a base de dados, é gerado uma matriz de pontos aleatórios dos quais são selecionados os pontos desejados. Para esta atividade foi utilizada a área correspondente a letra "C", o formato da letra foi selecionado devido a maior facilidade de autoajusto do algoritmo MLP em relação à variação da área da figura.

Montagem dos dataset: Para o treinmaneto, foi reaproveitado a função de exemplo, porém utilizando uma nova abordagem. A função original utiliza as cordendadas do ponto 



####  2 . Altere a observe o comportamento do algoritmo de compressão de bits com o objetivo de identificar qual o menor custo possível  de neurônios necessários para manter a eficiência de compressão.
O algoritmo fornecido realiza a compressão de bits por meio de neurônios em uma rede do tipo RPROC. Inicialmente o algoritmo está configurados com: 10 Neurônios de entrada, 5 ocultos e 10 de saída (considerando uma entrada de 10 bits). 

**Solução proposta:** A estrutura RPROC do algoritmo original foi mantido, porém foi reconfigurado as camadas de neurônios. Considerando que a quantidade de bits B, é necessário fornecer a mesma quantidade de entradas X e saída Y, também é considerado como resultado correto quando X = Y (uma vez que se trata de uma lógica de compressão). Logo, foram realizadas alterações apenas na camada de neurônios oculta. 

**Resultado** 

 
 ![enter image description here](https://github.com/JoseRaimundo/mestrado_ia/blob/master/06-primero_projeto/img/encoder.png)



#### 1. Mostre que:
<center><a href="https://www.codecogs.com/eqnedit.php?latex=\frac{\partial&space;E(n)}{\partial&space;\eta&space;_{ji}(n)}=-\frac{\partial&space;E(n)}{\partial&space;w&space;_{ji}(n)}&space;\frac{\partial&space;E(n-1)}{\partial&space;w&space;_{ji}(n-1)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\frac{\partial&space;E(n)}{\partial&space;\eta&space;_{ji}(n)}=-\frac{\partial&space;E(n)}{\partial&space;w&space;_{ji}(n)}&space;\frac{\partial&space;E(n-1)}{\partial&space;w&space;_{ji}(n-1)}" title="\frac{\partial E(n)}{\partial \eta _{ji}(n)}=-\frac{\partial E(n)}{\partial w _{ji}(n)} \frac{\partial E(n-1)}{\partial w _{ji}(n-1)}" /></a></center>

#### Resposta:

#### 2. Estude a convergência de diferentes algoritmos de primeira ordem para aproximação de funções de uma variável (1-D) através de redes FNN.

#### Reposta:

#### 3. Desenvolva uma aplicação de modelagem em 2-D e verifique a propriedade de generalização de uma rede neural sem realimentação.


#### 4. Desenvolva uma aplicação de classificação de padrõres e verifique a propriedade de generalização de uma rede neural sem realimentação.

#### 5. Elabore um relatório técnico descrevendo as atividades realizadas.




