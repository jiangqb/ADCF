function [vert_delta, horiz_delta, n]=getTranslation(responses,f_h,f_w)

 Maxv=0;
for i=1:size(responses,3)
    maxres=max(max(responses(:,:,i)));
    if maxres>Maxv
        [vert_delta, horiz_delta] = find(responses(:,:,i) ==maxres , 1);
        Maxv=maxres;
        n=i;
    end 
end

% [vert_delta, horiz_delta] = find(response == max(response(:)), 1);
if vert_delta > f_h / 2,  %wrap around to negative half-space of vertical axis
    vert_delta = vert_delta - f_h;
end
if horiz_delta > f_w / 2,  %same for horizontal axis
    horiz_delta = horiz_delta - f_w;
end
