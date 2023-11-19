% cost function for traveling salesperson problem
function dist=tspfun(pop,dcity)
% global iga x y

S=7;
I=5*0.128;
F=162.152;
[Npop,Ncity]=size(pop);
tour=[pop pop(:,1)];  % ajouter l a1ere ville a la fin de la route
% %distance between cities
% for ic=1:Ncity
% for id=1:Ncity
% dcity(ic,id)=sqrt((x(ic)-x(id))^2+(y(ic)-y(id))^2);
% end % id
% end %ic
% cost of each chromosome
for ic=1:Npop
dist(ic,1)=0;
for id=1:Ncity
dist(ic,1)=dist(ic)+dcity(tour(ic,id),tour(ic,id+1));
end % id
%dist(ic,1)=dist(ic,1)*0.5+0.5*(dist(ic,1)*S*I*F);%CO2=ASIF
end % ic

