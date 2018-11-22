function [dx dy sind responsef max_res]=predictState(features,pos_in_patches,filters,use_respweightedsum)

[h, w, ~]=size(filters);
responsef=[];
max_res=0;
for i=1:numel(features)
    [H W n]=size(features{i});
    Filters=reshapeFilter(filters,H,W);
    response=ifft2(fft2(features{i}).*fft2(Filters),'symmetric');
if use_respweightedsum
    maxreses = getMaxresval(response);
    maxreses = repmat(reshape(maxreses,1,1,length(maxreses)),size(response,1),size(response,2),1);
    response=sum(response.*maxreses,3);
else
    response=sum(response,3);
end

responsef=cat(3,responsef,response);
end

[dy dx sind]=getTranslation(responsef,size(responsef,1),size(responsef,2));
dx=dx-1;
dy=dy-1;


function Filters=reshapeFilter(filters,H,W)
Filters=[];
for i=1:size(filters,3)
   Filter=embedfilter(filters(:,:,i),H,W);
   Filters=cat(3,Filters,Filter);
end

function maxreses = getMaxresval(responses)
maxreses = zeros(size(responses,3),1);
for i=1:size(responses,3)
    maxres=max(max(responses(:,:,i)));
    maxreses(i)=maxres;
end
