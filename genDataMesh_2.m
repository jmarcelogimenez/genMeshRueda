%
% CASO 2
%
%  Paso seguido la pondremos en contacto con el piso con cierta
%  penetracion pero con un perfil recto (corte YZ), 
%
%  Modificamos la primera version de este caso para llevarlo aqui al paper
%  de MacManus & Zhang
%

dirname = ['run_1'];
% Datos geometricos
% Diametro de la cubierta
D = 0.416;
% ancho
W = 0.191;
% Despeje del piso
c = 0.05*D;
% distancia al cielo del dominio
Hu = 2.93*D;
% distancia al inlet del dominio
Hl = 5*D;
% distancia al outlet del dominio
Hr = 15*D;
% distancia maxima hacia los laterales
Hw = 3.66*D/2;
% distancia upstream la rueda donde comienza el piso movil (x2 en paper)
X2 = 1.68*D;
% tama??o de la malla en el interior del bloque que contiene a la rueda
hi = D/15;
% tama??o de la malla en el exterior del bloque que contiene a la rueda
he = 1.6*hi;
% factor de crecimiento de la malla en el plano xy
gm = 5; %4;
% factor de crecimiento de la malla en z
gZ = 5; %4;

% velocidad a la entrada
Uin = 18.6;

Re = 5.3e5,
visco = Uin*D/Re;

% Datos numericos
solver = 'pimple';

datos.c = c;
datos.D = D;
datos.W = W;
datos.Hu = Hu;
datos.Hl = Hl;
datos.Hr = Hr;
datos.Hw = Hw;
datos.X2 = X2;
datos.hi = hi;
datos.he = he;
datos.gm = gm;
datos.gZ = gZ;
datos.solver = solver;
datos.Uin = Uin;

% calculo del angulo de contacto de la rueda con el pavimento
angle = 2*acos(2/D*(D/2-c));
X6 = D/2*sin(angle/2);
Y6 = D/2-c;
% Definimos los vertices (ver croquis en inkscape generado)
% perimetro de la rueda
V(5,1:2)=[-X6,-Y6];
V(6,1:2)=[ X6,-Y6];
V(8,1:2)=[-X6, Y6];
V(7,1:2)=[ X6, Y6];
% cuadrado interior de la rueda
V(1,1:2)=D/6*[-cos(angle/2),-sin(angle)];
V(2,1:2)=D/6*[ cos(angle/2),-sin(angle)];
V(3,1:2)=D/6*[ cos(angle/2), sin(angle)];
V(4,1:2)=D/6*[-cos(angle/2), sin(angle)];

if 0
    V(1,1)=0.75*V(1,1)+0.25*V(5,1);
    V(2,1)=0.75*V(2,1)+0.25*V(6,1);
    V(3,1)=0.75*V(3,1)+0.25*V(7,1);
    V(4,1)=0.75*V(4,1)+0.25*V(8,1);
else
    fx=0.5;
    V(1,1)=fx*V(1,1);
    V(2,1)=fx*V(2,1);
    V(3,1)=fx*V(3,1);
    V(4,1)=fx*V(4,1);    
    fy=2.5;
    V(1,2)=fy*V(1,2);
    V(2,2)=fy*V(2,2);
    V(3,2)=fy*V(3,2);
    V(4,2)=fy*V(4,2);
end

% bloque que contiene la rueda
V( 9,1:2)=[-X2,-(D/2-c)];
V(10,1:2)=[-X2, (D/2-c)];
V(11,1:2)=[-X2, D];
V(12,1:2)=[-X6,D];
V(13,1:2)=[ X6,D];
V(14,1:2)=[ X2,-(D/2-c)];
V(15,1:2)=[ X2, (D/2-c)];
V(16,1:2)=[ X2, D];

% inlet
V(17,1)=-Hl;
V(18,1)=-Hl;
V(19,1)=-Hl;
V(17,2)=V(9,2);
V(18,2)=V(11,2);
V(19,2)=Hu;
% top
V(20,1)=V(11,1);
V(20,2)=Hu;
V(21,1)=V(16,1);
V(21,2)=Hu;
% outlet
V(22,1)=Hr;
V(22,2)=V(14,2);
V(23,1)=Hr;
V(23,2)=V(16,2);
V(24,1)=Hr;
V(24,2)=V(21,2);
% 4 nuevos puntos agregados que me los morfe
V(25,1)=V(17,1);
V(25,2)=V(10,2);
V(26,1)=V(22,1);
V(26,2)=V(15,2);
V(27,1)=V(12,1);
V(27,2)=V(20,2);
V(28,1)=V(13,1);
V(28,2)=V(20,2);

N2D=28;

% agregamos un plano mas de vertices
V(1:N2D,3)=-Hw;
V(N2D+(1:N2D),1:2)=V(1:N2D,1:2);
V(N2D+(1:N2D),3) = -W/2;

% agregamos 2 planos mas extremos
V(2*N2D+(1:N2D),1:2)=V(1:N2D,1:2);
V(2*N2D+(1:N2D),3) = W/2;

V(3*N2D+(1:N2D),1:2)=V(1:N2D,1:2);
V(3*N2D+(1:N2D),3) = Hw;

% bloques 1ra hilera en Z
Nxyz=[]; grading=[];
% Nro de particiones segun la perimetral a la rueda
a6=atan2(V(6,2),V(6,1));a7=atan2(V(7,2),V(7,1));
fa=(a7-a6)/(2*pi); % fraccion de angulo ocupado por la arista 6-7
Ny=ceil((2*pi*D/2*fa)/hi);Ny=Ny*2;
a8=atan2(V(8,2),V(8,1));
fa=(a8-a7)/(2*pi); % fraccion de angulo ocupado por la arista 6-7
Nx=ceil((2*pi*D/2*fa)/hi);Nx=Nx*2;
% Nro de particiones en la direccion radial fuera del bloque rectangular
Nr=ceil(norm(V(5,:)-V(1,:))/(hi/5));
% Nro de particiones horizontales sobre el piso inmediatamente en contacto 
% con la rueda
Nf=ceil((V(5,1)-V(9,1))/hi);Nf=Nf*2;
% Nro de particiones verticales en los bloques superiores adyacentes a la
% rueda
Ng=ceil((V(11,2)-V(10,2))/hi);Ng=Ng*2;
% Nro de particiones verticales en la zona mas externa
Nv=ceil((V(19,2)-V(18,2))/he);
% Nro de particiones upstream
Nu=ceil((V(9,1)-V(17,1))/he);
% Nro de particiones downstream
Nd=ceil((V(22,1)-V(14,1))/he);
% Nro de particiones en Z en el bloque central
Nzc=ceil(abs(V(5+2*N2D,3)-V(5+N2D,3))/hi);
% Nro de particiones en Z en los bloques exteriores
Nze=ceil(abs(V(5,3)-V(5+N2D,3))/(1.6*he));

% Bloques
B(1,1:4) = [1,2,3,4]     ;Nxyz=[Nxyz;[Nx,Ny,Nzc]];grading=[grading;[1,1,1/gZ]];
B(2,1:4) = [1,5,6,2]     ;Nxyz=[Nxyz;[Nr,Nx,Nzc]];grading=[grading;[1,1,1/gZ]];
B(3,1:4) = [2,6,7,3]     ;Nxyz=[Nxyz;[Nr,Ny,Nzc]];grading=[grading;[1,1,1/gZ]];
B(4,1:4) = [3,7,8,4]     ;Nxyz=[Nxyz;[Nr,Nx,Nzc]];grading=[grading;[1,1,1/gZ]];
B(5,1:4) = [4,8,5,1]     ;Nxyz=[Nxyz;[Nr,Ny,Nzc]];grading=[grading;[1,1,1/gZ]];
B(6,1:4) = [6,14,15,7]   ;Nxyz=[Nxyz;[Nf,Ny,Nzc]];grading=[grading;[1,1,1/gZ]];
B(7,1:4) = [9,5,8,10]    ;Nxyz=[Nxyz;[Nf,Ny,Nzc]];grading=[grading;[1,1,1/gZ]];
B(8,1:4) = [10,8,12,11]  ;Nxyz=[Nxyz;[Nf,Ng,Nzc]];grading=[grading;[1,1,1/gZ]];
B(9,1:4) = [8,7,13,12]   ;Nxyz=[Nxyz;[Nx,Ng,Nzc]];grading=[grading;[1,1,1/gZ]];
B(10,1:4) = [7,15,16,13] ;Nxyz=[Nxyz;[Nf,Ng,Nzc]];grading=[grading;[1,1,1/gZ]];
B(11,1:4) = [17,9,10,25] ;Nxyz=[Nxyz;[Nu,Ny,Nzc]];grading=[grading;[1/gm,1,1/gZ]];
B(12,1:4) = [18,11,20,19];Nxyz=[Nxyz;[Nu,Nv,Nzc]];grading=[grading;[1/gm,gm,1/gZ]];
B(13,1:4) = [12,13,28,27];Nxyz=[Nxyz;[Nx,Nv,Nzc]];grading=[grading;[1,gm,1/gZ]];
B(14,1:4) = [14,22,26,15];Nxyz=[Nxyz;[Nd,Ny,Nzc]];grading=[grading;[gm,1,1/gZ]];
B(15,1:4) = [16,23,24,21];Nxyz=[Nxyz;[Nd,Nv,Nzc]];grading=[grading;[gm,gm,1/gZ]];
B(16,1:4) = [25,10,11,18];Nxyz=[Nxyz;[Nu,Ng,Nzc]];grading=[grading;[1/gm,1,1/gZ]];
B(17,1:4) = [11,12,27,20];Nxyz=[Nxyz;[Nf,Nv,Nzc]];grading=[grading;[1,gm,1/gZ]];
B(18,1:4) = [13,16,21,28];Nxyz=[Nxyz;[Nf,Nv,Nzc]];grading=[grading;[1,gm,1/gZ]];
B(19,1:4) = [15,26,23,16];Nxyz=[Nxyz;[Nd,Ng,Nzc]];grading=[grading;[gm,1,1/gZ]];

NB=19; NB0=NB;
Nxyz0=Nxyz;grading0=grading;
% completo primera hilera de bloques
B(1:NB,5:8) = B(1:NB,1:4)+N2D; 
% 2da hilera de bloques

% remuevo la parte propia de la rueda
indx=(6:NB)';
B(NB+(1:length(indx)),1:8) = B(indx,1:8)+N2D;Nxyz=[Nxyz;[Nxyz0(indx,1:2),ones(length(indx),1)*Nze]];grading=[grading;[grading0(indx,1:2),ones(length(indx),1)*1]];
NB=NB+length(indx);    

% 3ra hilera de bloques
B(NB+(1:NB0),1:8) = B((1:NB0),1:8)+2*N2D;Nxyz=[Nxyz;[Nxyz0(:,1:2),ones(NB0,1)*Nze]];grading=[grading;[grading0(:,1:2),ones(NB0,1)*gZ]];
NB=NB+NB0;

vertex = V;
blocks.icone = B-1;
blocks.Nxyz = Nxyz;
blocks.grading = grading;

edges = [];
if 1
    nodes0 = [5,6,7,8]-1;
    nodes = nodes0;
%    edges = [edges; [ nodes(1) , nodes(2) , [ D/2*[cos(270*pi/180),sin(270*pi/180)],-Hw] ]];
    edges = [edges; [ nodes(2) , nodes(3) , [ D/2*[cos(  0*pi/180),sin(  0*pi/180)],-Hw] ]];
    edges = [edges; [ nodes(3) , nodes(4) , [ D/2*[cos( 90*pi/180),sin( 90*pi/180)],-Hw] ]];
    edges = [edges; [ nodes(4) , nodes(1) , [ D/2*[cos(180*pi/180),sin(180*pi/180)],-Hw] ]];
    nodes = N2D + nodes0;
%    edges = [edges; [ nodes(1) , nodes(2) , [ D/2*[cos(270*pi/180),sin(270*pi/180)],-W/2] ]];
    edges = [edges; [ nodes(2) , nodes(3) , [ D/2*[cos(  0*pi/180),sin(  0*pi/180)],-W/2] ]];
    edges = [edges; [ nodes(3) , nodes(4) , [ D/2*[cos( 90*pi/180),sin( 90*pi/180)],-W/2] ]];
    edges = [edges; [ nodes(4) , nodes(1) , [ D/2*[cos(180*pi/180),sin(180*pi/180)],-W/2] ]];
    nodes = 2*N2D + nodes0;
%    edges = [edges; [ nodes(1) , nodes(2) , [ D/2*[cos(270*pi/180),sin(270*pi/180)], W/2] ]];
    edges = [edges; [ nodes(2) , nodes(3) , [ D/2*[cos(  0*pi/180),sin(  0*pi/180)], W/2] ]];
    edges = [edges; [ nodes(3) , nodes(4) , [ D/2*[cos( 90*pi/180),sin( 90*pi/180)], W/2] ]];
    edges = [edges; [ nodes(4) , nodes(1) , [ D/2*[cos(180*pi/180),sin(180*pi/180)], W/2] ]];
    nodes = 3*N2D + nodes0;
%    edges = [edges; [ nodes(1) , nodes(2) , [ D/2*[cos(270*pi/180),sin(270*pi/180)], Hw] ]];
    edges = [edges; [ nodes(2) , nodes(3) , [ D/2*[cos(  0*pi/180),sin(  0*pi/180)], Hw] ]];
    edges = [edges; [ nodes(3) , nodes(4) , [ D/2*[cos( 90*pi/180),sin( 90*pi/180)], Hw] ]];
    edges = [edges; [ nodes(4) , nodes(1) , [ D/2*[cos(180*pi/180),sin(180*pi/180)], Hw] ]];    
end

boundaryPatches = [];
genPatchesBoundary;

% write blockMeshDict to be run by openFoam
write_blockMesh(vertex,blocks,edges,PatchesBoundary);

% corre blockMesh y checkMesh
!sh genFaceSet_2.sh

if 1
    % condiciones iniciales y de contorno
    bc=set_bc_openfoam(datos,PatchesBoundary);
    write_bc_openfoam(bc,dirname);
end

return

