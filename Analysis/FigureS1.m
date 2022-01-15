%% Figures
clear all
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'geographicinfo.mat']);% Geographic infomation
in_lon = model_lon; in_lon(in_lon>180) = in_lon(in_lon>180)-360;
out_lon=sortrows(in_lon);
%% Import dominant pft
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'domipft.mat']);

%% Figure S1
figure
set(gcf,'Position',[1000 811 890 527]);
vartoplot = dominant_pft;
h1 = imagesc(out_lon, model_lat,vartoplot);
set(h1,'AlphaData',~isnan(vartoplot))
set(gca,'YDir','normal','FontName','Times New Roman','FontSize',22)
h2 = title(strcat('Dominant PFT > 50% grid area'));
set(h2,'Interpreter','none','FontName','Times New Roman','FontSize',23,'FontWeight','Bold');
worldmap('hollow','dateline');
bob=parula(16);
bob(1:1,:)=0.9;
colormap(gca,bob);
c = colorbar;
c.Label.String = 'PFT';
c.Location = 'eastoutside';
c.FontSize = 20;
c.FontWeight = 'bold';
c.FontName = 'Times New Roman';
c.Ticks=1:1:16;
%c.Position= [0.1577 0.07 0.7196 0.0227];
set(gca,'Clim',[1 16])
ylim([-60 90]);
