function [e1,e2] = ox_2pts_rest_ordre(I,J,N,p1,p2)

%I,J points
%N nbre de cities
%p1.2 parents

e1=zeros(1,N);
e12=zeros(1,N);
e13=zeros(1,N-(J-I+1));

e2=zeros(1,N);
e22=zeros(1,N);
e23=zeros(1,J-I+1);

e1([I:J]) = p1([I:J]);
e2([1:I-1])=p1([1:I-1]);
e2([J+1:size(p1,2)])=p1([J+1:size(p1,2)]);



%P2-E1=E12%%%%%%%%%%%
for c=1:N %parcourir p2
      flag=1;
                  for cc=I:J %parcourir entre les pts de OX de p1=e1
                      if p2(c)==p1(cc)
                          flag=0;
                      end
                  end
 if flag==1
     e12(c)=p2(c);
 end
end
  %P2-E2=E22%%%%%%%%%%%
for c=1:N %parcourir p2
      flag=1;
                  for cc=1:I-1 %parcourir entre les pts de OX de p1=e2 de debut a i-1
                      if p2(c)==p1(cc)
                          flag=0;
                      end
                  end
                  for cc=J+1:size(p1,2) %parcourir entre les pts de OX de p1=e2 de j+1 a la fin
                      if p2(c)==p1(cc)
                          flag=0;
                      end
                  end
 if flag==1
     e22(c)=p2(c);
 end
  end


  %E13%%%%%%%%%%%%%
cc=1;
  for c=1:N
    if  e12(c)~=0
        e13(cc)  =  e12(c);
        cc=cc+1;
    end
end
%E23%%%%%%%%%%%%%
cc=1;
  for c=1:N
    if  e22(c)~=0
        e23(cc)  =  e22(c);
        cc=cc+1;
    end
end


   %E1 = E1 FINALE
   cc=1; 
   for c=1:N
    if  e1(c)==0
        e1(c)  =  e13(cc);
        cc=cc+1;
    end
   end
      %E2 = E2 FINALE
   cc=1; 
   for c=1:N
    if  e2(c)==0
        e2(c)  =  e23(cc);
        cc=cc+1;
    end
   end 

end %fct

  