function [a,b,min_len,max_len,wintype]=getParam(init_target_sz,minLenStrategy,maxLen, tukeywinthreld)

%      a=20*log(10);b=15*10^13;  % - girl
%     min_len=36;
%     max_len=64;
%     rect_ratio=max([init_target_sz(1)/init_target_sz(2) init_target_sz(2)/init_target_sz(1)]);
    for i=1:size(minLenStrategy,2)
        if min(init_target_sz)<minLenStrategy(1,i)
            min_len = minLenStrategy(2,i);
            break;
        end 
    end
%        if min(init_target_sz)<minLenStrategy(1,1)
%             min_len=minLenStrategy(2,1);
%         elseif min(init_target_sz)<20
%             min_len=minLenStrategy(2,2);
%        elseif min(init_target_sz)<30
%             min_len=minLenStrategy(2,3);
%        else
%             min_len=minLenStrategy(2,4);
%        end
%         
       a=20*log(10);b=.05*10^13;  % - girl
%           a=20*log(10);b=15*10^13;
%            min_len=32;
       max_len=maxLen;
       
    rect_ratio=max([init_target_sz(1)/init_target_sz(2) init_target_sz(2)/init_target_sz(1)]);
    if rect_ratio>tukeywinthreld
        wintype='tukey';
    else
        wintype='hann';
    end

function [a,b,min_len,max_len]=getParam0(t_features,target_sz)
    if numel(t_features)==3
        if min(target_sz)<=10
        min_len=16;
        elseif min(target_sz)<20
            if prod(target_sz)<400
                min_len=28;
            else
                min_len=36;
            end
            
        else
             min_len=36;
        end
        a=20*log(10);b=1*10^13;  % - girl
%         b=.2*10^13;
    elseif numel(t_features)==2
%         params.learning_rate = 0.02;
        min_len=36;
        a=20*log(10);b=15*10^13;  % - girl
%  mu=.5+(b*exp(-a*mu))*(1/(1+exp(-400*mu_fastchg+300)));
    else
        min_len=40;
        a=20*log(10);b=30*10^13;  % - girl
%          mu=200+(b*exp(-a*mu))*(1/(1+exp(-400*mu_fastchg+270)));
    end
    
    max_len=64;
    
