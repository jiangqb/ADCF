function [R IM]=ATbyA(im,X,Y)
[H W]=size(im);
X=X(:);Y=Y(:);
Z=X+i*Y;
[Z1 Z2]=mymeshgrid(Z,Z);
DZ=Z2-Z1;
% DZ=DZ-(1+i);
X1=mod(real(DZ)+W,W)+1;
Y1=mod(imag(DZ)+H,H)+1;
% tic;
 IM=fft2(im);
 AR=ifft2(IM.*conj(IM));
% toc;
% R=zeros(length(X
R=[];
% disp('get r time:');
% tic;
Indx=sub2ind(size(AR),Y1(:),X1(:));
% toc;
% tic;
R=AR(Indx);
% toc;

R=reshape(R,[length(X) length(X)]);