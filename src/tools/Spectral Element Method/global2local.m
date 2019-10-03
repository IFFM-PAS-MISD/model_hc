% R_xyz matrix transforamtion global to local
function R_xyz=global2local(alpha, beta, gamma)

R_x=round([1 0 0;
           0 cos(alpha) -sin(alpha);
           0 sin(alpha) cos(alpha)].*1e8).*1e-8;
R_y=round([cos(beta) 0 sin(beta);
           0 1 0;
           -sin(beta) 0 cos(beta)].*1e8).*1e-8;
R_z=round([cos(gamma) -sin(gamma) 0;
           sin(gamma) cos(gamma) 0;
           0 0 1].*1e8).*1e-8;   
                    
R_xyz=round((R_x*R_y*R_z)*1e6)*1e-6;
end