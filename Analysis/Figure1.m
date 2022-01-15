clear all
%% Spin up 
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'spinuplai.mat']);
size(spinuplai)

%% Freerun and Assimilation run
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'assim_free_decade.mat']);
size(freelai_concat)
size(assimlai_concat)

%% Forecast run
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'fromassim_lastfive.mat']);
size(assimlai_concatlastfive)

%% History timeseries (1850-2014)
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'histlai.mat']);
size(hist_lai)

%% Land Area
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'modarea.mat']);
size(area_192_288) % m^2
size(land_frac)

area_192_288_weighted = area_192_288 .* land_frac;

%% Calculation
% Spinup 1998-2000
num_tmonth=size(spinuplai,3);
for i = 1:num_tmonth
    for j = 1:60
        X = spinuplai(:,:,i,j) .* area_192_288_weighted;
        spinuplai_global_average(i,j) = nanmean(X(:))./nanmean(area_192_288_weighted(:));
    end
end
% Average across ensembles
for i=1:num_tmonth
    spinuplai_global_average_mean(i)=mean(spinuplai_global_average(i,:));
    spinuplai_global_average_std(i)=std(spinuplai_global_average(i,:));
end

% Free and Assim run 2000-2010
num_tmonth=size(freelai_concat,3);
for i = 1:num_tmonth
    for j = 1:60
        X = freelai_concat(:,:,i,j) .* area_192_288_weighted;
        flai_global_average(i,j) = nanmean(X(:))./nanmean(area_192_288_weighted(:));
        X = assimlai_concat(:,:,i,j) .* area_192_288_weighted;
        alai_global_average(i,j)  = nanmean(X(:))./nanmean(area_192_288_weighted(:));
    end
end
% Average across ensembles
for i=1:num_tmonth
    flai_global_average_mean(i)=mean(flai_global_average(i,:));
    flai_global_average_std(i)=std(flai_global_average(i,:));
    alai_global_average_mean(i)=mean(alai_global_average(i,:));
    alai_global_average_std(i)=std(alai_global_average(i,:));
end

% Forecast run 2006-2010
num_tmonth=size(assimlai_concatlastfive,3);
for i = 1:num_tmonth
    for j = 1:60
        X = assimlai_concatlastfive(:,:,i,j) .* area_192_288_weighted;
        forlai_global_average(i,j) = nanmean(X(:))./nanmean(area_192_288_weighted(:));
    end
end
% Average across ensembles
for i=1:num_tmonth
    forlai_global_average_mean(i)=mean(forlai_global_average(i,:));
    forlai_global_average_std(i)=std(forlai_global_average(i,:));
end

% Hist 1850-2014
num_tmonth=size(hist_lai,3);
for i=1:num_tmonth
    X = hist_lai(:,:,i)'.* area_192_288_weighted;
    hist_lai_global_average(i)  = nanmean(X(:))./nanmean(area_192_288_weighted(:));
end
%% Anual Global Average LAI
% Spinup 1998-1999
num_year=1999-1998+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    spinuplai_global_average_mean_annual(i)=mean(spinuplai_global_average_mean(mstart:mend));
end

% Free and Assim run 2000-2010
num_year=2010-2000+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    flai_global_average_mean_annual(i)=mean(flai_global_average_mean(mstart:mend));
    alai_global_average_mean_annual(i)=mean(alai_global_average_mean(mstart:mend));
end

num_ens=60;
flai_global_average_annual=zeros(num_year,num_ens);
alai_global_average_annual=zeros(num_year,num_ens);
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    for inst=1:num_ens
        flai_global_average_annual(i,inst)=mean(flai_global_average(mstart:mend,inst));
        alai_global_average_annual(i,inst)=mean(alai_global_average(mstart:mend,inst));
    end
end

% Forecast run 2006-2010
num_year=2010-2006+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    forlai_global_average_mean_annual(i)=mean(forlai_global_average_mean(mstart:mend));
end

num_ens=60;
forlai_global_average_annual=zeros(num_year,num_ens);
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    for inst=1:num_ens
        forlai_global_average_annual(i,inst)=mean(forlai_global_average(mstart:mend,inst));
    end
end

% Hist 1850-2014
histstart=1561;
histend=1932;
num_tmonth=histend-histstart+1;
histdata=hist_lai_global_average(histstart:histend);
% Histdata 1980-2010
num_year=2010-1980+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    histdata_annual(i)=mean(histdata(mstart:mend));
end
%% Annual Observation back to 1982
basedir = '/Users/xuelihuo/DART_CLM_PRAC/Debugglobalassim/';
o_lai=ncread([basedir,'Annual_LAI3g_1982_2016_CLMgrid.nc'],'LAI');
size(o_lai)
obs_lon=ncread([basedir,'Annual_LAI3g_1982_2016_CLMgrid.nc'],'lon'); 
obs_lat=ncread([basedir,'Annual_LAI3g_1982_2016_CLMgrid.nc'],'lat');

% model lai mask
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'modlaimask.mat']);
size(model_lai_free_y2000)

num_year=29;
num_lat=192;
num_lon=288;

% Observation Without Interpolation
o_lai_temp=zeros(num_lat,num_lon,num_year);
size(o_lai_temp)

for i = 1:num_year
    obs_lai_m = o_lai(:,:,i); 
    obs_lai_m(isnan(obs_lai_m))=0;
    interp_lon=obs_lon;
    interp_lon(interp_lon<0)=interp_lon(interp_lon<0)+360;
    test = cat(2,interp_lon,obs_lai_m); test = sortrows(test); test = test(:,2:size(obs_lai_m,2)+1);interp_lon = sort(interp_lon);
    obs_lai_m_trans = (test');
    interp_lat=obs_lat;
    testlat=cat(2,interp_lat,obs_lai_m_trans);testlat=sortrows(testlat);testlat=testlat(:,2:size(obs_lai_m_trans,2)+1);interp_lat=sort(interp_lat);
    inter_obs=testlat;
    inter_obs(isnan(model_lai_free_y2000'))=nan; 
    o_lai_temp(:,:,i) = inter_obs;
end

num_year=29;
for i=1:num_year
    X = o_lai_temp(:,:,i).* area_192_288_weighted;
    olai_global_average_annual(i)  = nanmean(X(:))./nanmean(area_192_288_weighted(:));
end
%% Monthly
%% Observation
clear o_lai
clear o_lai_temp

basedir = '/Users/xuelihuo/DART_CLM_PRAC/Debugglobalassim/';
o_lai=ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'LAI');
size(o_lai)
obs_lon = ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'lon'); 
obs_lat = ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'lat');

num_tmonth=132;
num_lat=192;
num_lon=288;

% Observation Without Interpolation
o_lai_temp=zeros(num_lat,num_lon,num_tmonth*2);
size(o_lai_temp)
ostart=2;
oend=1+num_tmonth*2;
for i = ostart:oend
    obs_lai_m = o_lai(:,:,i); 
    obs_lai_m(isnan(obs_lai_m))=0;
    interp_lon=obs_lon;
    interp_lon(interp_lon<0)=interp_lon(interp_lon<0)+360;
    test = cat(2,interp_lon,obs_lai_m); test = sortrows(test); test = test(:,2:size(obs_lai_m,2)+1);interp_lon = sort(interp_lon);
    obs_lai_m_trans = (test');
    interp_lat=obs_lat;
    testlat=cat(2,interp_lat,obs_lai_m_trans);testlat=sortrows(testlat);testlat=testlat(:,2:size(obs_lai_m_trans,2)+1);interp_lat=sort(interp_lat);
    inter_obs=testlat;
    inter_obs(isnan(model_lai_free_y2000'))=nan; 
    o_lai_temp(:,:,i-1) = inter_obs;
end

% Observation
for i=1:num_tmonth
    X = (o_lai_temp(:,:,i*2-1)+o_lai_temp(:,:,i*2)).* area_192_288_weighted*0.5;
    olai_global_average(i)  = nanmean(X(:))./nanmean(area_192_288_weighted(:));
end

%% RMSE
rmse = flai_global_average - repmat(olai_global_average',1,60); rmse = rmse.^2; rmse = nanmean(rmse,2); flairmse = rmse.^0.5;
rmse = alai_global_average - repmat(olai_global_average',1,60); rmse = rmse.^2; rmse = nanmean(rmse,2); alairmse = rmse.^0.5;
rmse = forlai_global_average - repmat(olai_global_average(73:132)',1,60); rmse = rmse.^2; rmse = nanmean(rmse,2); forlairmse = rmse.^0.5;

% Free and Assim run 2000-2010
num_year=2010-2000+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    flairmse_annual(i)=mean(flairmse(mstart:mend));
    alairmse_annual(i)=mean(alairmse(mstart:mend));
end

% Forecast run 2006-2010
num_year=2010-2006+1;
for i=1:num_year
    mstart=(i-1)*12+1;
    mend=i*12;
    forlairmse_annual(i)=mean(forlairmse(mstart:mend));
end


%% Figure

%% Anual Global Average LAI Plot
histstart=1980;
histend=2010;

spinupstart=1998;
spinupend=1999;

freestart=2000;
freeend=2010;

forstart=2006;
forend=2010;

figure;
set(gcf,'Position',[178 14 1111 1331]);

subplot(3,1,1);
plot(histstart:histend,histdata_annual,'LineStyle','-','Color',[0.1 0.1 0.1],'Marker','p','MarkerSize',8,'Linewidth',2); hold on

plot(spinupstart:spinupend,spinuplai_global_average_mean_annual,...
    'LineStyle','-','Color',[1 0.6471 0],'Marker','s','MarkerSize',8,'Linewidth',2); hold on

plot(freestart-1:freeend,[spinuplai_global_average_mean_annual(2) flai_global_average_mean_annual],...
    'LineStyle','-','Color',[0 0.4470 0.7410],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(freestart-1:freeend,[spinuplai_global_average_mean_annual(2) alai_global_average_mean_annual],...
    'LineStyle','-','Color',[0.3500 0.0250 0.3500],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(forstart:forend,forlai_global_average_mean_annual,...
    'LineStyle',':','Color',[0.8 0.2 0.0],'Marker','d','MarkerSize',8,'Linewidth',2); hold on

plot(histstart+2:histend,olai_global_average_annual,...
    'LineStyle','-','Color',[0.1333 0.5451 0.1333],'Marker','o','MarkerSize',8,'Linewidth',2); hold on

plot(freestart:freeend,flai_global_average_annual,'Color',[0.9 0.9 0.9],'Linewidth',3); hold on
plot(freestart:freeend,alai_global_average_annual,'Color',[0.6 0.6 0.6],'Linewidth',3); hold on
plot(forstart:forend,forlai_global_average_annual,'Color',[0.7 0.7 0.7],'Linewidth',3); hold on

plot(freestart:freeend,flai_global_average_mean_annual,...
    'LineStyle','-','Color',[0 0.4470 0.7410],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(freestart:freeend,alai_global_average_mean_annual,...
    'LineStyle','-','Color',[0.3500 0.0250 0.3500],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(forstart:forend,forlai_global_average_mean_annual,...
    'LineStyle',':','Color',[0.8 0.2 0.0],'Marker','d','MarkerSize',8,'Linewidth',2); hold on

xticks=histstart:5:histend;
xticklabels({'1980';'1985';'1990';'1995';'2000';'2005';'2010'});
set(gca,'XLim',[histstart-1 freeend+1],'YLim',[0.8 2],'XTick',xticks,'XTickLabel',xticklabels,'FontName','Times New Roman','FontSize',20);
ylabel('LAI (m^2 m^-^2)','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
xlabel('Year','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
title('Annual Global Average Leaf Area Index','FontName','Times New Roman','FontSize',25,'FontWeight','Bold');
set(gca,'Position',[0.0900 0.6693 0.8450 0.3057]);

h1=legend('Hist run','Spinup','Free run','Assim run','Forecast run','Observation');
%h1=legend('Free run','Forcast','Observation');
set(h1,'Box','off','Location','Northwest');
set(h1,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold');
text(1980,2.05,'(A)','FontName','Times New Roman','FontSize',25,'FontWeight','Bold');

%% Monthly Global Average LAI Plot
subplot(3,1,2);
plot(flai_global_average_mean,'LineStyle','-','Color',[0 0.4470 0.7410],'Linewidth',2); hold on
plot(alai_global_average_mean,'LineStyle','-','Color',[0.3500 0.0250 0.3500],'Linewidth',2); hold on
plot(73:132,forlai_global_average_mean,'Color',[0.8 0.2 0.0],'Linewidth',2); hold on
plot(olai_global_average,'LineStyle','-','Color',[0.1333 0.5451 0.1333],'Linewidth',2); hold on

num_tmonth=132;
xticks=1:12:num_tmonth;
xticklabels({'2000';'2001';'2002';'2003';'2004';'2005';'2006';'2007';'2008';'2009';'2010'});
set(gca,'XLim',[0 num_tmonth+1],'YLim',[0.85 2.42],'XTick',xticks,'XTickLabel',xticklabels,'FontName','Times New Roman','FontSize',20);
ylabel('LAI (m^2 m^-^2)','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
xlabel('Year','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
title('Monthly Global Average Leaf Area Index','FontName','Times New Roman','FontSize',25,'FontWeight','Bold');
set(gca,'Position',[0.0900 0.3350 0.8450 0.2690]);

h1=legend('Free run','Assim run','Forecast run','Observation');
set(h1,'Box','off');
set(h1,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold');
text(1,2.50,'(B)','FontName','Times New Roman','FontSize',25,'FontWeight','Bold');

%% RMSE
subplot(3,1,3);
plot(flairmse,'LineStyle','-','Color',[0 0.4470 0.7410],'Linewidth',2); hold on
plot(alairmse,'LineStyle','-','Color',[0.3500 0.0250 0.3500],'Linewidth',2); hold on
plot(73:132,forlairmse,'Color',[0.8 0.2 0.0],'Linewidth',2); hold on

plot(6:12:132,flairmse_annual,'LineStyle',':','Color',[0 0.1470 0.9410],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(6:12:132,alairmse_annual,'LineStyle',':','Color',[0.8500 0.0250 0.8500],'Marker','d','MarkerSize',8,'Linewidth',2); hold on
plot(78:12:132,forlairmse_annual,'LineStyle',':','Color',[0.9 0 0.0],'Marker','d','MarkerSize',8,'Linewidth',2); hold on

num_tmonth=132;
xticks=1:12:num_tmonth;
xticklabels({'2000';'2001';'2002';'2003';'2004';'2005';'2006';'2007';'2008';'2009';'2010'});
set(gca,'XLim',[0 num_tmonth+1],'YLim',[0 0.8],'XTick',xticks,'XTickLabel',xticklabels,'FontName','Times New Roman','FontSize',20);
ylabel('RMSE','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
xlabel('Year','FontName','Times New Roman','FontSize',20,'FontWeight','Bold');
set(gca,'Position',[0.0900 0.0500 0.8450 0.2340]);

h1=legend('Free run','Assim run','Forecast run');
set(h1,'Box','off');
set(h1,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold');
text(1,0.845,'(C)','FontName','Times New Roman','FontSize',25,'FontWeight','Bold');


