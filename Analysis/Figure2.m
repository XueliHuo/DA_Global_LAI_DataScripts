%% Figures
clear all
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'geographicinfo.mat']);% Geographic infomation
load([basedir,'avglastfivelaiData.mat']);
load([basedir,'avglastfivegppData.mat']);
load([basedir,'avglastfiveleData.mat']);

in_lon = model_lon; in_lon(in_lon>180) = in_lon(in_lon>180)-360;
out_lon=sortrows(in_lon);

%% Figure 2
figure()
set(gcf,'Position',[244 475 838 819]);
subplot(3,1,1)
vartoplot = alai_avg_time_ens_lastfive-flai_avg_time_ens_lastfive;
h1 = imagesc(out_lon, model_lat,vartoplot);
set(h1,'AlphaData',~isnan(vartoplot))
set(gca,'YDir','normal','FontName','Times New Roman','FontSize',20)
set(gca,'xticklabel',{[]});
set(gca,'Position',[0.0600 0.6873 0.860 0.310]);
text(-178,-40,'(A) TLAI: Assim - Free','FontName','Times New Roman','FontSize',19,'FontWeight','Bold');
worldmap('hollow','dateline');
c = centered_m_colorbar;
c.Label.String = 'LAI (m^2 m^-^2)';
c.Location = 'eastoutside';
c.FontSize = 19;
c.FontWeight = 'bold';
ylim([-60 90]);

subplot(3,1,2)
vartoplot = agpp_avg_time_ens_lastfive-fgpp_avg_time_ens_lastfive;
h1 = imagesc(out_lon, model_lat,vartoplot);
set(h1,'AlphaData',~isnan(vartoplot))
set(gca,'YDir','normal','FontName','Times New Roman','FontSize',20)
set(gca,'xticklabel',{[]});
set(gca,'Position',[0.0600 0.3640 0.860 0.310]);
text(-178,-40,'(B) GPP: Assim - Free','FontName','Times New Roman','FontSize',19,'FontWeight','Bold');
worldmap('hollow','dateline');
c = centered_m_colorbar;
c.Label.String = 'GPP (gC m^-^2 y^-^1)';
c.Location = 'eastoutside';
c.FontSize = 19;
c.FontWeight = 'bold';
ylim([-60 90]);


subplot(3,1,3)
vartoplot = ale_avg_time_ens_lastfive-fle_avg_time_ens_lastfive;
h1 = imagesc(out_lon, model_lat,vartoplot);
set(h1,'AlphaData',~isnan(vartoplot))
set(gca,'YDir','normal','FontName','Times New Roman','FontSize',20)
set(gca,'Position',[0.0600 0.0400 0.860 0.310]);
text(-178,-40,'(C) LE: Assim - Free','FontName','Times New Roman','FontSize',19,'FontWeight','Bold');
worldmap('hollow','dateline');
c = centered_m_colorbar;
c.Label.String = 'LE (W m^-^2)';
c.Location = 'eastoutside';
c.FontSize = 19;
c.FontWeight = 'bold';
ylim([-60 90]);
