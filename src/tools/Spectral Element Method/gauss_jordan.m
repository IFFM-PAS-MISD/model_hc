function inv_matrix = gauss_jordan(matrix)
% Gauss-Jordan method
durationtime = 0;
tic
a = matrix;
[m,n]=size(a);
I = speye(m);
for j = 1 : m-1
    %durationtime = procTime(j,m-1,durationtime,'invertion_1');
    
    for z = 2 : m
        clc; disp([j z m])
        if a(j,j) == 0
            t = a(1,:); a(1,:) = a(z,:);
            a(z,:) = t;
            
            t = I(1,:); I(1,:) = I(z,:);
            I(z,:) = t;
            
        end
    end
    for i = j + 1 : m
       clc; disp([j i m])
        aa = a(i,j)/a(j,j);
        a(i,:) = a(i,:)-a(j,:)*aa;
        I(i,:) = I(i,:)-I(j,:)*aa;
       
    end
end

for j = m : -1 : 2
    durationtime = procTime(j,2,durationtime,'invertion_2');
    for i = j-1 : -1 : 1
        aa = a(i,j)/a(j,j);
        a(i,:) = a(i,:)-a(j,:)*aa;
        I(i,:) = I(i,:)-I(j,:)*aa;
    end
end

for s = 1 : m
    durationtime = procTime(j,m,durationtime,'invertion_3');
    aa = a(s,s);
    a(s,:) = a(s,:)/aa;
    I(s,:) = I(s,:)/aa;
    x(s) = a(s,n);
end
inv_matrix = I;
disp('Gauss-Jordan method:');
disp(durationtime)