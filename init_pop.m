%% Create the initial population
function pop=init_pop(popsize,npar)
pop(1,:)=[1:npar];
%optimum
%pop(1,:)=[1 9 40 15 12 11 13 25 14 23 3 22 16 41 34 29 2 26 4 35 45 10 24 42 5 48 39 32 21 47 20 33 46 36 30 43 17 27 19 37 6 28 7 18 44 31 38 8];
%pop(1,:)=[1 9 40 15  10 24 42 5 48 39 32 21 47 20 33 46 36 12 11 13 25 14 23 3 22 16 41 34 29 2 26 4 35 45 30 43 17 27 19 37 6 28 7 18 44 31 38 8];
for iz=2:popsize
pop(iz,:)=randperm(npar); % random population line=route=path [Npop,Ncity]
end