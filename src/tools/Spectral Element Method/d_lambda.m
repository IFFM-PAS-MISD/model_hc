clc; disp('iMpC matrix...')
MpC = cell(size(structure,2),1); M = cell(size(structure,2),1);
iMpC = cell(size(structure,2),1); MmC = cell(size(structure,2),1);

for i = 1:size(structure,2)
    M{i} = structure(i).Mass;
    MpC{i} = structure(i).Mass+0.5*ts*structure(i).Damp;
    iMpC{i} = 1./MpC{i};
    MmC{i} = structure(i).Mass-0.5*ts*structure(i).Damp;
end
M = cell2mat(M);    MpC = cell2mat(MpC);
iMpC = cell2mat(iMpC);  MmC = cell2mat(MmC);
M = sparse((1:size(M,1))',(1:size(M,1))',M);
MpC = sparse((1:size(MpC,1))',(1:size(MpC,1))',MpC);
MmC = sparse((1:size(MmC,1))',(1:size(MmC,1))',MmC);
iMpC = sparse((1:size(iMpC,1))',(1:size(iMpC,1))',iMpC);

clc; disp('iMpC matrix...done')
if size(structure,2)>1
    disp('G matrix...');intLay=[];
    for i = 1:size(structure,2)
        for ii = 1:size(structure(i).stAttach,2)
                intLay = [intLay,[i;structure(i).stAttach(1,ii)]];
        end
    end
    intLay = sort(intLay);
    intLay = unique(intLay','rows');
    G = cell(size(intLay,1),size(structure,2));
    for i = 1:size(intLay,1)
        disp(i)
        firstLayer=size(find(intLay(1:i,:)==intLay(i,1)),1);
        secondLayer=size(find(intLay(1:i,:)==intLay(i,2)),1);
        G{i,intLay(i,1)} = structure(intLay(i,1)).stAttach(2,firstLayer)*...
                           structure(intLay(i,1)).B{firstLayer};
        G{i,intLay(i,2)} = structure(intLay(i,2)).stAttach(2,secondLayer)*...
                           structure(intLay(i,2)).B{secondLayer};
        for j = setdiff(1:size(structure,2),intLay(i,:))
                G{i,j} = sparse([],[],[],size(structure(intLay(i,1)).B{firstLayer},1),...
                         structure(j).GDof,0);
        end
    end
    clc;    disp('G matrix....done');     disp('d0 matrix.......')
    d0 = sparse(cell2mat(G)*iMpC*cell2mat(G)');
    clc;    disp('G matrix....done');    disp('d0 matrix...done')
    disp('id0 matrix........');    clc;    disp('G matrix....done');
    disp('d0 matrix...done');    disp('id0 matrix....done');
    disp('d matrix........')
    d1 = cell2mat(G)*iMpC;
    disp('G matrix....done');    disp('d0 matrix...done')
    disp('ido matrix....done');    disp('d matrix....done')
    G = cell2mat(G);    
    
end
