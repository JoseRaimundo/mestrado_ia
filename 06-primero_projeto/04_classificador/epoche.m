% 29/10/00, GERAÇÃO DE UM VETOR DE INTEIROS ALEATÓRIOS
% VERSÃO 2.0 - MAIORES EFIÊNCIA COMPUTACIONAL E ALEATORIEDADE
% autor: PAULO HENRIQUE DA FONSECA SILVA
function [rnd]=epoche(N);
m=zeros([1,N]);
n=round((N-1).*rand([1,N]))+1;

% ENCONTRA VALORES NÃO REPETIDOS DO CONJUNTO ALEATÓRIO
for i=1:N
 m(n(i))=1;
end
m1=m;

% ELIMINA REPETIÇÕES E DETERMINA VALORES NÃO ENCONTRADOS
k=0; n1=zeros([1,N]); n2=n1; 
for i=1:N
 if m(n(i))==1
  k=k+1; n1(k)=n(i);  m(n(i))=0;
 end
 if m1(i)==0
  k=k+1; n2(k)=i;
 end
end
rnd=n2+n1;

% REAGRUPA VALORES ALEATORIAMENTE
for f=1:2*N
 idc=round(N*rand); idc1=round(N*rand); 
 idc2=round(N^rand); idc3=round(N^rand);
 if (idc>0 & idc1>0)
  jump=rnd(idc);  rnd(idc)=rnd(idc1); rnd(idc1)=jump;
  jump=rnd(idc2); rnd(idc2)=rnd(idc3); rnd(idc3)=jump;
 end
end

 
