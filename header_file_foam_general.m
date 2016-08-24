function header_foam_file = header_file_foam_general(versione,formato,clase,folder,objeto)
%
%    header_foam_file = header_file_foam_general(versione,formato,clase,folder,objeto) 
%
%    A trial to a General header for openfoam files  
% 
%   as default we have 
%
%    versione  = '2.3.0';
%    formato   = 'ascii';
%    clase     = 'dictionary';
%    folder    = 'constant/polyMesh';    
%    objeto    = 'blockMeshDict';
%

if nargin < 1
    versione  = '2.3.0';
    formato   = 'ascii';
    clase     = 'dictionary';
    folder    = 'constant/polyMesh';    
    objeto    = 'blockMeshDict';
elseif nargin < 5
    error(' not enough arguments - (versione,formato,clase,folder,objeto) ')
end
   

row1=  '/*--------------------------------*- C++ -*----------------------------------*\';
row2=  '| =========                 |                                                 |';
row3=  '| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |';
row4= ['|  \\    /   O peration     | Version:  ' versione '                                 |'];

row5=  '|   \\  /    A nd           | Web:      www.OpenFOAM.org                      |';
row6=  '|    \\/     M anipulation  |                                                 |';
row7=  '\*---------------------------------------------------------------------------*/';
row8=  'FoamFile                                                                       ';
row9=  '{                                                                              ';
row10=['    version     ' versione ';                                                           '];
row11=['    format      ' formato  ';                                                         '];
row12=['    class       ' clase ';                                                    '];
row13=['    location    ' folder ';                                                    '];
row14=['    object      ' objeto ';                                                 '];
row15= '}                                                                              ';
row16= '// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //';

header_foam_file = strvcat(row1,row2,row3,row4,row5,row6,row7,row8,row9,row10,row11,row12,row13,row14,row15,row16);

return

header_foam_file(1,:)=  '/*--------------------------------*- C++ -*----------------------------------*\';
header_foam_file(2,:)=  '| =========                 |                                                 |';
header_foam_file(3,:)=  '| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |';
header_foam_file(4,:)= ['|  \\    /   O peration     | Version:  ' versione '                          |'];
header_foam_file(5,:)=  '|   \\  /    A nd           | Web:      www.OpenFOAM.org                      |';
header_foam_file(6,:)=  '|    \\/     M anipulation  |                                                 |';
header_foam_file(7,:)=  '\*---------------------------------------------------------------------------*/';
header_foam_file(8,:)=  'FoamFile                                                                       ';
header_foam_file(9,:)=  '{                                                                              ';
header_foam_file(10,:)=['    version     ' versione ';                                                           '];
header_foam_file(11,:)=['    format      ' formato  ';                                                         '];
header_foam_file(12,:)=['    class       ' clase ';                                                    '];
header_foam_file(13,:)=['    location    ' folder ';                                                    '];
header_foam_file(14,:)=['    object      ' objeto ';                                                 '];
header_foam_file(15,:)= '}                                                                              ';
header_foam_file(16,:)= '// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //';
