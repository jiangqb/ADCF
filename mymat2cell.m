function C=mymat2cell(m)
C=cell(0);
for i=1:size(m,4)
    C{end+1}=m(:,:,:,i);
end
end