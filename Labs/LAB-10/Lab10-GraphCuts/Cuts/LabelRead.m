function label = LabelRead(FileName)
label = [];
fid = fopen(FileName,'r');
dim = fscanf(fid,'w=%d h=%d');
buff = textscan(fid,'%u','Delimiter','\t');
label = buff{1};
label = reshape(label,dim(1),dim(2)); % reshape is column based
label = label';
fclose(fid);
end
