 clear all, clc, close all,
   N=16;
   %fid=fopen('Dados_Queda_de_Tensao.xlsx','rt');
   dados = xlsread('C:\Users\reuel\Google Drive\ic\ExercicioQuedaDeTensao\Dados_Queda_de_Tensao')
   %dados=fscanf(fid,'%f\n',N*4); 
   %fclose(fid); 
   vds=dados(1:N);
   ids=dados(N+1:4*N);
   vgs=[0 -.5 -1]; 
   xtreino(:,1)=[vds' vds' vds']';
   xtreino(:,2)=[zeros(1,N) (-0.5).*ones(1,N) (-1).*ones(1,N)]';
   dtreino(:,1)=ids;
   xteste(:,1)=[vds' vds']';
   xteste(:,2)=[(-0.25).*ones(1,N) (-0.75).*ones(1,N)]';
   xmax=max(max(xtreino));   
   dmax=max(max(dtreino)); 
   xtreino=xtreino./xmax;
   dtreino=dtreino./dmax; 
   xteste=xteste./xmax;
   Ni=3; Ns=1; N=16; NT=N;
   grafico2D_dataset(vds,ids);
   par=vgs;
   save mesfet_dataset.mat xmax dmax xtreino dtreino xteste par  