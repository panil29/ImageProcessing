clear all;
clc;
Video='V4';
startf=110;
endf=460;
%%
F=cell(endf-startf);
id=1;
for i=startf:endf-1
    fprintf('current frame= %d / end frame= %d \n', i, endf);
    im1=imread([Video '/00' num2str(i) '.tif']);
    im2=imread([Video '/00' num2str(i+1) '.tif']);
    [vx, vy, magitude]= ComputeOptFlow(im1, im2); %magitude=sqrt(vx.^2+vy.^2);
    meanMag=mean(magitude(:));
    F{id,1}=i;
    F{id,2}=meanMag;
    F{id,3}=vx;
    F{id,4}=vy;
    F{id,5}=magitude;
    id=id+1;
end
%%
%%% output format: frame id, mean magitude of flow, vx, vy, magitude
save(['output/' Video '_OptFlow.mat'],'F'); 