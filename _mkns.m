clc
clear
global iga x y

%_______________________________________________________
%% Setup the GA
ff='tspfun'; % objective function
npar=40; %npar  # optimization variables nbr of cities

%% XY of cities
% cities are at  (xcity,ycity)
xy=load('Meknes_40_fin.tsp');
x=xy(:,2);
y=xy(:,3);

%_______________________________________________________
%% Stopping criteria for the moment just to visualiaze results
maxit=1000; % max number of iterations
%_______________________________________________________
%% GA parameters
popsize=50; % set population size
mutRate=0.2;%what keeped from pop in the mutation process
selection=0.2;          % fraction of population kept
keep=floor(selection*popsize);  % #population members 
%% generation counter initialized
iga=0; 
%% number of matings
M=ceil((popsize-keep)/2);   % number of matings (pop -keep)/2
%_________________
%% selection function
pref=ones(1,ceil(keep));%iwas keep/2 but be elitiste to the first is better
%pref=[pref 2*ones(1,ceil((keep+1-2)))];
for ii=2:keep      %keep! element of 111111 222 33 within proba 
pref=[pref ii*ones(1,ceil((keep+1-ii)/2))  ];%concat odd 
end

Npref=length(pref);([1:keep]*100/Npref);%pourctge per rang
%_______________________________________________________

%% initialaize the initial pop  in random n calculate its cost
pop=init_pop(popsize,npar);
%distance between cities
for ic=1:npar
for id=1:npar
dcity(ic,id)=sqrt((x(ic)-x(id))^2+(y(ic)-y(id))^2);
end % id
end %ic
cost=feval(ff,pop,dcity);    % calculates population cost 
   figure(4);
   pclr = ~get(0,'DefaultAxesColor');
    imagesc(dcity);
    title('Distance Matrix');

%% sort population with lowest using ff + min + mean
[cost,ind]=sort(cost); % min cost in element 1
pop=pop(ind,:);         % sort population with lowest (lowest is 1st etc...)
minc(1)=min(cost);      % minc contains min of  population
meanc(1)=mean(cost); % meanc contains mean of population
varc(1)=var(cost); 
%_______________________________________________________
%% Iterate through generations
while iga<maxit 
iga=iga+1;      % increments generation counter
%_______________________________________________________
%% Pair and mate
pick1=ceil(Npref*rand(1,M)); % mate #1  a random pick of M elements within pref -- from 1 to npref
pick2=ceil(Npref*rand(1,M)); % mate #2 same
% ma and pa contain the indicies of the parents
ma=pref(pick1); %  M elements  of mothers  
pa=pref(pick2);%same for fathers
%_______________________________________________________
%% Performs mating 2 pts CrossX
for ic=1:M
mate1=pop(ma(ic),:);
mate2=pop(pa(ic),:);
indx=2*(ic-1)+1;   % starts at one and skips every other one 1 3 5 ...M ou M-1
%%  MPX=========================
routeInsertionPoints = sort(ceil(npar*rand(1,2)));
I = routeInsertionPoints(1);
J = routeInsertionPoints(2);
[mate1,mate2] = ox_2pts_rest_ordre(I,J,npar,mate1,mate2);

pop(keep+indx,:)=mate1;
pop(keep+indx+1,:)=mate2;

end
%%      Sort the costs and associated parameters and Do statistics
cost=feval(ff,pop,dcity);%part=pop; costt=cost;
[cost,ind]=sort(cost);
pop=pop(ind,:);
%_______________________________________________________
%%  Mutation + exploration
           for kk=1:(popsize-ceil(mutRate*popsize))%
                    k=randi(3,1,1);
                        %row1=ceil(rand*(popsize-5)) + 5;
                        row1=ceil(rand*(popsize-ceil(mutRate*popsize)))+ceil(mutRate*popsize);% ---- random value between 1 and (popsize-ceil(mutRate*popsize))
                    switch k
                        case 1 % Flip
                        pop(row1,I:J) = pop(row1,J:-1:I);
                        case 2 % Swap
                            pop(row1,[I J]) = pop(row1,[J I]); %K-opt 2opt
                        case 3 % Slide
                            pop(row1,I:J) = pop(row1,[I+1:J I]);
                        otherwise % Do Nothing
                    end
           end

%_______________________________________________________
%%      Sort the costs and associated parameters and Do statistics
cost=feval(ff,pop,dcity);
[cost,ind]=sort(cost);
pop=pop(ind,:);
%_______________________________________________________
minc(iga)=min(cost);
meanc(iga)=mean(cost);
varc(iga)=var(cost); 
%_______________________________________________________
% for h=1:9
% if ceil((iga/9)*h)==iga
%    figure(3);
%    subplot(3,3,h);
%     pclr = ~get(0,'DefaultAxesColor');
%     imagesc(dcity(pop(1,:),pop(1,:)));
%     title(['Distance Matrix numIter',num2str(iga)]);
% end
% end 
%_______________________________________________________

figure(1);
plot( x([pop(1,:) pop(1,1)]), y([pop(1,:) pop(1,1)]),'r.-','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',10);
text(xy(:,2)+0.1, xy(:,3)+0.9, num2str((1:npar)'));set(gcf,'Color',[1,1,1]);
axis square
title(sprintf('Total Distance = %1.4f,Iteration = %d \n | Villes = %d | maxit = %d | popsize = %d | mutRate = %1.2f | selection = %1.2f',cost(1),iga,npar,maxit,popsize,mutRate,selection));
%% injection
if iga==1000
    pop=inject_pop(pop,popsize,npar);
end
end %iga

%_______________________________________________________
%% Displays the output
    figure(5);
%    subplot(3,3,9);
     pclr = ~get(0,'DefaultAxesColor');
     imagesc(dcity(pop(1,:),pop(1,:)));
     title('Distance Matrix final route');
        
  %------------------------------------------
figure(2);
day=clock;
disp(datestr(datenum(day(1),day(2),day(3),day(4),day(5),day(6)),0))
disp(['optimized function is ' ff])
format short g
disp([' best cost=' num2str(cost(1))])
disp(['best solution'])
disp([num2str(pop(1,:))])

subplot(3,1,2);
iters=1:maxit;
plot(iters,minc,'-r',iters,meanc,'-b');
legend('Minimum Cost','Mean Cost') 
xlabel('generation');ylabel('cost');

subplot(3,1,3);
plot(iters,varc,'-g');
legend('variancce Cost') ;
xlabel('generation');ylabel('cost');

subplot(3,1,1);
plot( x([pop(1,:) pop(1,1)]), y([pop(1,:) pop(1,1)]),'rs-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',4);
axis square
title(sprintf('Total Distance = %1.4f,Iteration = %d \n | Villes = %d | maxit = %d | popsize = %d | mutRate = %1.2f | selection = %1.2f',cost(1),iga,npar,maxit,popsize,mutRate,selection));