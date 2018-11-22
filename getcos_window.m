function y=getcos_window(learnR,searchR,win_type)
%  y=ones(1,searchR);
coeff=sqrt(hann(learnR)'*hann(learnR));
%  coeff=learnR;
switch win_type
    case 'nowin'
        y=ones(1,searchR);
    case 'hann'
        y=coeff*hann(searchR)';
    case 'tukey'
         y=tukeywin(searchR,.15)';
end
