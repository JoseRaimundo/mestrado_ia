function grafico2D_dataset(yi,dk)
N=length(yi); NT=length(dk); NC=NT/N;
for i=1:NC
    d(:,i)=dk((i-1)*N+1:i*N);
end
set(gcf,'Position',[1 49 1024 634],'color',[1 1 1]); 
axs=axes;
set(axs,'NextPlot','Add','Box','On','FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold'); 
for i=1:NC
    grafico=plot(yi,d(:,i),'bo'); set(grafico,'LineWidth',2);
end
xtxt=xlabel('yi'); 
ytxt=ylabel('dk');
titulo=title('Conjunto de Treinamento: (yi, dk)');
legenda=legend([num2str(NT) ' Exemplos de treinamento']);
set(xtxt,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold');
set(ytxt,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold');
set(legenda,'Location', 'SouthEast','FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold');
set(titulo,'FontName','Arial','FontSize',16,'FontWeight','Normal');
pause(2),close