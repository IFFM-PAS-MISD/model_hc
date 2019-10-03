function [nodeCoordinates,elementNodes,rotation_angle]=honeycomb_core_PZT(structure,actSt)

structure_i=structure(actSt);

format long
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'core length [m]';                    Lx=structure_i.geometry(1);
'core width [m]';                     Ly=structure_i.geometry(2);
'core thick [m]';                     Lz=structure_i.geometry(3);
'shift in z direction - total thickness [m]';shiftZ=structure_i.geometry(6);
'honeycomb cell inner diagonal [m]';  D_h=structure_i.properties(end-1);
'honeycomb cell wall thickness [m]';  W_h=structure_i.properties(end);
n=structure_i.DOF(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
numCells_x=floor((Lx-2*(D_h/2+W_h/2/sin(60*pi/180)))/...
    (5*(D_h/2+W_h/2/sin(60*pi/180))));
numCells_y=floor((Ly)/(D_h*sin(60*pi/180)+W_h));

xx1=-numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))+...
(D_h+W_h/sin(60*pi/180))/2:...
   3*(D_h+W_h/sin(60*pi/180))/2:...
   numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))-...
(D_h+W_h/sin(60*pi/180))/2;
yy1=-numCells_y/2*(D_h*sin(60*pi/180)+W_h)+(D_h*sin(60*pi/180)+W_h)/2:...
    (D_h*sin(60*pi/180)+W_h):...
    numCells_y/2*(D_h*sin(60*pi/180)+W_h)-(D_h*sin(60*pi/180)+W_h)/2;

xx2=-numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))+...
   5/2*(D_h+W_h/sin(60*pi/180))/2:...
   3*(D_h+W_h/sin(60*pi/180))/2:...
   numCells_x/2*(2*(D_h+W_h/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))-...
   5/2*(D_h+W_h/sin(60*pi/180))/2;
yy2=-(numCells_y-1)/2*(D_h*sin(60*pi/180)+W_h)+(D_h*sin(60*pi/180)+W_h)/2:...
    (D_h*sin(60*pi/180)+W_h):...
    (numCells_y-1)/2*(D_h*sin(60*pi/180)+W_h)-(D_h*sin(60*pi/180)+W_h)/2;

R=(D_h+W_h/sin(60*pi/180))/2;
P_p0=[0,0,0;R,0,0];

structure0=[];

structure0.numberElements=1;

structure0.DOF=structure_i.DOF;
structure0.ksi=gll(structure0.DOF(2));
% structure0.nodeCoordinates=[P_p0;[((P_p0(2,1)-P_p0(1,1))*...
%     (structure0.ksi(2:n-1)/2+0.5))' zeros(n-2,2)]];
% structure0.elementNodes=[1 3:n 2];
structure0.nodeCoordinates=P_p0;
structure0.elementNodes=[1 2];



number_X1=size(xx1,2);
number_X2=size(xx2,2);
number_Y1=size(yy1,2);
number_Y2=size(yy2,2);



nodeCoordinates0=structure0.nodeCoordinates;
elementNodes0=structure0.elementNodes;
trans=[-R*cos(60*pi/180) -R*sin(60*pi/180) 0
            R*cos(60*pi/180) -R*sin(60*pi/180) 0
            R 0 0
            R*cos(60*pi/180) R*sin(60*pi/180) 0
            -R*cos(60*pi/180) R*sin(60*pi/180) 0
            -R 0 0];
    alpha=[0 60 120 180 240 300]*pi/180;
    %
for j=1:6
    
    R_z=[cos(alpha(j)) -sin(alpha(j)) 0;
        sin(alpha(j)) cos(alpha(j)) 0;
        0 0 1];
    P_p0=R_z*nodeCoordinates0';
    P_p0(abs(P_p0)<1e-12)=0;
    P_p0=P_p0';
    P_p0=P_p0+repmat(trans(j,:),size(P_p0,1),1);
    EN=zeros(size(elementNodes0));
    if j==1
        structure0.nodeCoordinates=P_p0;
        P_p0=[];
        
        EN=[];   
    elseif j==6
        P_p0(1:2,:)=[];
        
        EN(2)=structure0.elementNodes(1,1);
        EN(1)=structure0.elementNodes(end,2);
    else
        P_p0(1,:)=[];
        EN(1)=structure0.elementNodes(end,2);
        EN(2)=2+max(structure0.elementNodes(end,:))-1;
    end
    structure0.nodeCoordinates=[structure0.nodeCoordinates;P_p0];
    structure0.elementNodes=[structure0.elementNodes;EN];
end


%%

rotation_angleZ=cell(number_X1*number_Y1+number_X2*number_Y2,1);
elementNodes=cell(number_X1*number_Y1+number_X2*number_Y2,1);
nodeCoordinates=cell(number_X1*number_Y1+number_X2*number_Y2,1);
C1=0;
for i=1:number_X1
    for j=1:number_Y1
        C1=C1+1;
        trans=[xx1(i) yy1(j) 0];
        if i==1&&j==1
            nodeCoordinates{C1}=structure0.nodeCoordinates+...
                repmat(trans,size(structure0.nodeCoordinates,1),1);
            nodeCoordinates{C1}=round(nodeCoordinates{C1}*1e6)*1e-6;
            elementNodes{C1}=structure0.elementNodes;
            rotation_angleZ{C1}=-[0*pi/180;
                                60*pi/180;
                                120*pi/180;
                                180*pi/180;
                                240*pi/180;
                                300*pi/180];
        elseif j==1&&i~=1
            P_p0=structure0.nodeCoordinates+repmat(trans,...
                size(structure0.nodeCoordinates,1),1);
            nodeCoordinates{C1}=P_p0;
            nodeCoordinates{C1}=round(nodeCoordinates{C1}*1e6)*1e-6;
            elementNodes{C1}=structure0.elementNodes+...
                max(max(elementNodes{C1-1}));
            rotation_angleZ{C1}=-[0*pi/180;
                                60*pi/180;
                                120*pi/180;
                                180*pi/180;
                                240*pi/180;
                                300*pi/180];
        else
            P_p0=structure0.nodeCoordinates(3:end,:)+repmat(trans,...
                size(structure0.nodeCoordinates(3:end,:),1),1);
            nodeCoordinates{C1}=P_p0;
            nodeCoordinates{C1}=round(nodeCoordinates{C1}*1e6)*1e-6;
            EN_prev=elementNodes{C1-1};           
            EN=structure0.elementNodes(end-4:end,:)+max(max(elementNodes{C1-1}))-2;
            EN(1,1)=EN_prev(end-2,1);
            EN(5,2)=EN_prev(end-2,2);
            elementNodes{C1}=EN;
            rotation_angleZ{C1}=-[60*pi/180;
                                120*pi/180;
                                180*pi/180;
                                240*pi/180;
                                300*pi/180];
        end           
    end   
end

for i=1:number_X2
    for j=1:number_Y2
        C1=C1+1;
        if j==1
            EN_L=elementNodes{i-1+C1-number_X1*number_Y1};
            EN_R=elementNodes{i-1+number_Y1+C1-number_X1*number_Y1};  
                
            EN_1=structure0.elementNodes(1,:);
            EN_1(2)=EN_R(6,1);
            EN_1(1)=EN_L(2,2);
             
            EN_L=elementNodes{i+C1-number_X1*number_Y1};
            EN_R=elementNodes{i+number_Y1+C1-number_X1*number_Y1};
            EN_2=EN_1;
            EN_2(2)=EN_R(5,1);
            EN_2(1)=EN_L(1,2);
                      
            elementNodes{C1}=[EN_1;EN_2];
            rotation_angleZ{C1}=[0*pi/180;
                                 0*pi/180];
        else
            EN_L=elementNodes{i+C1-number_X1*number_Y1};
            EN_R=elementNodes{i+number_Y1+C1-number_X1*number_Y1};
            EN_1=structure0.elementNodes(1,:);
            EN_1(2)=EN_R(5,1);
            EN_1(1)=EN_L(1,2);
                      
            elementNodes{C1}=EN_1;
            rotation_angleZ{C1}=0*pi/180;
        end
    end
end
%%

 pureNC=cell2mat(nodeCoordinates(~cellfun('isempty',nodeCoordinates)) );
 C3=0;
 C4=0;
 C1_kk=cell(1,1);
 for k=setdiff(1:size(structure,2),actSt)
     if ~isempty(structure(k).piezo_type)
         C4=C4+1;
        [~,nodeCoordinates_str,~,coreElements]=...
            cell_mesh(structure(actSt));
        nodeCoordinates_str(:,1)=nodeCoordinates_str(:,1)+structure(k).geometry(4);
        nodeCoordinates_str(:,2)=nodeCoordinates_str(:,2)+structure(k).geometry(5);
        C1_kk{C4,1}=zeros(length(coreElements),2);
        for kk7=1:length(coreElements) 
            for kk=1:C1
                 aa1=[pureNC(elementNodes{kk}(:,1),1:2) ...
                        pureNC(elementNodes{kk}(:,2),1:2)]-...
                        repmat([nodeCoordinates_str(coreElements(kk7,1),1:2) ...
                        nodeCoordinates_str(coreElements(kk7,3),1:2)],...
                        size(pureNC(elementNodes{kk}),1),1);
                 aa1=ismember(abs(aa1)<1e-3,ones(1,4),'rows');   
                 aa2=[pureNC(elementNodes{kk}(:,1),1:2) ...
                        pureNC(elementNodes{kk}(:,2),1:2)]-...
                        repmat([nodeCoordinates_str(coreElements(kk7,3),1:2) ...
                        nodeCoordinates_str(coreElements(kk7,1),1:2)],...
                        size(pureNC(elementNodes{kk}),1),1);
                aa2=ismember(abs(aa2)<1e-3,ones(1,4),'rows');
                if any(aa1)
                   C3=C3+1;
                   C1_kk{C4}(kk7,:)=[kk find(aa1)];
                   elementNodes{C1+C3}=[elementNodes{kk}(aa1,1) max(max(elementNodes{C1+C3-1}))+1;
                                   max(max(elementNodes{C1+C3-1}))+1 elementNodes{kk}(aa1,2)];
                   nodeCoordinates{C1+C3}=[nodeCoordinates_str(coreElements(kk7,2),1:2) ...
                                    unique(pureNC(:,3))];
                   rotation_angleZ{C1+C3}=[rotation_angleZ{kk}(aa1,1);rotation_angleZ{kk}(aa1,1)];
                 end
                 if any(aa2)
                    C3=C3+1;
                    C1_kk{C4}(kk7,:)=[kk find(aa2)];
                    elementNodes{C1+C3}=[elementNodes{kk}(aa2,1) max(max(elementNodes{C1+C3-1}))+1;
                                    max(max(elementNodes{C1+C3-1}))+1 elementNodes{kk}(aa2,2)];
                    nodeCoordinates{C1+C3}=[nodeCoordinates_str(coreElements(kk7,2),1:2) ...
                                    unique(pureNC(:,3))];
                    rotation_angleZ{C1+C3}=[rotation_angleZ{kk}(aa2,1);rotation_angleZ{kk}(aa2,1)];
                    
                end
            end
        end
     end
 end
 %%
C1_kk=cell2mat(C1_kk);
aa=sort(unique(C1_kk(:,1)),'descend');
aa=aa(aa>0);
for i=1:size(aa,1);
    elementNodes{aa(i)}(C1_kk(C1_kk(:,1)==aa(i),2),:)=[];
    rotation_angleZ{aa(i)}(C1_kk(C1_kk(:,1)==aa(i),2),:)=[];
end
    
nodeCoordinates=cell2mat(nodeCoordinates(~cellfun('isempty',nodeCoordinates)));
elementNodes=cell2mat(elementNodes);
rotation_angleZ=cell2mat(rotation_angleZ);

n_int=n-2;
max_Node=max(max(elementNodes));
ksi_int=structure0.ksi(2:n-1);
nodeCoordinates_temp=zeros(size(elementNodes,1)*n_int,3);


elementNodes=[elementNodes(:,1) reshape(1:size(elementNodes,1)*n_int,n_int,[])'+max_Node ...
    elementNodes(:,2)];

for i=1:size(elementNodes,1);
    n_en=elementNodes(i,[1,n]);
    for k=1:3
        nodeCoordinates_temp(1+n_int*(i-1):n_int*(1+(i-1)),k)=...
            (nodeCoordinates(n_en(2),k)+...
             nodeCoordinates(n_en(1),k)+...
            (nodeCoordinates(n_en(2),k)-...
             nodeCoordinates(n_en(1),k))*ksi_int')/2;
    end   
end
nodeCoordinates=[nodeCoordinates;nodeCoordinates_temp];

rotation_angle=zeros(size(rotation_angleZ,1),3);
rotation_angle(:,1)=-90*pi/180;
rotation_angle(:,3)=rotation_angleZ;

%%
nC=cell(n,1);
eN=cell(1,n);
zeta=structure0.ksi*Lz/2+shiftZ;
for i=1:n
    nC{i}=[nodeCoordinates(:,1:2) ones(length(nodeCoordinates),1)*zeta(i)];
    if i==1
        eN{i}=elementNodes;
    else
        eN{i}=elementNodes+max(max(eN{i-1}));
    end
end
nodeCoordinates=cell2mat(nC);
elementNodes=cell2mat(eN);
nodeCoordinates=round(nodeCoordinates*1e6)*1e-6;
%%
% elementNodes=[structure(1).elementNodes structure(1).elementNodes(:,1)];
% nodeCoordinates=structure(1).nodeCoordinates;
%     for j=size(elementNodes,1):-1:1
%         disp([j size(elementNodes,1)])
%         plot(nodeCoordinates(elementNodes(j,:),1),nodeCoordinates(elementNodes(j,:),2))
%         hold on
%         axis equal
%         pause()
%         clc
%     end
end