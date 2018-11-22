function [X Y]=mymeshgrid(x,y)
if size(x,1)>1
    x=conj(x');
end
if size(y,2)>1
    y=conj(y');
end
X=repmat(x,[length(y) 1]);
Y=repmat(y,[1 length(x)]);