
eposcas = 20000;



load('mlp_ajuste1.dat');
load('mlp_ajuste2.dat');
load('mlp_online.dat');
load('mlp_batch.dat');
load('rbf_batch.dat');
load('rbf_online.dat');
load('mlp_monomolecular.dat');
load('mlp_rproc.dat');
load('mlp_momento.dat');

%% Descomentar para salvar os dados

% save mlp_momento.mat mlp_momento 
% save mlp_ajuste1.mat mlp_ajuste1
% save mlp_ajuste2.mat mlp_ajuste2 
% save mlp_online.mat mlp_online 
% save mlp_batch.mat mlp_batch 
% save rbf_batch.mat rbf_batch 
% save rbf_online.mat rbf_online
% save mlp_monomolecular.mat mlp_monomolecular 
% save mlp_rproc.mat mlp_rproc 

figure(2)
semilogy(....
    1:eposcas,mlp_rproc,....
    1:eposcas, mlp_monomolecular,....
    1:eposcas, mlp_online,....
    1:eposcas, mlp_batch,....
    1:eposcas, mlp_ajuste1,....
    1:eposcas, mlp_ajuste2,....
    1:eposcas, mlp_momento,....
    1:eposcas, rbf_online,....
    1:eposcas, rbf_batch,....
 'linewidth',3 ....
     )
legend( 'MLP RPROC','MLP Monomolecular', 'MLP Momento', 'MLP batch', 'MLP Ajuste Robins e Monro', 'MLP Ajuste Darken' , 'MLP Online', 'RBF online', 'RBF batch' )

% semilogy(1:eposcas,mlp_monomolecular)
xlabel('épocas')
ylabel('MSE')
title('Comparação dos algoritmos')


