clear all
%% Import data
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'pftlaigppletimeseries.mat']);
%% Polt only six pfts
num_time=132;
num_spft=6;
num_exp=4;
num_var=3;

spftmatrix=ones(num_time,num_spft,num_exp,num_var)*-999.0;
spftmatrix(:,1,:,:)=pftmatrix(:,2,:,:);
spftmatrix(:,2,:,:)=pftmatrix(:,3,:,:);
spftmatrix(:,3,:,:)=pftmatrix(:,4,:,:);
spftmatrix(:,4,:,:)=pftmatrix(:,5,:,:);
spftmatrix(:,5,:,:)=pftmatrix(:,12,:,:);
spftmatrix(:,6,:,:)=pftmatrix(:,13,:,:);

%% Figure for global paper
cstart=0.055;
rstart=0.558;
xd=0.32;
xl=0.29;
yd=0.48;
yl=0.42;
titlelabel={'NETT';'NEBT';'NDBT';'BETT';'BDBS';'C3AG'};
xp=59;
yp=[4.7 4.7 3.3 5.51 4.7 5.6];

%% Analysis of assimilation
fig=figure;
set(gcf,'Position',[2293 -76 2021 941]);
for ipft=1:num_spft
    subplot(2,3,ipft)
    plot(spftmatrix(:,ipft,1,1),'LineStyle','-','Color',[0 0.4470 0.7410],'Linewidth',3); hold on
    plot(spftmatrix(:,ipft,2,1),'LineStyle','-','Color',[0.3500 0.0250 0.3500],'Linewidth',3); hold on
    plot(73:132,spftmatrix(73:132,ipft,3,1),'Color',[0.8 0.2 0.0],'Linewidth',3); hold on
    plot(spftmatrix(:,ipft,4,1),'LineStyle','-','Color',[0.1333 0.5451 0.1333],'Linewidth',3); hold on
    num_tmonth=132;
    xticks=1:24:num_tmonth;
    xticklabels({'2000';'2002';'2004';'2006';'2008';'2010'});
    set(gca,'XLim',[0 num_tmonth],'XTick',xticks,'XTickLabel',xticklabels,'Fontsize',25);
    if ipft==1 
        set(gca,'YLim',[0 5]);
    end
    text(xp,yp(ipft),titlelabel(ipft),'FontSize',23,'Fontweight','bold'); hold on
    
    irow=floor((ipft-0.5)/3);
    icol=ipft-irow*3-1;
    set(gca,'Position',[cstart+icol*xd rstart-irow*yd xl yl])
end
h1=legend('Free','Assim','Forecast','Observation');
set(h1,'Box','off');
set(h1,'FontSize',25,'FontName','Times New Roman','FontWeight','Bold');
set(h1,'Position',[0.6 0.4050 0.0434 0.0486]);

han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'LAI (m^2 m^-^2)','Fontsize',30,'Position',[-0.134 0.5000 7.1054e-15]);
xlabel(han,'Year','Fontsize',30,'Position',[0.5000 -0.088 7.1054e-15]);
