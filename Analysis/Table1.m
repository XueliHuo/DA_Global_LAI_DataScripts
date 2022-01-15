%% LAI
%% Import data
clear all;
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
% Geographic infomation
load([basedir,'geographicinfo.mat']);
% LAI from three experiments: free, assimilation, forecast
load([basedir,'laidata.mat']);
size(freelai_concat)
size(assimlai_concat)
size(forelai_concat)

%% Put Atlantic in the middle
freelai_decade=zeros(size(freelai_concat));
assimlai_decade=zeros(size(assimlai_concat));
forelai_decade=zeros(size(forelai_concat));

in_lon = model_lon; in_lon(in_lon>180) = in_lon(in_lon>180)-360;
out_lon=sortrows(in_lon);
for i = 1:size(freelai_concat,3)
    for j= 1:size(freelai_concat,4)
       temp = cat(2,in_lon,squeeze(freelai_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       freelai_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(assimlai_concat,3)
    for j= 1:size(assimlai_concat,4)
       temp = cat(2,in_lon,squeeze(assimlai_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       assimlai_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(forelai_concat,3)
    for j= 1:size(forelai_concat,4)
       temp = cat(2,in_lon,squeeze(forelai_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       forelai_decade(:,:,i,j) = temp';      
    end
end


in_area = area.*land_frac; % km2
temp2 = cat(2,in_lon,in_area'); 
temp2 = sortrows(temp2); 
temp2 = temp2(:,2:193); 
area_192_288_dateline = temp2';

%% Observation
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
o_lai=ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'LAI');
size(o_lai)
obs_lat = ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'lat');
obs_lon = ncread([basedir,'LAI3g_Bimonthly_2000_2016_CLMgrid.nc'],'lon');

num_tmonth=132;
num_lat=192;
num_lon=288;

o_lai_temp=zeros(num_lat,num_lon,num_tmonth*2);
size(o_lai_temp)

ostart=2;
oend=1+num_tmonth*2;
for i = ostart:oend
    obs_lai_m = o_lai(:,:,i)'; 
    obs_lai_m(isnan(obs_lai_m))=0;
    testlat=cat(2,obs_lat,obs_lai_m);testlat=sortrows(testlat);testlat=testlat(:,2:size(obs_lai_m,2)+1);
    o_lai_temp(:,:,i-1)=testlat;
end

%%
flai_avg_time=nanmean(freelai_decade(:,:,73:132,:),3);
flai_avg_time_ens_lastfive=nanmean(squeeze(flai_avg_time),3);
alai_avg_time=nanmean(assimlai_decade(:,:,73:132,:),3);
alai_avg_time_ens_lastfive=nanmean(squeeze(alai_avg_time),3);
forlai_avg_time=nanmean(forelai_decade,3);
forlai_avg_time_ens_lastfive=nanmean(squeeze(forlai_avg_time),3);
olai_avg_lastfive=nanmean(o_lai_temp(:,:,145:264),3);
%% Statistics
% Global average TLAI/grid
X=flai_avg_time_ens_lastfive.* area_192_288_dateline;
flai_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%1.5634

X=alai_avg_time_ens_lastfive.* area_192_288_dateline;
alai_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%1.1634

X=forlai_avg_time_ens_lastfive.* area_192_288_dateline;
forlai_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%1.2228

(flai_avg_time_ens_lastfivemean-alai_avg_time_ens_lastfivemean)/flai_avg_time_ens_lastfivemean%0.2559

X=olai_avg_lastfive.* area_192_288_dateline;
olai_avg_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:)); %1.1413

% RMSE and std across ens in global mean value TLAI/grid
flai_avg_time_lastfive=zeros(size(flai_avg_time,4),1);
for i=1:size(flai_avg_time,4)
    X=flai_avg_time(:,:,1,i).* area_192_288_dateline;
    flai_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(flai_avg_time_lastfive) % 0.0101
rmse = flai_avg_time_lastfive - repmat(olai_avg_lastfivemean,size(flai_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); flairmse = rmse.^0.5; %0.4222

alai_avg_time_lastfive=zeros(size(alai_avg_time,4),1);
for i=1:size(alai_avg_time,4)
    X=alai_avg_time(:,:,1,i).* area_192_288_dateline;
    alai_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(alai_avg_time_lastfive)% 0.0024
rmse = alai_avg_time_lastfive - repmat(olai_avg_lastfivemean,size(alai_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); alairmse = rmse.^0.5; %0.0222

forlai_avg_time_lastfive=zeros(size(forlai_avg_time,4),1);
for i=1:size(forlai_avg_time,4)
    X=forlai_avg_time(:,:,1,i).* area_192_288_dateline;
    forlai_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(forlai_avg_time_lastfive) % 0.0051
rmse = forlai_avg_time_lastfive - repmat(olai_avg_lastfivemean,size(forlai_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); forlairmse = rmse.^0.5; %0.0816

(flairmse-alairmse)/flairmse % 0.9475

%% The std for LAI is set to be 0.2

%% GPP
%% Import data
clear all;
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
% Geographic infomation
load([basedir,'geographicinfo.mat']);
% gpp from three experiments: free, assimilation, forecast
load([basedir,'gppdata.mat']);
size(freegpp_concat) % gC m-2 s-1
size(assimgpp_concat)
size(foregpp_concat)

%% Put Atlantic in the middle
freegpp_decade=zeros(size(freegpp_concat));
assimgpp_decade=zeros(size(assimgpp_concat));

in_lon = model_lon; in_lon(in_lon>180) = in_lon(in_lon>180)-360;
out_lon=sortrows(in_lon);
for i = 1:size(freegpp_concat,3)
    for j= 1:size(freegpp_concat,4)
       temp = cat(2,in_lon,squeeze(freegpp_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       freegpp_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(assimgpp_concat,3)
    for j= 1:size(assimgpp_concat,4)
       temp = cat(2,in_lon,squeeze(assimgpp_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       assimgpp_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(foregpp_concat,3)
    for j= 1:size(foregpp_concat,4)
       temp = cat(2,in_lon,squeeze(foregpp_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       foregpp_decade(:,:,i,j) = temp';      
    end
end

in_area = area.*land_frac; % km2
temp2 = cat(2,in_lon,in_area'); 
temp2 = sortrows(temp2); 
temp2 = temp2(:,2:193); 
area_192_288_dateline = temp2';

%% Observation
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'obsgpp.mat']);% gC m-2 day-1
size('o_gpp'); % 2001-2010
size('o_gpp_mad'); % 2001-2010

%% Now regrid onto model grid
obs_lat = linspace(-89.75,89.75,360);
obs_lon = linspace(-179.75,179.75,720);

mod_lat = linspace(-89.75,89.75,192);
mod_lon = linspace(-179.75,179.75,288);

[obs_lon_m,obs_lat_m] = meshgrid(obs_lon, obs_lat); 
[mod_lon_m,mod_lat_m] = meshgrid(mod_lon, mod_lat);

o_gpp_temp= zeros(length(mod_lat),length(mod_lon),size(o_gpp,3));
for i = 1:size(o_gpp,3)
    interp_array = o_gpp(:,:,i);
    interp_array(interp_array==-9999.0)=0;
    out_array = interp2(obs_lon_m,obs_lat_m,interp_array',mod_lon_m,mod_lat_m);
    o_gpp_temp(:,:,i)=flipud(out_array);
end

blank_year = zeros(length(mod_lat),length(mod_lon),12);
o_gpp_inter = cat(3,blank_year,o_gpp_temp);

%%
fgpp_avg_time=nanmean(freegpp_decade(:,:,73:132,:),3);
fgpp_avg_time_ens_lastfive=nanmean(squeeze(fgpp_avg_time),3);
agpp_avg_time=nanmean(assimgpp_decade(:,:,73:132,:),3);
agpp_avg_time_ens_lastfive=nanmean(squeeze(agpp_avg_time),3);
forgpp_avg_time=nanmean(foregpp_decade,3);
forgpp_avg_time_ens_lastfive=nanmean(squeeze(forgpp_avg_time),3);
ogpp_avg_lastfive=nanmean(o_gpp_inter(:,:,73:132).*365,3);
%% Statistics
s2y = 60*60*24*365;
% Global average GPP/grid
X=fgpp_avg_time_ens_lastfive.* area_192_288_dateline;
fgpp_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;%859.2562

X=agpp_avg_time_ens_lastfive.* area_192_288_dateline;
agpp_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;%707.4400

X=forgpp_avg_time_ens_lastfive.* area_192_288_dateline;
forgpp_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;%755.1054

(fgpp_avg_time_ens_lastfivemean-agpp_avg_time_ens_lastfivemean)/fgpp_avg_time_ens_lastfivemean%0.1767

X=ogpp_avg_lastfive.* area_192_288_dateline;
ogpp_avg_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:)); %775.9543 gC m-2 year-1

% RMSE and std across ens in global mean value GPP/grid
fgpp_avg_time_lastfive=zeros(size(fgpp_avg_time,4),1);
for i=1:size(fgpp_avg_time,4)
    X=fgpp_avg_time(:,:,1,i).* area_192_288_dateline;
    fgpp_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;
end
std(fgpp_avg_time_lastfive) % 5.0461
rmse = fgpp_avg_time_lastfive - repmat(ogpp_avg_lastfivemean,size(fgpp_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); fgpprmse = rmse.^0.5; %83.4520

agpp_avg_time_lastfive=zeros(size(agpp_avg_time,4),1);
for i=1:size(agpp_avg_time,4)
    X=agpp_avg_time(:,:,1,i).* area_192_288_dateline;
    agpp_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;
end
std(agpp_avg_time_lastfive)% 3.0026
rmse = agpp_avg_time_lastfive - repmat(ogpp_avg_lastfivemean,size(agpp_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); agpprmse = rmse.^0.5; %68.5790

forgpp_avg_time_lastfive=zeros(size(forgpp_avg_time,4),1);
for i=1:size(forgpp_avg_time,4)
    X=forgpp_avg_time(:,:,1,i).* area_192_288_dateline;
    forgpp_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:))*s2y;
end
std(forgpp_avg_time_lastfive) % 3.5806
rmse = forgpp_avg_time_lastfive - repmat(ogpp_avg_lastfivemean,size(forgpp_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); forgpprmse = rmse.^0.5; %21.1491

(fgpprmse-agpprmse)/fgpprmse % 0.1782


%% Std for GPP
%% Now regrid onto model grid
obs_lat = linspace(-89.75,89.75,360);
obs_lon = linspace(-179.75,179.75,720);
mod_lat = linspace(-89.75,89.75,192);
mod_lon = linspace(-179.75,179.75,288);
[obs_lon_m,obs_lat_m] = meshgrid(obs_lon, obs_lat); 
[mod_lon_m,mod_lat_m] = meshgrid(mod_lon, mod_lat);

o_gpp_mad_temp= zeros(length(mod_lat),length(mod_lon),size(o_gpp_mad,3));
for i = 1:size(o_gpp_mad,3)
    interp_mad_array = o_gpp_mad(:,:,i);
    interp_mad_array(interp_mad_array==-9999.0)=0;
    out_array = interp2(obs_lon_m,obs_lat_m,interp_mad_array',mod_lon_m,mod_lat_m);
    o_gpp_mad_temp(:,:,i)=flipud(out_array);
end

blank_year = zeros(length(mod_lat),length(mod_lon),12);
o_gpp_mad_inter = cat(3,blank_year,o_gpp_mad_temp);

scalefactor=1.4826;
ogpp_sd_avg_lastfive=nanmean(o_gpp_mad_inter(:,:,73:132).*scalefactor,3);
ogpp_sd_avg_lastfive(isnan(area_192_288_dateline))=nan;
nanmean(ogpp_sd_avg_lastfive(:))*365; %73.2198

%% LE
%% Import data
clear all;
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
% Geographic infomation
load([basedir,'geographicinfo.mat']);
% latent heat from three experiments: free, assimilation, forecast
load([basedir,'ledata.mat']);
size(freele_concat) % W/m^2 total latent heat flux [+ to atm]
size(assimle_concat)
size(forele_concat)

%% Put Atlantic in the middle
freele_decade=zeros(size(freele_concat));
assimle_decade=zeros(size(assimle_concat));
forele_decade=zeros(size(forele_concat));

in_lon = model_lon; in_lon(in_lon>180) = in_lon(in_lon>180)-360;
out_lon=sortrows(in_lon);
for i = 1:size(freele_concat,3)
    for j= 1:size(freele_concat,4)
       temp = cat(2,in_lon,squeeze(freele_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       freele_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(assimle_concat,3)
    for j= 1:size(assimle_concat,4)
       temp = cat(2,in_lon,squeeze(assimle_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       assimle_decade(:,:,i,j) = temp';      
    end
end

for i = 1:size(forele_concat,3)
    for j= 1:size(forele_concat,4)
       temp = cat(2,in_lon,squeeze(forele_concat(:,:,i,j))'); 
       temp = sortrows(temp); 
       temp = temp(:,2:193); 
       forele_decade(:,:,i,j) = temp';      
    end
end


in_area = area.*land_frac; % km2
temp2 = cat(2,in_lon,in_area'); 
temp2 = sortrows(temp2); 
temp2 = temp2(:,2:193); 
area_192_288_dateline = temp2';

%% Observation
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'obsle.mat']);% MJ m-2 d-1 latent heat
size('o_le'); % 2001-2010
size('o_le_mad'); % 2001-2010

%% Now regrid onto model grid
obs_lat = linspace(-89.75,89.75,360);
obs_lon = linspace(-179.75,179.75,720);

mod_lat = linspace(-89.75,89.75,192);
mod_lon = linspace(-179.75,179.75,288);

[obs_lon_m,obs_lat_m] = meshgrid(obs_lon, obs_lat); 
[mod_lon_m,mod_lat_m] = meshgrid(mod_lon, mod_lat);

o_le_temp= zeros(length(mod_lat),length(mod_lon),size(o_le,3));
for i = 1:size(o_le,3)
    interp_array = o_le(:,:,i);
    interp_array(interp_array==-9999.0)=0;
    out_array = interp2(obs_lon_m,obs_lat_m,interp_array',mod_lon_m,mod_lat_m);
    o_le_temp(:,:,i)=flipud(out_array);
end
size(o_le_temp)

%%
fle_avg_time=nanmean(freele_decade(:,:,61:120,:),3);
fle_avg_time_ens_lastfive=nanmean(squeeze(fle_avg_time),3);
ale_avg_time=nanmean(assimle_decade(:,:,61:120,:),3);
ale_avg_time_ens_lastfive=nanmean(squeeze(ale_avg_time),3);
forle_avg_time=nanmean(forele_decade,3);
forle_avg_time_ens_lastfive=nanmean(squeeze(forle_avg_time),3);

%% Statistics
converter = 10^6/60/60/24;
% Global average le/grid
X=fle_avg_time_ens_lastfive.* area_192_288_dateline;
fle_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%41.5384

X=ale_avg_time_ens_lastfive.* area_192_288_dateline;
ale_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%38.9709

X=forle_avg_time_ens_lastfive.* area_192_288_dateline;
forle_avg_time_ens_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:));%39.5483

(fle_avg_time_ens_lastfivemean-ale_avg_time_ens_lastfivemean)/fle_avg_time_ens_lastfivemean%0.0618

ole_avg_lastfive=nanmean(o_le_temp(:,:,61:120).*converter,3);
X=ole_avg_lastfive.* area_192_288_dateline;
ole_avg_lastfivemean=nanmean(X(:))./nanmean(area_192_288_dateline(:)); %39.5970 W/m2

% RMSE and std across ens in global mean value le/grid
fle_avg_time_lastfive=zeros(size(fle_avg_time,4),1);
for i=1:size(fle_avg_time,4)
    X=fle_avg_time(:,:,1,i).* area_192_288_dateline;
    fle_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(fle_avg_time_lastfive) % 0.1793
rmse = fle_avg_time_lastfive - repmat(ole_avg_lastfivemean,size(fle_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); flermse = rmse.^0.5; %1.9495

ale_avg_time_lastfive=zeros(size(ale_avg_time,4),1);
for i=1:size(ale_avg_time,4)
    X=ale_avg_time(:,:,1,i).* area_192_288_dateline;
    ale_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(ale_avg_time_lastfive)% 0.1442
rmse = ale_avg_time_lastfive - repmat(ole_avg_lastfivemean,size(ale_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); alermse = rmse.^0.5;%0.6423

forle_avg_time_lastfive=zeros(size(forle_avg_time,4),1);
for i=1:size(forle_avg_time,4)
    X=forle_avg_time(:,:,1,i).* area_192_288_dateline;
    forle_avg_time_lastfive(i)=nanmean(X(:))./nanmean(area_192_288_dateline(:));
end
std(forle_avg_time_lastfive) % 0.1589
rmse = forle_avg_time_lastfive - repmat(ole_avg_lastfivemean,size(forle_avg_time_lastfive,1),1); rmse = rmse.^2; rmse = nanmean(rmse); forlermse = rmse.^0.5; %0.1650

(flermse-alermse)/flermse % 0.6705

%% Std for LE
%% Now regrid onto model grid
obs_lat = linspace(-89.75,89.75,360);
obs_lon = linspace(-179.75,179.75,720);
mod_lat = linspace(-89.75,89.75,192);
mod_lon = linspace(-179.75,179.75,288);
[obs_lon_m,obs_lat_m] = meshgrid(obs_lon, obs_lat); 
[mod_lon_m,mod_lat_m] = meshgrid(mod_lon, mod_lat);

o_le_mad_temp= zeros(length(mod_lat),length(mod_lon),size(o_le_mad,3));
for i = 1:size(o_le_mad,3)
    interp_mad_array = o_le_mad(:,:,i);
    interp_mad_array(interp_mad_array==-9999.0)=0;
    out_array = interp2(obs_lon_m,obs_lat_m,interp_mad_array',mod_lon_m,mod_lat_m);
    o_le_mad_temp(:,:,i)=flipud(out_array);
end

blank_year = zeros(length(mod_lat),length(mod_lon),12);
o_le_mad_inter = cat(3,blank_year,o_le_mad_temp);

scalefactor=1.4826;
ole_sd_avg_lastfive=nanmean(o_le_mad_inter(:,:,61:120).*scalefactor,3);
ole_sd_avg_lastfive(isnan(area_192_288_dateline))=nan;
nanmean(ole_sd_avg_lastfive(:))*converter; %5.2783
