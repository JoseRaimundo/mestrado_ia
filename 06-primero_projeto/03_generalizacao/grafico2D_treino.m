 function grafico2D_treino(yi,dk,yk,NC,NP,epoca,sse)
 global grafico legenda

for i=1:NP
    d(:,i)=dk((i-1)*NC+1:i*NC);
    y(:,i)=yk((i-1)*NC+1:i*NC)';
end


 le=['Eav(' num2str(epoca) ') = ' num2str(sse)];
 if epoca==1 
      set(gcf,'Position',[1 49 1024 634],'color',[1 1 1]); 
      axs=axes;
      set(axs,'NextPlot','Add','Box','On','FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold') 
      for i=1:NP
       grafico(i)=plot(yi,d(:,i),'ko'); set(grafico(i),'LineWidth',2);
       grafico(i+NP)=plot(yi,y(:,i),'k'); set(grafico(i+NP),'LineWidth',2);
      end
      
      xla=xlabel('yi'); 
      yla=ylabel('dk, yk');  
      tit=title('Treinamento: MLP - Resilient Backpropagation');
      legenda=legend('Conjunto de treinamento','Saída da rede MLP',le);
      set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(legenda,'Location', 'SouthEast','FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
      set(tit,'FontName','Arial','FontSize',14,'FontWeight','Normal')
    
  else
      delete(grafico); delete(legenda);
      for i=1:NP
       grafico(i)=plot(yi,d(:,i),'ko'); set(grafico(i),'LineWidth',2);
       grafico(i+NP)=plot(yi,y(:,i),'k'); set(grafico(i+NP),'LineWidth',2);
      end
      legenda=legend('Conjunto de treinamento','Saída da rede MLP',le);
      set(grafico,'LineWidth',2); 
      set(legenda,'Location', 'SouthEast','FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
 end
 drawnow;