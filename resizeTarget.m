% function [target_sz scaleFactor]=resizeTarget2(target_sz,min_len,max_len)
% scaleFactor=1;
% if  target_sz(1)<target_sz(2)&&target_sz(1)<min_len
%     scaleFactor=target_sz(1)/min_len;
% elseif target_sz(2)<=target_sz(1)&&target_sz(2)<min_len
%     scaleFactor=target_sz(2)/min_len;
% elseif target_sz(1)<target_sz(2)&&target_sz(1)>max_len
%      scaleFactor=target_sz(1)/max_len;
% elseif target_sz(2)<=target_sz(1)&&target_sz(2)>max_len
%     scaleFactor=target_sz(2)/max_len;
% end
% target_sz=round(target_sz/scaleFactor);

function [target_sz h_scale w_scale do_scale_im]=resizeTarget(target_sz,min_len,max_len,maxtargz_area,lenchangethreld)
totalarea=prod(target_sz);
target_sz0=target_sz;
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
    
    max_target_h=max_len;
    max_target_w=max_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else

        if   target_sz(1) <target_sz(2) && target_sz(1)<min_target_h
            h_scale=(min_target_h/target_sz(1));
            if max(abs(target_sz*h_scale-target_sz))>lenchangethreld
                do_scale_im=1;
                target_sz(1)=min_target_h;       
                if totalarea>=10
                    target_sz(2)=round(target_sz(2)*h_scale);
                    w_scale=h_scale;
                else
        %             w_scale=1;
                end
            end
        elseif target_sz(2)<min_target_w
            w_scale=(min_target_w/target_sz(2));
            if max(abs(target_sz*w_scale-target_sz))>lenchangethreld
                do_scale_im=1;
                target_sz(2)=min_target_w;
                if totalarea>=10
                    target_sz(1)=round(target_sz(1)*w_scale);
                    h_scale=w_scale;
                else
        %             h_scale=1;
                end
            end
        end

if 1
        
         if  target_sz(1) <target_sz(2) &&   target_sz(1)>max_target_h && prod(target_sz)>maxtargz_area
             
             scale=(max_target_h/target_sz(1));
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                h_scale=(max_target_h/target_sz(1))*h_scale;

                target_sz(2)=round(target_sz(2)*(max_target_h/target_sz(1)));
                w_scale=(max_target_h/target_sz(1))*w_scale;
                target_sz(1)=max_target_h;  

                do_scale_im=1;
            end

         elseif target_sz(2)>max_target_w  && prod(target_sz)>maxtargz_area
             scale=max_target_w/target_sz(2);
             if max(abs(target_sz*scale-target_sz))>lenchangethreld
                w_scale=(max_target_w/target_sz(2))*w_scale;

                target_sz(1)=round(target_sz(1)*(max_target_w/target_sz(2)));
                h_scale=(max_target_w/target_sz(2))*h_scale;
                target_sz(2)=max_target_w;
                do_scale_im=1;
             end
            
         end
%          maxtargz_area=2500;
        if prod(target_sz)>maxtargz_area &&1
            scale=max([maxtargz_area/prod(target_sz) min_len/min(target_sz)]);
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                h_scale=h_scale*scale;
                w_scale=w_scale*scale;
                target_sz=round(target_sz0.*[h_scale w_scale]);
                do_scale_im=1;
            end
        end
end




function [target_sz h_scale w_scale do_scale_im]=resizeTarget_hogfeature(target_sz,min_len,max_len,maxtargz_area,lenchangethreld)
totalarea=prod(target_sz);
target_sz0=target_sz;
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
    
    max_target_h=max_len;
    max_target_w=max_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else

        if   target_sz(1) <target_sz(2) && target_sz(1)<min_target_h
            h_scale=(min_target_h/target_sz(1));
            do_scale_im=1;
            target_sz(1)=min_target_h;       
            if totalarea>=10
                target_sz(2)=round(target_sz(2)*h_scale);
                w_scale=h_scale;
            else
    %             w_scale=1;
            end
        elseif target_sz(2)<min_target_w
            w_scale=(min_target_w/target_sz(2));
            do_scale_im=1;
            target_sz(2)=min_target_w;
            if totalarea>=10
                target_sz(1)=round(target_sz(1)*w_scale);
                h_scale=w_scale;
            else
    %             h_scale=1;
            end
        end

if 1
        
         if  target_sz(1) <target_sz(2) &&   target_sz(1)>max_target_h && prod(target_sz)>maxtargz_area
            h_scale=(max_target_h/target_sz(1))*h_scale;
            do_scale_im=1;
            target_sz(2)=round(target_sz(2)*(max_target_h/target_sz(1)));
            w_scale=(max_target_h/target_sz(1))*w_scale;
            target_sz(1)=max_target_h;  
            
            do_scale_im=1;

         elseif target_sz(2)>max_target_w  && prod(target_sz)>maxtargz_area
            w_scale=(max_target_w/target_sz(2))*w_scale;
            do_scale_im=1;
            target_sz(1)=round(target_sz(1)*(max_target_w/target_sz(2)));
            h_scale=(max_target_w/target_sz(2))*h_scale;
            target_sz(2)=max_target_w;
            do_scale_im=1;
            
         end
%          maxtargz_area=2500;
        if prod(target_sz)>maxtargz_area &&1
            scale=max([maxtargz_area/prod(target_sz) min_len/min(target_sz)]);
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                h_scale=h_scale*scale;
                w_scale=w_scale*scale;
                target_sz=round(target_sz0.*[h_scale w_scale]);
                do_scale_im=1;
            end
        end
end


function [target_sz h_scale w_scale do_scale_im]=resizeTarget_otb100_3features(target_sz,min_len,max_len,maxtargz_area,lenchangethreld)
totalarea=prod(target_sz);
target_sz0=target_sz;
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
    
    max_target_h=max_len;
    max_target_w=max_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else

        if   target_sz(1) <target_sz(2) && target_sz(1)<min_target_h
            h_scale=(min_target_h/target_sz(1));
            if max(abs(target_sz*h_scale-target_sz))>lenchangethreld
                do_scale_im=1;
                target_sz(1)=min_target_h;       
                if totalarea>=10
                    target_sz(2)=round(target_sz(2)*h_scale);
                    w_scale=h_scale;
                else
        %             w_scale=1;
                end
            end
        elseif target_sz(2)<min_target_w
            w_scale=(min_target_w/target_sz(2));
            if max(abs(target_sz*w_scale-target_sz))>lenchangethreld
                do_scale_im=1;
                target_sz(2)=min_target_w;
                if totalarea>=10
                    target_sz(1)=round(target_sz(1)*w_scale);
                    h_scale=w_scale;
                else
        %             h_scale=1;
                end
            end
        end

if 1
        
         if  target_sz(1) <target_sz(2) &&   target_sz(1)>max_target_h && prod(target_sz)>maxtargz_area
             
             scale=(max_target_h/target_sz(1));
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                h_scale=(max_target_h/target_sz(1))*h_scale;

                target_sz(2)=round(target_sz(2)*(max_target_h/target_sz(1)));
                w_scale=(max_target_h/target_sz(1))*w_scale;
                target_sz(1)=max_target_h;  

                do_scale_im=1;
            end

         elseif target_sz(2)>max_target_w  && prod(target_sz)>maxtargz_area
             scale=max_target_w/target_sz(2);
             if max(abs(target_sz*scale-target_sz))>lenchangethreld
                w_scale=(max_target_w/target_sz(2))*w_scale;

                target_sz(1)=round(target_sz(1)*(max_target_w/target_sz(2)));
                h_scale=(max_target_w/target_sz(2))*h_scale;
                target_sz(2)=max_target_w;
                do_scale_im=1;
             end
            
         end
%          maxtargz_area=2500;
        if prod(target_sz)>maxtargz_area &&1
            scale=max([maxtargz_area/prod(target_sz) min_len/min(target_sz)]);
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                h_scale=h_scale*scale;
                w_scale=w_scale*scale;
                target_sz=round(target_sz0.*[h_scale w_scale]);
                do_scale_im=1;
            end
        end
end

        

function [target_sz h_scale w_scale do_scale_im]=resizeTarget00(target_sz,min_len,max_len,maxtargz_area,lenchangethreld)
totalarea=prod(target_sz);
target_sz0=target_sz;
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
    
    max_target_h=max_len;
    max_target_w=max_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else

        if   target_sz(1) <target_sz(2) && target_sz(1)<min_target_h
            h_scale=(min_target_h/target_sz(1));
            do_scale_im=1;
            target_sz(1)=min_target_h;       
            if totalarea>=10
                target_sz(2)=round(target_sz(2)*h_scale);
                w_scale=h_scale;
            else
    %             w_scale=1;
            end
        elseif target_sz(2)<min_target_w
            w_scale=(min_target_w/target_sz(2));
            do_scale_im=1;
            target_sz(2)=min_target_w;
            if totalarea>=10
                target_sz(1)=round(target_sz(1)*w_scale);
                h_scale=w_scale;
            else
    %             h_scale=1;
            end
        elseif target_sz(2)>max_target_w  && target_sz(1) <target_sz(2) 
             [scale indx]=max([max_target_w/target_sz(2) min_len/min(target_sz)]);
             if max(abs(target_sz*scale-target_sz))>lenchangethreld
                 old_sz=target_sz;
                 target_sz=round(target_sz*scale);
%                  scale=mean(target_sz./old_sz);
                w_scale=scale*w_scale;
                h_scale=scale*h_scale;

                do_scale_im=1;
             end
        elseif   target_sz(1)>max_target_h 
            scale=max([max_target_h/target_sz(1) min_len/min(target_sz)]);
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                old_sz=target_sz;
                 target_sz=round(target_sz*scale);
%                  scale=mean(target_sz./old_sz);
                w_scale=scale*w_scale;
                h_scale=scale*h_scale;
                do_scale_im=1;
            end
            
         end
%          maxtargz_area=2500;
        if prod(target_sz)>maxtargz_area &&1
            scale=max([maxtargz_area/prod(target_sz) min_len/min(target_sz)]);
            if max(abs(target_sz*scale-target_sz))>lenchangethreld
                old_sz=target_sz;
                 target_sz=round(target_sz*scale);
%                  scale=mean(target_sz./old_sz);
                h_scale=h_scale*scale;
                w_scale=w_scale*scale;
                do_scale_im=1;
            end
        end





function [target_sz h_scale w_scale do_scale_im]=resizeTarget2(target_sz,min_len,max_len)
totalarea=prod(target_sz);
target_sz0=target_sz;
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
    
    max_target_h=max_len;
    max_target_w=max_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else

        if   target_sz(1) <target_sz(2) && target_sz(1)<min_target_h
            h_scale=(min_target_h/target_sz(1));
            do_scale_im=1;
            target_sz(1)=min_target_h;       
            if totalarea>=10
                target_sz(2)=round(target_sz(2)*h_scale);
                w_scale=h_scale;
            else
    %             w_scale=1;
            end
        elseif target_sz(2)<min_target_w
            w_scale=(min_target_w/target_sz(2));
            do_scale_im=1;
            target_sz(2)=min_target_w;
            if totalarea>=10
                target_sz(1)=round(target_sz(1)*w_scale);
                h_scale=w_scale;
            else
    %             h_scale=1;
            end
        end

if 1
        
         if  target_sz(1) <target_sz(2) &&   target_sz(1)>max_target_h && prod(target_sz)>2500
            h_scale=(max_target_h/target_sz(1))*h_scale;
            do_scale_im=1;
            target_sz(2)=round(target_sz(2)*(max_target_h/target_sz(1)));
            w_scale=(max_target_h/target_sz(1))*w_scale;
            target_sz(1)=max_target_h;  
            
            do_scale_im=1;

         elseif target_sz(2)>max_target_w  && prod(target_sz)>2500
            w_scale=(max_target_w/target_sz(2))*w_scale;
            do_scale_im=1;
            target_sz(1)=round(target_sz(1)*(max_target_w/target_sz(2)));
            h_scale=(max_target_w/target_sz(2))*h_scale;
            target_sz(2)=max_target_w;
            do_scale_im=1;
            
         end
        if prod(target_sz)>2500 &&1
            scale=max([2500/prod(target_sz) min_len/min(target_sz)]);
            h_scale=h_scale*scale;
            w_scale=w_scale*scale;
            target_sz=round(target_sz0.*[h_scale w_scale]);
            do_scale_im=1;
        end
end
        
function [target_sz h_scale w_scale do_scale_im]=resizeTarget1(target_sz,min_len)
totalarea=prod(target_sz);
h_scale=1;
w_scale=1;
do_scale_im=0;
    min_target_h=min_len;
    min_target_w=min_len;
%     if target_sz(1)<min_target_h  && target_sz(2)<min_target_w  
%         if target_sz(1)<target_sz(2)
%             h_scale=(min_target_h/target_sz(1));
%             target_sz(1)=min_target_h;  
%             do_scale_im=1;
%             w_scale=1;
%         else
%             w_scale=(min_target_w/target_sz(2));
%             target_sz(2)=min_target_w;
%             do_scale_im=1;
%             h_scale=1;
%         end
%     else
        if  target_sz(1)<min_target_h
        h_scale=(min_target_h/target_sz(1));
        do_scale_im=1;
        target_sz(1)=min_target_h;       
        if totalarea>650
            target_sz2=round(target_sz(2)*h_scale/4)*4;
            w_scale=target_sz2/target_sz(2);
            target_sz(2)=target_sz2;
        else
%             w_scale=1;
        end
        end
        if target_sz(2)<min_target_w
        w_scale=(min_target_w/target_sz(2));
        do_scale_im=1;
        target_sz(2)=min_target_w;
        if totalarea>650
            target_sz1=round(target_sz(1)*w_scale/4)*4;
            h_scale=target_sz1/target_sz(1);
            target_sz(1)=target_sz1;
        else
%             h_scale=1;
        end
        end
        
        


 function [target_sz h_scale w_scale do_scale_im]=resizeTarget0(target_sz,min_len)
    h_scale=1;
    w_scale=1;
    do_scale_im=0;
    min_target_h=40;
    min_target_w=40;
if  target_sz(1)<min_target_h  
    h_scale=(min_target_h/target_sz(1));       
    target_sz(1)=min_target_h;      
    do_scale_im=1;
end
if target_sz(2)<min_target_w
    w_scale=(min_target_w/target_sz(2));   
    target_sz(2)=min_target_w;
    do_scale_im=1;
end



    
