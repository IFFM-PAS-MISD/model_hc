function [locations,weights]=gaussQuadrature(ksi,eta,zeta,wi_x,wi_y,wi_z,DOF)

n=length(ksi);
if DOF==3
locations=zeros(length(ksi)*length(eta)*length(zeta),3);
weights=zeros(length(ksi)*length(eta)*length(zeta),1);
if n>=3
for k=1:length(zeta)
    for j=1:length(eta)
        for i=1:length(ksi)
           
            locations(i+length(eta)*(j-1)+length(eta)*length(ksi)*(k-1),:)=...
               [ksi(i),eta(j),zeta(k)];
            weights(i+length(eta)*(j-1)+length(eta)*length(ksi)*(k-1))=...
               wi_x(i)*wi_y(j)*wi_z(k);
           
        end
    end
  
end

    
elseif n==2
      locations(1,:)=[ksi(1),eta(1),zeta(1)];
      locations(2,:)=[ksi(2),eta(1),zeta(1)];
      locations(3,:)=[ksi(2),eta(2),zeta(1)];
      locations(4,:)=[ksi(1),eta(2),zeta(1)];
      locations(1,:)=[ksi(1),eta(1),zeta(2)];
      locations(2,:)=[ksi(2),eta(1),zeta(2)];
      locations(3,:)=[ksi(2),eta(2),zeta(2)];
      locations(4,:)=[ksi(1),eta(2),zeta(2)];
      
      
      weights(1,:)=wi_x(1)*wi_y(1)*wi_z(1);
      weights(2,:)=wi_x(2)*wi_y(1)*wi_z(1);
      weights(3,:)=wi_x(2)*wi_y(2)*wi_z(1);
      weights(4,:)=wi_x(1)*wi_y(2)*wi_z(1);
      weights(1,:)=wi_x(1)*wi_y(1)*wi_z(2);
      weights(2,:)=wi_x(2)*wi_y(1)*wi_z(2);
      weights(3,:)=wi_x(2)*wi_y(2)*wi_z(2);
      weights(4,:)=wi_x(1)*wi_y(2)*wi_z(2);
end
elseif DOF==5
locations=zeros(length(ksi)*length(eta),2);
weights=zeros(length(ksi)*length(eta),1);
    
if n>=3
    for j=1:length(eta)
        for i=1:length(ksi)
           
            locations(i+length(eta)*(j-1),:)=...
               [ksi(i),eta(j)];
            weights(i+length(eta)*(j-1))=...
               wi_x(i)*wi_y(j);
           
        end
    end
      
elseif n==2
      locations(1,:)=[ksi(1),eta(1)];
      locations(2,:)=[ksi(2),eta(1)];
      locations(3,:)=[ksi(2),eta(2)];
      locations(4,:)=[ksi(1),eta(2)];
      
      
      weights(1,:)=wi_x(1)*wi_y(1);
      weights(2,:)=wi_x(2)*wi_y(1);
      weights(3,:)=wi_x(2)*wi_y(2);
      weights(4,:)=wi_x(1)*wi_y(2);
      
end
end
       





