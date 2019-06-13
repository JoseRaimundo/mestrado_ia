
% I Setup the GA
clear;
ff='testfunction'; % objective function
npar=2; % number of optimization variables
varhi=-4; varlo=4; % variable limits
%_______________________________________________________
% II Stopping criteria
maxit=50; % max number of iterations
mincost=-9999999; % minimum cost
%_______________________________________________________
% III GA parameters

popsize=20;                         % set population size
mutrate=.2;                         % set mutation rate
selection=0.5;                      % fraction of population kept
Nt=npar;                            % continuous parameter GA Nt=#variables
keep=floor(selection*popsize);      % #population members that survive
nmut=ceil((popsize-1)*Nt*mutrate);  % total number of  mutations
M=ceil((popsize-keep)/2);           % number of matings
%_______________________________________________________
% Create the initial population
iga=0;    
popx = -3.85 + 0.5 * rand(popsize, 1);
popy = -3.85 + 0.5 * rand(popsize, 1);

% generation counter initialized
% par=(varhi-2)*rand(popsize,npar)+varlo; % random
par = [popx, popy];
% par = par(:,1) + 2
cost=feval(ff,par);                         % calculates population cost using ff
costPSO = cost;

[cost,ind]=sort(cost);                      % min cost in element 1
par=par(ind,:);                             % sort continuous
minc(1) = min(cost);                          % minc contains min of
meanc(1)= mean(cost);                        % meanc contains mean of population
% Plotando cromossomos na posição inicial
hold on;
plot(par(:,1),par(:,2),'mo',  'Linewidth',3);
% hold off
path_ga = [];
cont = 1; cont = 1;
while iga<maxit
    % Pegando o melhor caminho (o melhor caminho sempre está na primeira linha do vetor par)
    path_ga(cont, 1) = par(1,1);
    path_ga(cont, 2) = par(1,2);
    cont = cont + 1;
    iga=iga+1; % increments generation counter
    %_______________________________________________________
    % Pair and mate
    M=ceil((popsize-keep)/2);               % number of matings
    prob=flipud([1:keep]'/sum([1:keep]));   % weights chromosomes
    odds=[0 cumsum(prob(1:keep))'];         % probability distribution function
    pick1=rand(1,M); % mate #1
    pick2=rand(1,M); % mate #2
    % ma and pa contain the indicies of the chromosomes that will mate
    ic=1;
    while ic<=M
        for id=2:keep+1
            if pick1(ic)<=odds(id) & pick1(ic)>odds(id-1)
                ma(ic)=id-1;
            end
            if pick2(ic)<=odds(id) & pick2(ic)>odds(id-1)
                pa(ic)=id-1;
            end
        end
        ic=ic+1;
    end
    %_______________________________________________________
    % Performs mating using single point crossover
    ix=1:2:keep; % index of mate #1
    xp=ceil(rand(1,M)*Nt); % crossover point
    r=rand(1,M); % mixing parameter
    for ic=1:M
       
        xy=par(ma(ic),xp(ic))-par(pa(ic),xp(ic));   % ma and pa mate
        par(keep+ix(ic),:)=par(ma(ic),:);           % 1st offspring
        
        par(keep+ix(ic)+1,:)=par(pa(ic),:);         % 2nd offspring
        par(keep+ix(ic),xp(ic))=par(ma(ic),xp(ic))-r(ic).*xy;
        % 1st
        par(keep+ix(ic)+1,xp(ic))=par(pa(ic),xp(ic))+r(ic).*xy;
      

        % 2nd
        if xp(ic)<npar % crossover when last variable not selected
            par(keep+ix(ic),:)=[par(keep+ix(ic),1:xp(ic))
            par(keep+ix(ic)+1,xp(ic)+1:npar)];
            par(keep+ix(ic)+1,:)=[par(keep+ix(ic)+1,1:xp(ic))
            par(keep+ix(ic),xp(ic)+1:npar)];
        end % if
    end
    contx = 1;
    
    %_______________________________________________________
    % Mutate the population
    mrow=sort(ceil(rand(1,nmut)*(popsize-1))+1);
    mcol=ceil(rand(1,nmut)*Nt);
    for ii=1:nmut
    par(mrow(ii),mcol(ii))=(varhi-varlo)*rand+varlo;
    % mutation
    end % ii
    %_______________________________________________________
    % The new offspring and mutated chromosomes are evaluated
    cost=feval(ff,par);
    %_______________________________________________________
    % Sort the costs and associated parameters
    [cost,ind]=sort(cost);
    par=par(ind,:);
    
    %_______________________________________________________
    % Do statistics for a single nonaveraging run
    minc(iga+1)=min(cost);
    meanc(iga+1)=mean(cost);
    %_______________________________________________________
    % Stopping criteria
    if iga>maxit | cost(1)<mincost
        break
    end
    [iga cost(1)]
 
end %iga

% Initializing variables
nparPSO = 2; % Dimension of the problem
c1 = 1; % cognitive parPSOameter
c2 = 4-c1; % social parPSOameter
C=1; % constriction factor
% Initializing swarm and velocities

parPSO = [popx, popy];
% continuous values
vel = rand(popsize,nparPSO); % random velocities
% Evaluate initial population
% ff
mincPSO(1)=min(costPSO); % min costPSO
meancPSO(1)=mean(costPSO); % mean costPSO
globalmin=mincPSO(1); % initialize global minimum
% Initialize local minimum for each parPSOticle
localparPSO = parPSO; % location of local minima
localcostPSO = costPSO; % costPSO of local minima
% Finding best parPSOticle in initial population
[globalcostPSO,indx] = min(costPSO);
globalparPSO=parPSO(indx,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start iterations
iter = 0; % counter

% % Plotando as posições iniciais 
cont = 1;
path_pso = [];
while iter < maxit
    path_pso(cont, 1) = parPSO(5,1);
    path_pso(cont, 2) = parPSO(5,2);
    cont = cont + 1;

%     plot(parPSO(:,1),parPSO(:,2),'go');
%     pause(0.3);
    iter = iter + 1;
    % update velocity = vel
    w=(maxit-iter)/maxit; %inertia weiindxht
    r1 = rand(popsize,nparPSO); % random numbers
    r2 = rand(popsize,nparPSO); % random numbers
    vel = C*(w*vel + c1 *r1.*(localparPSO-parPSO) + c2*r2.*(ones(popsize,1)*globalparPSO-parPSO));
    % update parPSOticle positions
    parPSO = parPSO + vel; % updates parPSOticle position
    overlimit=parPSO<=1;
    underlimit=parPSO>=0;
    parPSO=parPSO.*overlimit+not(overlimit);
    parPSO=parPSO.*underlimit;
    % Evaluate the new swarm
    costPSO = feval(ff,parPSO); % evaluates costPSO of swarm
    % Updating the best local position for each parPSOticle
    bettercostPSO = costPSO < localcostPSO;
    localcostPSO = localcostPSO.*not(bettercostPSO) + costPSO.*bettercostPSO;
    localparPSO(find(bettercostPSO),:) = parPSO(find(bettercostPSO),:);
    % Updating index g
    [temp, t] = min(localcostPSO);
    if temp<globalcostPSO
        globalparPSO=parPSO(t,:); indx=t; globalcostPSO=temp;
    end
%     vec_temp(iter+1,:) = globalparPSO(1,:);
    [iter globalparPSO globalcostPSO] % print output each
    % iteration
    mincPSO(iter+1)=min(costPSO); % min for this
    % iteration
    globalmin(iter+1)=globalcostPSO; % best min so far
    meancPSO(iter+1)=mean(costPSO); % avg. costPSO for
    % this iteration
end% while


% % Plotando o mínimo da função
plot(globalparPSO(1,1),globalparPSO(1,2),'g*', 'Linewidth',3)


% Plotando o caminho
plot(path_pso(:,1), path_pso(:,2), 'b--',  'Linewidth',1.3);
plot(path_ga(:,1), path_ga(:,2), 'r-',  'Linewidth',1.3);

% % Plotando a posição final
plot(parPSO(:,1),parPSO(:,2),'b*',  'Linewidth',1.3);
plot(par(:,1),par(:,2),'ro',  'Linewidth',1.3);





% % Plotando o contorno
N=100; 
xs = linspace(varhi,varlo,N);
ys = linspace(varhi,varlo,N); 
[X,Y] = meshgrid( xs, ys ); 
x = [ X(:), Y(:) ]; 
f = testfunction(x); 
f = reshape( f, [N,N] ); 
% figure; mesh( xs, ys, f );
contour(X,Y,f, 'k')
xlabel('x') 
ylabel('y') 
legend('Posição inicial','Minimo Global', 'Melhor Percurso PSO', 'Melhor Percurso GA', 'Posição Final PSO', 'Posição Final GA', 'Contorno da Função');
plot(globalparPSO(1,1),globalparPSO(1,2),'g*', 'Linewidth',4)
hold off
 
% % % _______________________________________________________
% %Displays the output

% figure(24)
% iters=0:length(minc)-1;
% hold on;
% 
% % semilogy(
% % )
% plot(iters,mincPSO,'g-',iters,meancPSO,'b--',iters,globalmin,'r:');
% plot(iters,minc,'k-',iters,meanc,'r--',iters,globalmin,'b:');
% xlabel('Generalização');ylabel('Custo');
% legend('Melhor custo PSO','Custo médio PSO', 'Custo Médio GA', 'Melhor cursot GA');



