function av = m2v(am)
%
%    av(vector) = m2v(am)
%
%  Transforma un arreglo expresado como matriz sobre una
%  grilla uniforme de diferencias finitas en otro
%  expresado como vector
%

[Ny,Nx]= size(am);
N      = Nx*Ny;
av     = zeros(N,1);

%for j=1:Ny,
%  index = im2v(1:Nx,j,Nx);
%  av(index) = am(j,1:Nx);
%end


if Nx<=Ny,
 for j=1:Nx,
  av(j:Nx:N) = am(:,j);
 end
else
 for j=1:Ny,
  av((j-1)*Nx+(1:Nx)) = am(j,:);
 end
end