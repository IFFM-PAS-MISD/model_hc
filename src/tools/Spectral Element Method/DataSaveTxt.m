% DataSaveTxt
patch_file=[folder_name,file_name];
fileID = fopen(patch_file,'wt');
fprintf(fileID,'Time Chirp_time\n');
fprintf(fileID,'%12.16f %12.16f\n',[data.freq; data.chirp_f]);
fclose(fileID);