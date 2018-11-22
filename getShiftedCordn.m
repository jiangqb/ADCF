function [xs ys]=getShiftedCordn(h,w,H,W)
xs=round(1+(W-w)/2):round(w+(W-w)/2);
ys=round(1+(H-h)/2):round(h+(H-h)/2);

