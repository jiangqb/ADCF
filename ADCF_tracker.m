% This function implements the SRDCF tracker.

function results = STRACF_tracker(params)
close all;
% parameters
output_sigma_factor = params.output_sigma_factor;
learning_rate = params.learning_rate;
nScales = params.number_of_scales;
scale_step = params.scale_step;


    global_fparams.cell_size = 4;
    global_fparams.use_gpu = 0;
    global_fparams.gpu_id = [];
    global_fparams.use_mexResize=1;
if params.TemporalReg
    a1=params.a1;
    b1=params.b1;
    a2=params.a2;
    b2=params.b2;
    c=params.c;
end
Spatialreglambda = params.Spatialreglambda;
smallsearchthreld = params.smallsearchthreld;
tukeywinthreld = params.tukeywinthreld;
lenchangethreld =params.lenchangethreld;
maxfilterarea = params.maxfilterarea;
minLenStrategy = params.minLenStrategy;
maxLen = params.maxLen;
learnsearchStrategy = params.learnsearchStrategy;

features = params.t_features;

s_frames = params.s_frames;
pos = floor(params.init_pos);
target_sz = floor(params.wsize);

debug = params.debug;
visualization = params.visualization || debug;

num_frames = numel(s_frames);

im = imread(s_frames{1});
im_sz = [size(im,1) size(im,2)];
%set the feature ratio to the feature-cell size
featureRatio = params.t_global.cell_size;
global_feat_params = params.t_global;

currentScaleFactor = 1.0;
%----------
global h_scale;
global w_scale;
global do_scale_im;
h_scale=1;
w_scale=1;
do_scale_im=0;

[a,b,min_len,max_len,wintype]=getParam(target_sz,minLenStrategy,maxLen,tukeywinthreld);
rect_ratio=max([target_sz(1)/target_sz(2) target_sz(2)/target_sz(1)]);
[target_sz h_scale w_scale do_scale_im]=resizeTarget(target_sz,min_len,max_len,maxfilterarea,lenchangethreld);

pos=round(pos.*[h_scale w_scale]);

% target size at the initial scale
base_target_sz = target_sz / currentScaleFactor;

%window size, taking padding into account

% construct the label function
output_sigma = sqrt(prod(floor(base_target_sz/featureRatio))) * output_sigma_factor;


% Calculate feature dimension
% im = imread(s_frames{1});
if size(im,3) == 3
    if all(all(im(:,:,1) == im(:,:,2)))
        colorImage = false;
    else
        colorImage = true;
    end
else
    colorImage = false;
end

% compute feature dimensionality
for n = 1:length(features)
    
    if ~isfield(features{n}.fparams,'useForColor')
        features{n}.fparams.useForColor = true;
    end;
    
    if ~isfield(features{n}.fparams,'useForGray')
        features{n}.fparams.useForGray = true;
    end;
    
end;

if size(im,3) > 1 && colorImage == false
    im = im(:,:,1);
end

if nScales > 0
    scale_exp = (-floor((nScales-1)/2):ceil((nScales-1)/2));
    scaleFactors = scale_step .^ scale_exp;
    %force reasonable scale changes
    min_scale_factor =0.0252;
    max_scale_factor = 5.3742;
end


% initialize the projection matrix
rect_position = zeros(num_frames, 4);

time = 0;


update_visualization = show_video(s_frames, '',0);
global xs;
global ys;
global Current_responses;
global Resp_szs;
global Resp_pos;
global Pred_cos_windows;
global Maxresvals;
Current_responses=cell(0);
Pred_cos_windows=cell(0);
    Resp_szs=zeros(num_frames,2);
    Resp_pos=zeros(num_frames,2);
    As=[];bs=[];coeffses=[];Ss=[];
    
%     base_target_sz=round(base_target_sz/currentScaleFactor);

 target_R=round((sqrt(prod(base_target_sz))/2));

[learn_R search_R]=getLearnSearchR(im_sz,target_R,h_scale,w_scale,rect_ratio,learnsearchStrategy);

    global search_scale;
    search_scale=search_R/target_R;
    FiltersCoeffs=cell(0);
    Features=cell(0);
    DRs=[];Mus=[];
    Temporalreglambda=0;
    Record_fnum=params.Record_fnum;
    hogFeatures=0;
    TemporalReg=params.TemporalReg;
%     [features, global_fparams, feature_info] = init_features(features, global_fparams, colorImage, img_sample_sz, 'exact');
for frame = 1:num_frames

    %load image
    if ~exist(s_frames{frame}) continue; end
    im = imread(s_frames{frame});
    if do_scale_im
                 if params.usemexresize
                     im=mexResize(im,round([size(im,1)*h_scale size(im,2)*w_scale]),'auto');
                 else
                     im=imresize(im,round([size(im,1)*h_scale size(im,2)*w_scale]),'bilinear');
                 end
    end
    if size(im,3) > 1 && colorImage == false
        im = im(:,:,1);
    end

    tic();
% model prediction
    if frame > 1
        
        iter = 1;
        
        %translation search
        while iter<2 
            % Get multi-resolution image
            
            cur_search_R=search_R;
            if search_R>max([size(im,1) size(im,2)]) || min(target_sz)<smallsearchthreld
                   cur_search_R=learn_R;
            end
            %-------feature extraction -----------
            if hogFeatures
                [xt pos_in_patches]=extract_features(im, pos, currentScaleFactor*scaleFactors, features, global_feat_params,cur_search_R,wintype);
            else
                sample_scale = currentScaleFactor*scaleFactors;
                feature_extract_info.img_sample_sizes = {[cur_search_R*2+1 cur_search_R*2+1]};
                feature_extract_info.img_input_sizes = {[cur_search_R*2+1 cur_search_R*2+1]};
                [features1, global_fparams1, feature_info] = init_features(features, global_fparams, colorImage, feature_extract_info.img_sample_sizes{1}, 'same');
                [xt poses_in_patches]= extract_features_STRCF(im, sample_pos, sample_scale, features1, global_fparams1, feature_extract_info,wintype);
                pos_in_patches=poses_in_patches{1};
                xt=mymat2cell(xt{1});
            end

            %----------prediction ----------           

           [dx dy sind response max_res] = predictState(xt,pos_in_patches,filters,params.use_respweightedsum);

           disp_row=dy;
           disp_col=dx;

            translation_vec = round([disp_row, disp_col] * featureRatio * currentScaleFactor * scaleFactors(sind));
            currentScaleFactor = currentScaleFactor * scaleFactors(sind);
            % adjust to make sure we are not to large or to small
            if currentScaleFactor < min_scale_factor
                currentScaleFactor = min_scale_factor;
            elseif currentScaleFactor > max_scale_factor
                currentScaleFactor = max_scale_factor;
            end
            
            % update position
            
            if isnan(sum(translation_vec))
                translation_vec=[0 0];
            end

            pos = pos + translation_vec;

            iter = iter + 1;
        end
    end
% ------model update-------------

    
if min(target_sz)>.6*min([size(im,1) size(im,2)]) && params.resizelearn_R
      learn_R=round(min(target_sz)/8)*4;
      search_R=learn_R;
end
        
%-----temporal regularization ----------
if  TemporalReg && frame>Record_fnum+0
 %---feature extraction ----------
    if hogFeatures
             [xt pos_in_patches]=extract_features(im, pos, 1, features, global_feat_params,[target_sz;base_target_sz],'nowin');
    else
        sample_scale = currentScaleFactor*1;
        feature_extract_info.img_sample_sizes = {round(base_target_sz)};
        feature_extract_info.img_input_sizes = {round(base_target_sz)};
        [features1, global_fparams1, feature_info] = init_features(features, global_fparams, colorImage, feature_extract_info.img_sample_sizes{1}, 'same');
        [xt poses_in_patches]= extract_features_STRCF(im, sample_pos, sample_scale, features1, global_fparams1, feature_extract_info,'nowin');

    end
    ft=xt{1};
    ft0=Features{end-Record_fnum+1};
    denominator=sum(sum(sum(ft.*ft)))*sum(sum(sum(ft0.*ft0)));
    mu=sum(sum(sum(ft.*ft0)))/sqrt(denominator);
    ft1=Features{end-params.compsteps+1};
    denominator=sum(sum(sum(ft.*ft)))*sum(sum(sum(ft1.*ft1)));
    mu_fastchg=sum(sum(sum(ft.*ft1)))/sqrt(denominator);
    mu=c+(b1*exp(a1*mu))*(1/(1+exp(a2*mu_fastchg+b2)));
else
    mu=0;
end


target_block_sz=round(round(1*base_target_sz)/global_feat_params.cell_size);
%--------feature extraction---
if hogFeatures
    [xt pos_in_patches]=extract_features(im, pos, currentScaleFactor, features, global_feat_params,learn_R,wintype);
    ft_search_area=xt{1};
    block_pos=pos_in_patches;
else

    sample_pos = round(pos);
    sample_scale = currentScaleFactor*1;
    feature_extract_info.img_sample_sizes = {[learn_R*2+1 learn_R*2+1]};
    feature_extract_info.img_input_sizes = {[learn_R*2+1 learn_R*2+1]};
    [features1, global_fparams1, feature_info] = init_features(features, global_fparams, colorImage, feature_extract_info.img_sample_sizes{1}, 'same');
    [xt poses_in_patches]= extract_features_STRCF(im, sample_pos, sample_scale, features1, global_fparams1, feature_extract_info,wintype);
    ft_search_area=xt{1};
    block_pos=poses_in_patches{1};
end


%-------- filters learning----
if frame==1
    iterNum=50;
else
    iterNum=50;
end

[As bs coeffses filters Temporalreglambda]=updateFilter(ft_search_area, target_block_sz, block_pos,output_sigma, As,bs,coeffses,learning_rate,iterNum,wintype,FiltersCoeffs,mu,Temporalreglambda,Spatialreglambda,Ss);
if isempty(Ss)
    %             filter=filters(:,:,1);
    spatialregwin=1-gausswin(size(filters,1),params.Spatialregwincoeff)*gausswin(size(filters,2),params.Spatialregwincoeff)';
    Ss=getTemporalRegterm(As,spatialregwin);
end

  %------for temporal regularization----------
  if TemporalReg
         FiltersCoeffs{end+1}=coeffses;
         if numel(FiltersCoeffs)>Record_fnum
             FiltersCoeffs(1)=[];
             
         end 

        if hogFeatures
                 [ft pos_in_patches]=extract_features(im, pos, 1, features, global_feat_params,[target_sz;base_target_sz],'nowin');
        else
            sample_scale = currentScaleFactor*1;
            feature_extract_info.img_sample_sizes = {round(base_target_sz)};
            feature_extract_info.img_input_sizes = {round(base_target_sz)};
            [features1, global_fparams1, feature_info] = init_features(features, global_fparams, colorImage, feature_extract_info.img_sample_sizes{1}, 'same');
            [ft poses_in_patches]= extract_features_STRCF(im, sample_pos, sample_scale, features1, global_fparams1, feature_extract_info,'nowin');

        end
        
         Features{end+1}=ft{1};
         if numel(Features)>Record_fnum
             Features(1)=[];
             
         end
  end

    if max(target_sz)<10
        h_scale=h_scale*1.5;
        w_scale=w_scale*1.5;
        currentScaleFactor=currentScaleFactor*1.5;
        pos=round(pos*1.5);
    end

    target_sz = floor(base_target_sz * currentScaleFactor);
    %save position and calculate FPS
    rect_position(frame,:) = [pos([2,1]) - floor(target_sz([2,1])/2), target_sz([2,1])];
    rect_position(frame,[1,3]) = round(rect_position(frame,[1,3])/w_scale);
    rect_position(frame,[2,4]) = round(rect_position(frame,[2,4])/h_scale);
    time = time + toc();
    
    %visualization
    if visualization == 1
        rect_position_vis = rect_position(frame,:);
		
        stop = update_visualization(frame, rect_position_vis);
        drawnow
         %pause
    end
end

fps = numel(s_frames) / time;

results.type = 'rect';
results.res = rect_position;
results.fps = fps;
