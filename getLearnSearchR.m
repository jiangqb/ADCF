function [learn_R search_R]=getLearnSearchR(im_sz,target_R,h_scale,w_scale,rect_ratio,learnsearchStrategy)
% params.learnlearnsearchStrategy.rectratio=[3 2 0];
% params.learnsearchStrategy.learnRratio=[3 3 .3];
% params.learnsearchStrategy.searchRratio=[4 4 .6];
% params.learnsearchStrategy.minlearnsearchStrategy=[4 3 5]; % [min_searchR_ratio  learnR_ratio  searchR_ratio]
% params.learnsearchStrategy.maxlearnsearchStrategy=[400 200 400]; % [max_search_Len  learnR  searchR]
samelearnsearchR=learnsearchStrategy.rectratio(end)==0 && learnsearchStrategy.searchRratio(end)==0 && learnsearchStrategy.searchRratio(end)==0;
for i=1:length(learnsearchStrategy.rectratio)
    if rect_ratio>learnsearchStrategy.rectratio(i) && learnsearchStrategy.rectratio(i)~=0 || samelearnsearchR
        learn_R=target_R * learnsearchStrategy.learnRratio(i);
%         search_R=target_R * learnsearchStrategy.searchRratio(i);
        search_R=learn_R + (learnsearchStrategy.searchRratio(i)-learnsearchStrategy.learnRratio(i))*round(target_R/4)*4;
        break;
    elseif learnsearchStrategy.rectratio(i)==0 && learnsearchStrategy.searchRratio(i) && learnsearchStrategy.searchRratio(i)
        search_R=round( learnsearchStrategy.searchRratio(i)* min(im_sz(1:2).*[h_scale w_scale]) /8) *4;
        learn_R=round( learnsearchStrategy.learnRratio(i)* min(im_sz(1:2).*[h_scale w_scale]) /8) *4;
        if search_R>learnsearchStrategy.maxlearnsearchStrategy(1)
             search_R=learnsearchStrategy.maxlearnsearchStrategy(3);
             learn_R=learnsearchStrategy.maxlearnsearchStrategy(2);
         elseif search_R<target_R*learnsearchStrategy.minlearnsearchStrategy(1)
             learn_R=target_R * learnsearchStrategy.minlearnsearchStrategy(2);
%              search_R=target_R * learnsearchStrategy.minlearnsearchStrategy(3);   
             search_R=learn_R + (learnsearchStrategy.minlearnsearchStrategy(3)-learnsearchStrategy.minlearnsearchStrategy(2))*round(target_R/4)*4;   
        end
         break;
    end
        
end
%     if rect_ratio >3
% %      target_R=round((sqrt(prod(target_sz))/2));
%       learn_R=target_R*3;
%      search_R=learn_R+round(target_R/4)*4*1;
%     elseif rect_ratio >2
%       learn_R=target_R*3;
%      search_R=learn_R+round(target_R/4)*4*2;
% %       learn_R=target_R*4;search_R=learn_R;
%     else
%          search_R=round(.6*min(im_sz(1:2).*[h_scale w_scale])/8)*4;
%          learn_R=round(search_R/8)*4;
% 
%          if search_R>400
%              search_R=400;
%              learn_R=round(search_R/8)*4;
%          elseif search_R<target_R*4
%              learn_R=target_R*3;
%              search_R=learn_R+round(target_R/4)*4*2;        
%          end
%     end



function [learn_R search_R]=getLearnSearchR0(im_sz,target_R,target_sz,h_scale,w_scale,rect_ratio)

if target_sz(1)>target_sz(2)*rect_ratio || target_sz(2)>target_sz(1)*rect_ratio
%      target_R=round((sqrt(prod(target_sz))/2));
      learn_R=target_R*3;
     search_R=learn_R+round(target_R/4)*4*1;
     
%       learn_R=target_R*4;search_R=learn_R;
else
    
     search_R=round(.5*min(im_sz(1:2).*[h_scale w_scale])/8)*4;
     learn_R=round(search_R/8)*4;

     if search_R>400
         search_R=400;
         learn_R=round(search_R/8)*4;
     elseif search_R<target_R*5
         learn_R=target_R*4;
         search_R=learn_R+round(target_R/4)*4*1;        
     end
%     search_R=round(.8*min(im_sz(1:2))/8)*4;
     
end


