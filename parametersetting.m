function params=parametersetting(params)
         params.TemporalReg=1; 
         params.SpatialReg=1;
params.use_respweightedsum=1;
params.number_of_scales = 7;
params.resizelearn_R=1;
params.Spatialreglambda =130;
params.Spatialregwincoeff =1.08;
params.Record_fnum=50;
params.compsteps=5;
params.maxfilterarea=1600;
params.usemexresize=0;
params.minLenStrategy=[10 20 30 40 inf;16 24 36 36 36];
params.maxLen=44;
params.lenchangethreld=2;
params.smallsearchthreld=3;
params.tukeywinthreld=3.1;
params.learnsearchStrategy.rectratio=[3 2  0];
params.learnsearchStrategy.learnRratio=[3 3  .25];
params.learnsearchStrategy.searchRratio=[4 5  .5];
params.learnsearchStrategy.rectratio=[3 2.5 2 1.8 1.5 0];
params.learnsearchStrategy.learnRratio=[3 3  4  2 4 .25];
params.learnsearchStrategy.searchRratio=[4 4  4 3  5 .5];
params.learnsearchStrategy.minlearnsearchStrategy=[4 3 4]; % [min_searchR_ratio  learnR_ratio  searchR_ratio]
params.learnsearchStrategy.maxlearnsearchStrategy=[400 200 400]; % [max_search_Len  learnR  searchR]

% a=20*log(10);b=30*10^13;
% mu=200+(b*exp(-a*mu))*(1/(1+exp(-400*mu_fastchg+270)));
params.a1=-20*log(10);
params.b1=30*10^13;
params.a2=-400;
params.b2=270;
params.c=500;
params.learning_rate=0.02;

end


