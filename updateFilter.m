function [As bs coeffses filters Temporalreglambda]=updateFilter(ft_search_area, target_block_sz, block_pos,output_sigma, As,bs,coeffses,interp_factor,IterN,wintype,FiltersCoeffs,lambda,Temporalreglambda,Spatialreglambda,Ss)

[X Y X0 Y0]=getFilterStructure(ft_search_area,target_block_sz);
feature_sz=[size(ft_search_area,1) size(ft_search_area,2)];
g=getGaussianfun(feature_sz,output_sigma);
 [As1 bs1 Cs1]=getModel(ft_search_area,g,X,Y);
 
%================
if isempty(As)
    As=As1;
    bs=bs1;
    Cs=cellfun(@(x) (x*(0)),As,'uniformoutput', false);
else
    A0=cellfun(@(x) (x*(1-interp_factor)),As,'uniformoutput', false);
    A1=cellfun(@(x) (x*interp_factor),As1,'uniformoutput', false);
    As=cellfun(@(x,y) x+y, A0,A1,'uniformoutput', false);
    b0=cellfun(@(x) (x*(1-interp_factor)),bs,'uniformoutput', false);
    b1=cellfun(@(x) (x*interp_factor),bs1,'uniformoutput', false);
    bs=cellfun(@(x,y) x+y, b0,b1,'uniformoutput', false);
end
%------------

if ~isempty(FiltersCoeffs)
    h_ref=FiltersCoeffs{max([1 numel(FiltersCoeffs)-15])};
else
    h_ref=bs;
end

%---temporal reg
    interp_factor_reg=1;
    Temporalreglambda=Temporalreglambda*(1-interp_factor_reg)+lambda*interp_factor_reg;
%-------------------

A=cellfun(@(x) (x+Temporalreglambda*eye(size(x,1))),As,'uniformoutput', false);
if ~isempty(Ss)
Ss1=cellfun(@(x) (x*Spatialreglambda),Ss,'uniformoutput', false);
A=cellfun(@(x,y) (x+y),A,Ss1,'uniformoutput', false);
end
h_ref=cellfun(@(x) (Temporalreglambda*x),h_ref,'uniformoutput', false);
b=cellfun(@(x,y) (x+y),bs, h_ref, 'uniformoutput', false);
%-------------
[coeffses relres iters]=conjGradDes(A,b,IterN,coeffses);
filters=coeffses2filters(coeffses,X0,Y0,target_block_sz(1), target_block_sz(2));


function filters=coeffses2filters(coeffses,X0,Y0,h,w)
filters=[];
for i=1:size(coeffses,2)
    filter=reshape(coeffses{i},h,w);
    filters=cat(3,filters,filter);
end

function [As bs Cs]=getModel(features,g,X,Y)
As=cell(0);bs=cell(0);Cs=cell(0);
G=fft2(g);
for i=1:size(features,3)
x=X{i};y=Y{i};
[A F]=ATbyA(features(:,:,i),x,y);
b=ifft2(G.*conj(F),'symmetric');%not equal ifft2(fft2(im).*conj(fft2(g)));
b=b(sub2ind(size(b),y(:),x(:)));
As{end+1}=A;
bs{end+1}=b;
end



function [xs relres iters]=conjGradDes(As,bs,iter,int_xs)
xs=cell(0);
relres=[];
 iters=[];
for i=1:numel(As)
    if ~isempty(int_xs)
        x0=int_xs{i};
    else
        x0=ones(size(bs{i}));
    end
A=As{i};b=bs{i};
[x, iter, res]=conjGrad(A,x0,b,iter);
% xs=[xs x];
xs{end+1}=x;
relres=[relres;res];
iters=[iters; iter];
end

function [x, numIter, rsnew]=conjGrad(A,x,b,iter,epsilon)

if nargin <5; epsilon=1.0e-9;end
% function [x] = conjgrad(A, b, x)
    r = b - A * x;
    p = r;
    rsold = r' * r;

    for numIter = 1:min([iter length(b)])
        Ap = A * p;
        alpha = rsold / (p' * Ap);
        x = x + alpha * p;
        r = r - alpha * Ap;
        rsnew = r' * r;
        if sqrt(rsnew) < epsilon
              break;
        end
        p = r + (rsnew / rsold) * p;
        rsold = rsnew;
    end


function [X Y X0 Y0]=getFilterStructure0(feature_sz,target_sz)
h = target_sz(1);
w = target_sz(2);
H = feature_sz(1);
W = feature_sz(2);
[xs ys]=getShiftedCordn(h,w,H,W);
[X Y]=meshgrid(xs,ys);
[xs ys]=getShiftedCordn(h,w,h,w);
[X0 Y0]=meshgrid(xs,ys);


function [X Y X0 Y0]=getFilterStructure(features, target_sz)
X=cell(0);Y=cell(0);
X0=cell(0);Y0=cell(0);
features_sz=size(features(:,:,1));
for i=1:size(features,3)
    [x y x0 y0]=getFilterStructure0(features_sz,target_sz);
    X{end+1}=x;Y{end+1}=y;
    X0{end+1}=x0';Y0{end+1}=y0';
end

 
