function write_blockMesh(vertex,blocks,edges,PatchesBoundary)
%
%  Write a blockMeshDict file from a geometry input by Octave
%
%   write_blockMesh(vertex,blocks,edges,PatchesBoundary)
%
%  vertex como un tipico xnod
%
%  blocks se ingresa como estructura
%    blocks.icone [n1 n2 n3 n4 n5 n6 n7 n8]
%    blocks.Nxyz [nx ny nz]
%    blocks.grading (gx gy gz)
%
%  edges por el momento lo consideramos vacio
%
%  PatchesBoundary con el formato siguiente (por ejemplo):
%
%  PatchesBoundary(nP).name = 'ChapaFixed';
%  PatchesBoundary(nP).type = 'wall';
%  PatchesBoundary(nP).faces = patchChapaFixed [n1 n2 n3 n4];
%

fid = fopen('blockMeshDict','w');

header_file_foam_blockMesh;

for k=1:size(header_foam_file,1);
    fprintf(fid,' %s \n',header_foam_file(k,:));
end

fprintf(fid,' \n');
fprintf(fid,'convertToMeters 1; \n');
fprintf(fid,' \n');
fprintf(fid,' \n');
fprintf(fid,'vertices \n');
fprintf(fid,'( \n');

xnod = vertex;
NN=size(xnod,1);
for k=1:NN
    fprintf(fid,'( %20.12f %20.12f %20.12f ) \n',xnod(k,1:3));
end

fprintf(fid,'); \n');
    
blocks_icone = blocks.icone;
blocks_Nx = blocks.Nxyz;
blocks_Gr = blocks.grading;

fprintf(fid,' \n');
fprintf(fid,' \n');
fprintf(fid,'blocks \n');
fprintf(fid,'( \n');
if isfield(blocks,'region')
    for k=1:size(blocks_icone,1)
            blocks_region = blocks.region(k,:);
  fprintf(fid,'hex ( %5i %5i %5i %5i %5i %5i %5i %5i )  %s (%5i %5i %5i) simpleGrading (%20.12f %20.12f %20.12f) \n', ...          
            blocks_icone(k,:),blocks_region,blocks_Nx(k,:),blocks_Gr(k,:));
    end
else
for k=1:size(blocks_icone,1)
    fprintf(fid,'hex ( %5i %5i %5i %5i %5i %5i %5i %5i ) (%5i %5i %5i) simpleGrading (%20.12f %20.12f %20.12f) \n', ...
        [blocks_icone(k,:),blocks_Nx(k,:),blocks_Gr(k,:)]);
end
end
fprintf(fid,'); \n');

fprintf(fid,' \n');

if isempty(edges)==0
%    error(' Edges writing not available yet');
fprintf(fid,'edges \n');
fprintf(fid,'( \n');
for kedge=1:size(edges,1)
fprintf(fid,' arc %5i %5i ( %20.12f %20.12f %20.12f ) \n',edges(kedge,:));
end
%    arc 1 5 (1.1 0.0 0.5)
fprintf(fid,'); \n');

else
fprintf(fid,'edges \n');
fprintf(fid,'( \n');
fprintf(fid,'); \n');    
end


nPatchesBoundary = size(PatchesBoundary,2);
fprintf(fid,' \n');
fprintf(fid,'boundary \n');
fprintf(fid,'( \n');
for k=1:nPatchesBoundary
    fprintf(fid,'     %s \n',PatchesBoundary(k).name);
    fprintf(fid,'     { \n');
    fprintf(fid,'         type  %s ; \n',PatchesBoundary(k).type);
    if strcmp(PatchesBoundary(k).type,'cyclic')
        fprintf(fid,'         neighbourPatch  %s ; \n',PatchesBoundary(k).neighbourPatch);
    end
    fprintf(fid,'         faces  \n');
    fprintf(fid,'         ( \n');
    for kk=1:size(PatchesBoundary(k).faces,1)
        fprintf(fid,'         ( %5i %5i %5i %5i ) \n',PatchesBoundary(k).faces(kk,:));
    end
    fprintf(fid,'         ); \n');
    fprintf(fid,'     } \n');
end
fprintf(fid,'); \n');

fprintf(fid,' \n');
fprintf(fid,'mergePatchPairs \n');
fprintf(fid,'( \n');
fprintf(fid,'); \n');
fprintf(fid,' \n');
fprintf(fid,' \n');
fprintf(fid,'// ************************************************************************* // \n');

fclose(fid)
