function [xt pos_in_patches]=extract_features(im, pos, scales, features, global_feat_params,cur_search_R,wintype)
% scales=currentScaleFactor*scaleFactors;
multires_pixel_template=cell(0);
multires_pos_template=[];
for scale_ind = 1:length(scales)
    %----------
    if size(cur_search_R,1)==2
        pixels =  get_pixels(im,pos,cur_search_R(1,:),cur_search_R(2,:));
        pos_in_patch = round(1+[size(pixels,1) size(pixels,2)]/2);
    else
        [pixels pos_in_patch]=my_get_pixels(im, pos, scales(scale_ind)*cur_search_R, 1/scales(scale_ind));
    end
    multires_pixel_template{end+1}=pixels;
    multires_pos_template=[multires_pos_template;pos_in_patch];
end
%--------------------

xt=cell(0);
pos_in_patches=[];
for i=1:numel(multires_pixel_template)
    patch = multires_pixel_template{i};
    pos_in_patch = multires_pos_template(i,:);
    
    ft = get_features(patch,features,global_feat_params);
    [learn_coswin_h learn_coswin_w ~]=size(ft(:,:,1));
    cos_window = getcos_window(learn_coswin_h,size(ft,1),wintype)'*getcos_window(learn_coswin_w, size(ft,2),wintype);
    pos_in_patch=round(pos_in_patch/global_feat_params.cell_size);
    pos_in_patches=[pos_in_patches;pos_in_patch];
    zf = bsxfun(@times,ft,cos_window);

    xt{end+1}=zf;
end