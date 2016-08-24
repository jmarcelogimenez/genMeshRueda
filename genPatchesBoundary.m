%
% genPatchesBoundary routine:
%
% it serves to generate the structure PatchesBoundary for plane, axi or 3D 
%

tol = 1e-3;

% genero las caras de contorno
[ifaceb,face_con,face_con_add] = pfbou3d(V,B,1);

% divido las caras en patches
% calculo el centroide de las caras que me ayuda a definir su patch
xCFaces = xc_ele(V,face_con);
xmin=min(xCFaces); xmax=max(xCFaces);
faces_inlet  = find(abs(xCFaces(:,1)-xmin(1))<tol);
faces_outlet = find(abs(xCFaces(:,1)-xmax(1))<tol);
faces_bot    = find(abs(xCFaces(:,2)-xmin(2))<tol);
faces_top    = find(abs(xCFaces(:,2)-xmax(2))<tol);
faces_back   = find(abs(xCFaces(:,3)-xmax(3))<tol);
faces_front  = find(abs(xCFaces(:,3)-xmin(3))<tol);
if 0
    radius = norm_l2(xCFaces(:,1:2));
    faces_wheel  = find((abs(radius-(D/2))<tol)&(abs(xCFaces(:,3))<=W/2));
else
    faces_wheel = complement((1:size(face_con,1))',[faces_inlet;faces_outlet;faces_bot;faces_top;faces_front;faces_back]);
end

% patch Front & Back
nP = 1;
patchFrontBack = [face_con(faces_back,:);face_con(faces_front,:)];
PatchesBoundary(nP).name = 'Front_and_Back';
PatchesBoundary(nP).type = 'empty';
PatchesBoundary(nP).faces = patchFrontBack-1;

nP = nP+1;
patchInlet = face_con(faces_inlet,:);
PatchesBoundary(nP).name = 'Inlet';
PatchesBoundary(nP).type = 'patch';
PatchesBoundary(nP).faces = patchInlet-1;

nP = nP+1;
patchOutlet = face_con(faces_outlet,:);
PatchesBoundary(nP).name = 'Outlet';
PatchesBoundary(nP).type = 'patch';
PatchesBoundary(nP).faces = patchOutlet-1;

nP = nP+1;
patchTop = face_con(faces_top,:);
PatchesBoundary(nP).name = 'Top';
PatchesBoundary(nP).type = 'wall';
PatchesBoundary(nP).faces = patchTop-1;

nP = nP+1;
patchBot = face_con(faces_bot,:);
PatchesBoundary(nP).name = 'Bottom';
PatchesBoundary(nP).type = 'wall';
PatchesBoundary(nP).faces = patchBot-1;

nP = nP+1;
patchWheel = face_con(faces_wheel,:);
PatchesBoundary(nP).name = 'Wheel';
PatchesBoundary(nP).type = 'wall';
PatchesBoundary(nP).faces = patchWheel-1;


return

Rmax = max(XY(:,1));

if strcmp(geo,'plane')
    xmin=min(xCFaces); xmax=max(xCFaces);
    faces_top=find(abs(xCFaces(:,2)-xmax(2))<tol);
    faces_bot=find(abs(xCFaces(:,2)-xmin(2))<tol);
    
    faces_back  = find(abs(xCFaces(:,3)+Lz/2)<tol);
    faces_front = find(abs(xCFaces(:,3)-Lz/2)<tol);
    faces_inlet = find((xCFaces(:,2)>P4(2))&(xCFaces(:,2)<P5(2))&(abs(xCFaces(:,1))<tol));
    faces_out_w = find((xCFaces(:,2)>P1(2))&(xCFaces(:,2)<P2(2))&(abs(xCFaces(:,1))<tol));
    
    % outlet oil solo por la cara de radio maximo
    %faces_out_o = find((xCFaces(:,2)>P27(2))&(xCFaces(:,2)<P28(2))&(abs(xCFaces(:,1)-Rmax)<tol));
    % outlet oil por todas las caras que superan el radio del tanque
    %faces_out_o = find((xCFaces(:,2)>P27(2))&(xCFaces(:,2)<P28(2))&(xCFaces(:,1)>R));
    %faces_out_o = find((xCFaces(:,2)>P27(2))&(xCFaces(:,2)<=P28(2))&(xCFaces(:,1)>R)&(abs(xCFaces(:,3))<tol));
    faces_out_o = find((abs(xCFaces(:,2)-P27(2))<tol)&(xCFaces(:,1)>R)&(abs(xCFaces(:,3))<tol));
    
    faces_wall  = complement((1:size(face_con,1))',[faces_back;faces_front;faces_inlet;faces_out_w;faces_out_o]);
    
    % patch Front & Back
    patchFrontBack = [face_con(faces_back,:);face_con(faces_front,:)];
    nP=1;
    PatchesBoundary(nP).name = 'Front_and_Back';
    PatchesBoundary(nP).type = 'empty';
    PatchesBoundary(nP).faces = patchFrontBack-1;
    
    patchInlet = face_con(faces_inlet,:);
    nP=nP+1;
    PatchesBoundary(nP).name = 'Inlet';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchInlet-1;
        patchWall = face_con(faces_wall,:);
    nP=nP+1;
    PatchesBoundary(nP).name = 'Wall';
    PatchesBoundary(nP).type = 'wall';
    PatchesBoundary(nP).faces = patchWall-1;

    patchOutlet_w = face_con(faces_out_w,:);
    nP=nP+1;
    PatchesBoundary(nP).name = 'OutletWater';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchOutlet_w-1;
    
    patchOutlet_o = face_con(faces_out_o,:);
    nP=nP+1;
    PatchesBoundary(nP).name = 'OutletOil';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchOutlet_o-1;
    
    patchWall = face_con(faces_wall,:);
    nP=nP+1;
    PatchesBoundary(nP).name = 'Wall';
    PatchesBoundary(nP).type = 'wall';
    PatchesBoundary(nP).faces = patchWall-1;
    
    if 0
        patchWall = face_con(faces_top,:);
        nP=nP+1;
        PatchesBoundary(nP).name = 'Wall-Top';
        PatchesBoundary(nP).type = 'wall';
        PatchesBoundary(nP).faces = patchWall-1;
    end
    
else
    
    
    if strcmp(geo,'3D')
        
        xmin=min(xCFaces); xmax=max(xCFaces);
        faces_top=find(abs(xCFaces(:,2)-xmax(2))<tol);
        faces_bot=find(abs(xCFaces(:,2)-xmin(2))<tol);
        nen=size(face_con,2);
        clear radio;
        for k=1:nen
            radio(:,k) = norm_l2(XY(face_con(:,k),[1,3]));
        end
        radiomin = min(min(radio));
        radiomax = max(max(radio));
        radioavg = mean(radio')';
        
        faces_interior = find(abs(radioavg-radiomin)<tol);
        nn = find((xCFaces(faces_interior,2)>P4(2))&(xCFaces(faces_interior,2)<P5(2)));
        faces_inlet = faces_interior(nn);
        nn = find((xCFaces(faces_interior,2)>P1(2))&(xCFaces(faces_interior,2)<P2(2)));
        faces_out_w = faces_interior(nn);
        faces_out_o = find((radioavg>=R)&(abs(xCFaces(:,2)-P37(2))<tol));
        
        %faces_wall  = complement((1:size(face_con,1))',[faces_inlet;faces_out_w;faces_out_o]);
        theta_P = atan2(xCFaces(:,3),xCFaces(:,1));
        faces_front = find(abs(theta_P-angle/2)<tol);
        faces_back = find(abs(theta_P+angle/2)<tol);
        %[nor_face,bas] = get_normal_surface(XY,face_con);
        %faces_front = find((xCFaces(:,1)<0)&(abs(nor_face(:,3)-1)<tol));
        %faces_back = find((xCFaces(:,1)<0)&(abs(nor_face(:,3)+1)<tol));
        faces_wall  = complement((1:size(face_con,1))',[faces_front;faces_back;faces_inlet;faces_out_w;faces_out_o]);
        
    else
        
        xmin=min(xCFaces); xmax=max(xCFaces);
        faces_top=find(abs(xCFaces(:,2)-xmax(2))<tol);
        faces_bot=find(abs(xCFaces(:,2)-xmin(2))<tol);
        radio = norm_l2(xCFaces(:,[1,3]));
        radiomax=max(radio);
        radiomin=min(radio);
        
        faces_axis=find(abs(radio-radiomin)<tol);
        
        nn = find((xCFaces(faces_axis,2)>P4(2))&(xCFaces(faces_axis,2)<P5(2)));
        faces_inlet = faces_axis(nn);
        nn = find((xCFaces(faces_axis,2)>P1(2))&(xCFaces(faces_axis,2)<P2(2)));
        faces_out_w = faces_axis(nn);
        
        %faces_out_o = find((xCFaces(:,2)>P27(2))&(xCFaces(:,2)<P28(2))&(abs(xCFaces(:,1)-radiomax)<tol));
        %faces_out_o = find((xCFaces(:,2)>P27(2))&(xCFaces(:,2)<=P28(2))&(xCFaces(:,1)>R)&(abs(xCFaces(:,3))<tol));
        faces_out_o = find((abs(xCFaces(:,2)-P37(2))<tol)&(xCFaces(:,1)>R)&(abs(xCFaces(:,3))<tol));
        
        faces_front = find(xCFaces(:,3)<-tol);
        faces_back = find(xCFaces(:,3)>tol);
        
        faces_wall  = complement((1:size(face_con,1))',[faces_back;faces_front;faces_inlet;faces_out_w;faces_out_o]);
        
    end
    
    nP=0;
    
    if strcmp(geo,'3D')
        nP=nP+1;
        patchFront = [face_con(faces_front,:)];
        PatchesBoundary(nP).name = 'Front';
        PatchesBoundary(nP).type = 'patch'; %'cyclic';
        PatchesBoundary(nP).neighbourPatch = 'Back';
        PatchesBoundary(nP).faces = patchFront-1;
        
        nP=nP+1;
        patchBack = face_con(faces_back,:);
        PatchesBoundary(nP).name = 'Back';
        PatchesBoundary(nP).type = 'patch'; %'cyclic';
        PatchesBoundary(nP).neighbourPatch = 'Front';
        PatchesBoundary(nP).faces = patchBack-1;
        
    else
        
        nP=nP+1;
        patchFront = [face_con(faces_front,:)];
        PatchesBoundary(nP).name = 'Front';
        if strcmp(type_frontBack,'wedge')
            PatchesBoundary(nP).type = 'wedge';
        else
            PatchesBoundary(nP).type = 'wall';
        end
        PatchesBoundary(nP).faces = patchFront-1;
        
        nP=nP+1;
        patchBack = face_con(faces_back,:);
        PatchesBoundary(nP).name = 'Back';
        if strcmp(type_frontBack,'wedge')
            PatchesBoundary(nP).type = 'wedge';
        else
            PatchesBoundary(nP).type = 'wall';
        end
        PatchesBoundary(nP).faces = patchBack-1;
        
    end
    
    nP=nP+1;
    patchAxis = face_con(faces_inlet,:);
    PatchesBoundary(nP).name = 'Inlet';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchAxis-1;
    
    nP=nP+1;
    patchAxis = face_con(faces_out_w,:);
    PatchesBoundary(nP).name = 'Outlet_water';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchAxis-1;
    
    nP=nP+1;
    patchAxis = face_con(faces_out_o,:);
    PatchesBoundary(nP).name = 'Outlet_oil';
    PatchesBoundary(nP).type = 'patch';
    PatchesBoundary(nP).faces = patchAxis-1;
    
    nP=nP+1;
    patchWall = face_con(faces_wall,:);
    PatchesBoundary(nP).name = 'Wall';
    PatchesBoundary(nP).type = 'wall';
    PatchesBoundary(nP).faces = patchWall-1;
    
    if 0
        nP=nP+1;
        patchWall = face_con(faces_top,:);
        PatchesBoundary(nP).name = 'Wall-Top';
        PatchesBoundary(nP).type = 'wall';
        PatchesBoundary(nP).faces = patchWall-1;
    end
        
end
