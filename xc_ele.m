function xc=xc_ele(xnod,icone,nnod)
%
%      xc=xc_ele(xnod,icone,nnod)
%
%  Calculo centroide de los elementos
%
%  nnod es un vector del mismo tamaño que icone que me dice
%  cuantos nodos reales tiene cada elemento o cara en icone
%  importante cuando hay diferentes tipos de elementos.
%

[numnp,ndm] = size(xnod);
[numel,nen] = size(icone);
xc = zeros(numel,ndm);
if nargin>2,
    nn=find(nnod==3);
    if isempty(nn)==0
        for k=1:3
            nodes = icone(nn,k)';
            xc(nn,:) = xc(nn,:)+(1/3)*xnod(nodes,:);
        end
    %else
    %    error(' **** xc_ele Error **** Check faces array ');
    end

    nn=find(nnod==4);
    if isempty(nn)==0
        for k=1:4
            nodes = icone(nn,k)';
            xc(nn,:) = xc(nn,:)+(1/4)*xnod(nodes,:);
        end
    %else
    %    error(' **** xc_ele Error **** Check faces array ');
    end
    
else
    for k=1:nen,
        nodes = icone(:,k)';
        xc = xc+(1/nen)*xnod(nodes,:);
    end
end

