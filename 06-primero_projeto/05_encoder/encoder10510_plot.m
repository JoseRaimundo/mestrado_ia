if epoca>1, 
    delete(a); delete(txt),delete(rec),clf reset
end
set(gcf,'Position',[1 33 800 494],'Color',[1 1 1]); 
axs=axes;
set(axs,'NextPlot','Add','Visible','Off','FontName','TimesNewRoman','FontSize',12,'FontWeight','Bold'); 
plot(0,1,'w',1,0,'w')
for io=1:N, for jo=1:N
    a(io,jo)=rectangle;
    set(a(io,jo),'Position', [.25+(io-1).*.055 .745-(jo-1).*.055 .05 .05],...
               'EdgeColor',[.3 .3 .3],'FaceColor',[1 1 1],'LineWidth',2);
    if Z(io,jo)>0.6,     set(a(io,jo),'FaceColor',[0 0 0]);
    elseif Z(io,jo)<0.4, set(a(io,jo),'FaceColor',[1 1 1]);
    else,              set(a(io,jo),'FaceColor',[1 0 0]); end
end,end
rec=rectangle; 
set(rec,'FaceColor',[1 1 1],'EdgeColor',[.3 .3 .3],'Position',[.25 .82 .545 .05]); 
txt=text(.4,0.85,['MSE(' num2str(epoca) ') = ' num2str(MSE) '             ']);
set(txt,'FontName','TimesNewRoman','FontSize',11,'FontWeight','Bold');
drawnow
