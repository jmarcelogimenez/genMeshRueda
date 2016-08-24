function vout = write_bc_openfoam(bc,dirname)
%
%  bc(indx).name
%  bc(indx).fields(k).name = U,p,alpha, etc
%  bc(indx).fields(k).type = fixedValue, zeroGradient, fixedGradient, etc
%  bc(indx).fields(k).value scalar or vector (assumed currently uniform)
%
% for example
%
%  bc(nP).name = PatchesBoundary(nP).name;
%  bc(nP).fields(1).name = 'U';
%  bc(nP).fields(1).type = 'fixedValue';
%  bc(nP).fields(1).value = [0 0 0];
%  bc(nP).fields(2).name = 'p';
%  bc(nP).fields(2).type = 'zeroGradient';
%  bc(nP).fields(2).value = 0; 

Nbc = size(bc,2);
Nfields = size(bc(1).fields,2);

versione  = '2.3';
formato   = 'ascii';
folder    = '0';

% apertura de todos los archivos de la carpeta 0
for k=1:Nfields,    
    filename = bc(1).fields(k).name;
    fid = fopen([dirname '/0/' filename],'w');
    eval(['fid' num2str(k) '=fid;']);    
    objeto = bc(1).fields(k).name;    
    clase =  bc(1).fields(k).clase;    
    header_foam_file = header_file_foam_general(versione,formato,clase,folder,objeto);
    
    for k=1:size(header_foam_file,1);    
        fprintf(fid,' %s \n',header_foam_file(k,:));
    end
        
    fprintf(fid,' \n');    
end

% escribo el resto del contenido de cada archivo
for k=1:Nfields,    
    eval(['fidp = fid' num2str(k) ';']);
    fprintf(fidp,' \n');
    fprintf(fidp,' dimensions   [ %1i %1i %1i %1i %1i %1i %1i ]; \n',bc(1).fields(k).dim); 
    fprintf(fidp,' \n');    
    value = bc(1).fields(k).initValue;
    Ncmp = size(value,2);
    fmt=[];
    if Ncmp>1,
    fmt=[fmt, ' ('];
    end
    fmt0 = ' %12.7e' ; % ' %20.12f' ; % ' %10.5f'
    for kcmp=1:Ncmp
        %fmt=[fmt,' %10.5f'];
        %fmt=[fmt,' %20.12f'];
        %fmt=[fmt,' %12.7e'];
        fmt=[fmt, fmt0];
    end    
    if Ncmp>1,
    fmt=[fmt, ' )'];
    end
    fmt2 = [' internalField  \t uniform ' fmt '; \n'];
    fprintf(fidp,fmt2,value);
    fprintf(fidp,' \n');    
    fprintf(fidp,' boundaryField \n');
    fprintf(fidp,'{ \n');    
    
    for kbc=1:Nbc
    
        fprintf(fidp,'     %s \n',bc(kbc).name);    
        fprintf(fidp,'     { \n')   ;
        fprintf(fidp,'        type %s ; \n',bc(kbc).fields(k).type);
        if ~strcmp(bc(kbc).fields(k).type,'empty')&~strcmp(bc(kbc).fields(k).type,'wedge');
            value = bc(kbc).fields(k).value;
            if strcmp(bc(kbc).fields(k).type,'fixedValue');
                fmt2 = ['        value \t \t uniform ' fmt '; \n'];
            elseif strcmp(bc(kbc).fields(k).type,'flowRateInletVelocity')                
                %fmt2 = ['        volumetricFlowRate \t \t constant %10.5f ' '; \n'];                
                fmt2 = ['        volumetricFlowRate \t \t constant ' fmt0 ' ' '; \n'];                
            else
                %fmt2 = ['        value \t \t uniform %10.5f ; \n'];                
                fmt2 = ['        value \t \t uniform ' fmt '; \n'];                
            end
            fprintf(fidp,fmt2,value);
            if strcmp(bc(kbc).fields(k).type,'inletOutlet')
                fmt2 = ['        inletValue \t \t uniform ' fmt '; \n'];
                fprintf(fidp,fmt2, bc(kbc).fields(k).inletvalue);
            end
        end
        fprintf(fidp,'     } \n');
    end    
    fprintf(fidp,'} \n')    ;

fprintf(fidp,' \n');
fprintf(fidp,'// ************************************************************************* // \n');

end

% cierre de todos los archivos de la carpeta 0
for k=1:Nfields,    
    eval(['fclose(fid' num2str(k) ');'])        ;
end

return
