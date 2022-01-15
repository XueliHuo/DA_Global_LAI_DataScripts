%% Import data
clear all;
basedir = '/Users/xuelihuo/DART_CLM_PRAC/JGR_DAGlobalLAI_DataScripts/';
load([basedir,'dominantpftmodelproj.mat']);
load([basedir,'pftscattermatrix.mat']);

%% Calculate the number of grids corresponding to each pft
num_pft=16;
num_lat=192;
num_lon=288;
pftnum=zeros(num_pft,1);
for ipft=1:num_pft
    for ilat=1:num_lat
        for ilon=1:num_lon
            if dominantpft(ilat,ilon)==ipft
                pftnum(ipft,1)=pftnum(ipft,1)+1;
            end
        end
    end
end

nanpftnum=0;

for ilat=1:num_lat
    for ilon=1:num_lon
        if isnan(dominantpft(ilat,ilon))
            nanpftnum=nanpftnum+1;
        end
    end
end
%sum(pftnum)+nanpftnum==192*288

%% Figure without Fluxnet Data
specificpft=[2 3 4 5 12 13]';
num_spft=6;

spftname={'NETT';'NEBT';'NDBT';'BETT';'BDBS';'C3AG'};

%% GPP vs LE
%% Figures some of the subplots have the same range in x- and y-axis
xp=[5 5 2 12 2.5 4];
yp=[5.5 5.5 3.2 9.3 3.2 5.5];
fig=figure;
set(gcf,'Position',[1921 -49 2021 941]);
sz=50;
xl = 0.28;
xd = 0.32;
xs = 0.055;
yl=0.41;
for ipft=1:num_spft
    subplot(2,3,ipft)
    scatter(pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),1,3),pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),1,2)/365,sz,...
        'MarkerEdgeColor',[0.86 0.56 0.1],'MarkerFaceColor',[0.86 0.56 0.1],'Marker','o'); hold on
    scatter(pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),2,3),pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),2,2)/365,sz,...
        'MarkerEdgeColor',[0.9 0.9 0.3500],'MarkerFaceColor',[0.9 0.9 0.3500],'Marker','d'); hold on
    scatter(pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),4,3),pftgridbasedmatrix(1:pftnum(specificpft(ipft)),specificpft(ipft),4,2)/365,sz,...
        'MarkerEdgeColor',[0.1333 0.7451 0.1333],'MarkerFaceColor',[0.1333 0.7451 0.1333],'Marker','s'); hold on
    text(xp(ipft),yp(ipft),spftname(ipft),'FontSize',23,'Fontweight','bold'); hold on
    xi=ipft-floor((ipft-0.5)/3)*3;
    if ipft > 3
        ys = 0.082;
    else
        ys = 0.56;
    end
    set(gca,'FontSize',25,'Position',[xs+(xi-1)*xd,ys,xl,yl]);
    if ipft==2
        set(gca,'XLim',[0 80],'YLim',[0 6]);
    end
    if ipft==3
        set(gca,'XLim',[0 35]);
    end
    if ipft==5
        set(gca,'XLim',[0 35],'YLim',[0 3.5]);
    end
end

h1=legend('Free','Assim','Observation');
set(h1,'Box','off');
set(h1,'FontSize',27,'FontName','Times New Roman','FontWeight','Bold');
set(h1,'Position',[0.5850 0.880 0.0434 0.0486]);



han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'GPP (gC m^-^2 day^-^1)','Fontsize',30,'Position',[-0.134 0.5000 7.1054e-15]);
xlabel(han,'LE (W m^-^2)','Fontsize',30,'Position',[0.5000 -0.075 7.1054e-15]);
