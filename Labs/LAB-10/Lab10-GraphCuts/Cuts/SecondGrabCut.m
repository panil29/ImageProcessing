% Use the GrabCut matlab code in http://grabcut.weebly.com/code.html
% input: I:RGB color image; mask: binary mask
% output: SegMask: binary seg mask ; SegResult: color seg result; e: data
% energy+smooth energy
function [SegMask SegResult e] = SecondGrabCut(I,mask,maxIter)
imd = double(I);
mask=im2bw(mask,0.5);
mask=1-mask;
fixedBG=im2bw(mask,0.5);
Beta = 0.3;
k = 5;
G = 50;
diffThreshold = 0.001;
%%
[L e] = GCAlgo(imd, fixedBG,k,G,maxIter, Beta, diffThreshold);
L = double(1 - L);
CurrRes = imd.*repmat(L , [1 1 3]);
SegMask=im2bw(L,0.5);
SegResult=uint8(CurrRes);