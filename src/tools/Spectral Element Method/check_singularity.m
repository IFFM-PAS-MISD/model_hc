function [err_n,err_el]=check_singularity(step,err_n,err_el)
[~, msgid] = lastwarn;
if (strcmp(msgid,'MATLAB:singularMatrix')||strcmp(msgid,'MATLAB:nearlySingularMatrix'))==1
    err_n=err_n+1;
    err_el(err_n)=step;
else
end
  
end