function  Ss=getTemporalRegterm(As,spatialregwin)

Ss=cell(0);
w2=spatialregwin.^2;
for i=1:numel(As)
A=As{i};
Ss{end+1}=diag(w2(:));
end