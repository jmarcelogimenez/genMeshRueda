cp blockMeshDict run_2/constant/polyMesh
cd run_2 
blockMesh > log.blockMesh
checkMesh > log.checkMesh
gunzip constant/polyMesh/*.gz
cd ..

