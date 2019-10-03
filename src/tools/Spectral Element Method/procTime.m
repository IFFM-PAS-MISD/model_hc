function durationtime = procTime(iStep,nSteps,durationtime,proc_name)
% PROCTIME   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = procTime(input1,input2,input3) 
% 
% Inputs: 
%    iStep - i-th time step, int, dimensions 1, Units: [-] 
%    nSteps - total number of steps, int, dimensions 1, Units: [-] 
%    proc_name - name of the , Description, double, dimensions [m, n], Units: N 
% 
% Outputs: 
%    durationtime - total time of completed process, double, dimensions 1, Units: s 
% 
% Example: 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2 
% 

% Author: Piotr Fiborek, M.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 

%

if ~exist('durationtime','var');durationtime = 0; end
if ~exist('proc_name','var');proc_name = 'miscellaneous'; end

proc_done = [repmat('-',1,floor(iStep/nSteps*100)) ...
    repmat('_',1,100-floor(iStep/nSteps*100))];
proc_done(49:49+length(num2str(floor(iStep/nSteps*100)))) = ...
    [num2str(floor(iStep/nSteps*100)) '%'];
message_3=proc_done;
message_1=sprintf('Please wait... point %4.0f from %8.0f\n', iStep, nSteps);
    
    
if iStep<floor(nSteps/100)
    clc; disp(proc_name); disp(message_1) 
    if ismember(iStep,1:7:floor(nSteps/100)*7-6)   
        disp('Finish date is evaluating......     |     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+1)
        disp('Finish date is evaluating......     /     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+2)
        disp('Finish date is evaluating......     -     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+3)
        disp('Finish date is evaluating......     \     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+4)
        disp('Finish date is evaluating......     |     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+5)
        disp('Finish date is evaluating......     /     ')
    elseif ismember(iStep,(1:7:floor(nSteps/100)*7-6)+6)
        disp('Finish date is evaluating......     -     ')
    end
    disp(message_3)
elseif ~mod(iStep,ceil(nSteps/100))
    clc;
    durationtime = durationtime + toc;
    time_av = durationtime/iStep;
    time_re = time_av*(nSteps-iStep);
    time_rehtot = time_re/3600;
    time_red = time_rehtot/24;
    time_reh = 24*(time_red-floor(time_red));
    time_rem = 60*(time_reh-floor(time_reh));
    time_res = 60*(time_rem-floor(time_rem));
    time_0 = clock();
    time_add = [0,0,floor(time_red),floor(time_reh),floor(time_rem),floor(time_res)];
    calendar = [31,28,31,30,31,30,31,31,30,31,30,31];
    if rem(time_0(1),4)==0
          calendar(2) = 29;
    end
    time_0(6) = floor(time_0(6));
    for i = 6:-1:1
        if i == 5 || i == 6
            if (time_0(i)+time_add(i)) < 60
                time_finish(i) = (time_0(i)+time_add(i));
            else
                time_finish(i) = (time_0(i)+time_add(i))-60; 
                time_0(i-1) = time_0(i-1)+1;
            end
        elseif i == 4
            if (time_0(i)+time_add(i)) < 24
                time_finish(i) = (time_0(i)+time_add(i));
            else
                time_finish(i) = (time_0(i)+time_add(i))-24; 
                time_0(i-1) = time_0(i-1)+1;
            end
        elseif i == 3
            if (time_0(i)+time_add(i)) <= calendar(time_0(i-1))
                time_finish(i) = (time_0(i)+time_add(i));
            else
                time_finish(i) = rem((time_0(i)+time_add(i)),calendar(time_0(i-1))); 
                time_0(i-1) = time_0(i-1)+floor((time_0(i)+time_add(i))/calendar(time_0(i-1)));
            end
        elseif i == 2
            if (time_0(i)+time_add(i))<=12
                time_finish(i)=time_0(i);
            else
                time_finish(i)=rem(time_0(i),12); 
                time_0(i-1)=time_0(i-1)+floor(time_0(i)/12);
            end
        elseif i==1
            time_finish(i)=time_0(i);
        end
    end
    if any(isnan(time_finish) + isinf(time_finish))
        time_finish = clock;
    end
    message_1 = sprintf('Please wait... point %4.0f from %8.0f\n', iStep, nSteps);
    message_2 = ['Estimated finish date: ', datestr(time_finish)];
    message_3 = proc_done;
    disp(proc_name) 
    disp(message_1)
    disp(message_2)
    disp(message_3)
    tic
end

%---------------------- END OF CODE---------------------- 

% ================ [procTime.m] ================  
