 function grafico2D_teste(yi,dk,yk,NC,NP,epoca,sse,xteste,zteste)

 pause(2),close
for i=1:NP
    d(:,i)=dk((i-1)*NC+1:i*NC);
    y(:,i)=yk((i-1)*NC+1:i*NC)';
end


 le=['Eav(' num2str(epoca) ') = ' num2str(sse)];
 
      set(gcf,'Position',[1 49 1024 634],'color',[1 1 1]); 
      axs=axes;
      set(axs,'NextPlot','Add','Box','On','FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold') 
      a=plot(-1,-1,'ko',-1,-1,'k',-1,-1,'b--',-1,-1,'w'); set(a,'LineWidth',2);
      for i=1:NP
       grafico(i)=plot(yi,d(:,i),'ko'); set(grafico(i),'LineWidth',2);
       grafico(i+NP)=plot(yi,y(:,i),'k'); set(grafico(i+NP),'LineWidth',2);
      end
      graficot=plot(xteste,zteste(1:NC),'b--'); set(graficot,'LineWidth',2);
      graficot=plot(xteste,zteste(NC+1:2*NC),'b--'); set(graficot,'LineWidth',2);
      xla=xlabel('Bitola (mm2)'); 
      yla=ylabel('Vqd (V)');  
      tit=title('Resposta do Modelo MLP - Queda de Tensao x Bitola');
      legenda=legend('Conjunto de treinamento','Modelo MLP, (Interpolação)','Modelo MLP, (Generalização)',le);
      set(xla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(yla,'FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold')
      set(legenda,'Location', 'SouthEast','FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold')
      set(tit,'FontName','Arial','FontSize',16,'FontWeight','Normal')
      axis([0 3 0 4.5])
 
 drawnow;