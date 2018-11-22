function Filter=embedfilter(filter,H,W)
[h w]=size(filter);
[xs ys]=getShiftedCordn(h,w,H,W);
Filter=zeros(H,W);
Filter(ys,xs)=filter;


