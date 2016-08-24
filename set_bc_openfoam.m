function bc=set_bc_openfoam(data,PatchesBoundary)
%
%    bc = set_bc_openfoam(data,PatchesBoundary)
%

solver = data.solver;
Uin = data.Uin;
nP = 0;

if strcmp(solver,'pimple')

    nP=nP+1; % Front & Back
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'zeroGradient';
    bc(nP).fields(1).value = [0 0 0];
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'zeroGradient';
    bc(nP).fields(2).value = 0;
        
    nP=nP+1; % Inlet
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'fixedValue';
    bc(nP).fields(1).value = [Uin,0,0];
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'zeroGradient';
    bc(nP).fields(2).value = 0;
    
    nP=nP+1; % Outlet
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'zeroGradient';
    bc(nP).fields(1).value = [0 0 0];
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'fixedValue';
    bc(nP).fields(2).value = 0;
    
    nP=nP+1; % Top
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'fixedValue';
    bc(nP).fields(1).value = [0 0 0];
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'zeroGradient';
    bc(nP).fields(2).value = 0;
    
    nP=nP+1; % Bottom
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'fixedValue';
    bc(nP).fields(1).value = [0 0 0];
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'zeroGradient';
    bc(nP).fields(2).value = 0;
        
    nP=nP+1; % Wheel
    bc(nP).name = PatchesBoundary(nP).name;
    bc(nP).fields(1).name = 'U';
    bc(nP).fields(1).type = 'fixedValue';
    bc(nP).fields(1).value = [0 0 0]; % !!!!OJO: por el momento esta quieta
    bc(nP).fields(2).name = 'p';
    bc(nP).fields(2).type = 'zeroGradient';
    bc(nP).fields(2).value = 0;  
    
    Nbc = size(bc,2);
    Nfields = size(bc(1).fields,2);
    
    % asigno a cada campo la clase que le corresponde para el header del
    % archivo 0/p 0/U 0/alpha , etc
    for k=1:Nbc
        bc(k).fields(1).clase = 'volVectorField'; % U
        bc(k).fields(1).dim = [0 1 -1 0 0 0 0 ];
        bc(k).fields(1).initValue = [0 0 0];
        bc(k).fields(2).clase = 'volScalarField'; % p
        bc(k).fields(2).dim = [0 2 -2 0 0 0 0 ];
        bc(k).fields(2).initValue = 0;
    end    
end

return

geo = datos.geo;
solver = datos.solver;
XY = datos.XY;
bloques = datos.bloques;
type_frontBack=datos.type_frontBack;

nP=0;

if strcmp(solver,'pimple') set_bc_openfoam_pimple; end

if strcmp(solver,'mixture') set_bc_openfoam_mixture; end

if strcmp(solver,'two_fluids') set_bc_openfoam_twofluids; end


Nbc = size(bc,2);
Nfields = size(bc(1).fields,2);

% asigno a cada campo la clase que le corresponde para el header del
% archivo 0/p 0/U 0/alpha , etc
for k=1:Nbc
    
    if strcmp(solver,'pimple')
        
        bc(k).fields(1).clase = 'volVectorField'; % U
        bc(k).fields(1).dim = [0 1 -1 0 0 0 0 ];
        bc(k).fields(1).initValue = [0 0 0];
        bc(k).fields(2).clase = 'volScalarField'; % p
        bc(k).fields(2).dim = [0 2 -2 0 0 0 0 ];
        bc(k).fields(2).initValue = 0;
        
    elseif strcmp(solver,'mixture')
        
        bc(k).fields(1).clase = 'volVectorField'; % U
        bc(k).fields(1).dim = [0 1 -1 0 0 0 0 ];
        bc(k).fields(1).initValue = [0 0 0];
        bc(k).fields(2).clase = 'volScalarField'; % p_rgh
        bc(k).fields(2).dim = [1 -1 -2 0 0 0 0 ];
        bc(k).fields(2).initValue = 0;
        bc(k).fields(3).clase = 'volVectorField'; % Urlg
        bc(k).fields(3).dim = [0  1 -1 0 0 0 0 ];
        bc(k).fields(3).initValue = [0 0 0];
        bc(k).fields(4).clase = 'volScalarField'; % alpha.petroleum
        bc(k).fields(4).dim = [0 0 0 0 0 0 0 ];
        bc(k).fields(4).initValue = 0.07;
        bc(k).fields(5).clase = 'volScalarField'; % alpha.water
        bc(k).fields(5).dim = [0 0 0 0 0 0 0 ];
        bc(k).fields(5).initValue = 0.93;
        bc(k).fields(6).clase = 'volScalarField'; % k
        bc(k).fields(6).dim = [0 2 -2 0 0 0 0 ];
        bc(k).fields(6).initValue = k_inlet;
        bc(k).fields(7).clase = 'volScalarField'; % epsilon
        bc(k).fields(7).dim = [0 2 -3 0 0 0 0 ];
        bc(k).fields(7).initValue = epsilon_inlet;
        
    else
        bc(k).fields(1).clase = 'volVectorField'; % U.water
        bc(k).fields(1).dim = [0 1 -1 0 0 0 0 ];
        bc(k).fields(1).initValue = [0 0 0];
        bc(k).fields(2).clase = 'volScalarField'; % p
        bc(k).fields(2).dim = [1 -1 -2 0 0 0 0 ];
        bc(k).fields(2).initValue = 0;
        bc(k).fields(3).clase = 'volVectorField'; % U.oil
        bc(k).fields(3).dim = [0  1 -1 0 0 0 0 ];
        bc(k).fields(3).initValue = [0 0 0];
        bc(k).fields(4).clase = 'volScalarField'; % alpha.water
        bc(k).fields(4).dim = [0 0 0 0 0 0 0 ];
        bc(k).fields(4).initValue = 0.93;
        bc(k).fields(5).clase = 'volScalarField'; % alpha.oil
        bc(k).fields(5).dim = [0 0 0 0 0 0 0 ];
        bc(k).fields(5).initValue = 0.07;
        bc(k).fields(6).clase = 'volScalarField'; % k
        bc(k).fields(6).dim = [0 2 -2 0 0 0 0 ];
        bc(k).fields(6).initValue = (Uin*I)^2;;
        bc(k).fields(7).clase = 'volScalarField'; % epsilon
        bc(k).fields(7).dim = [0 2 -3 0 0 0 0 ];
        bc(k).fields(7).initValue = C_mu*(bc(3).fields(6).value)^2/(nu_lam*VR);
        
    end
end
