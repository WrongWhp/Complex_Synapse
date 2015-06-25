
load('laplacebndChainA12.mat','AenvChains','srange');

[ AenvHeuristic,sbnd] = SerialLaplaceEnv( srange,12 );

AenvChains=100*AenvChains.*srange;
AenvHeuristic=100*AenvHeuristic.*srange;

loglog( 1./srange,AenvChains,'r-',...
    1./srange,AenvHeuristic,'g--',...
    'LineWidth',2);
xl=[0.1 1e3];
yl=[0.5 500];
ylim(yl);
xlim(xl);
xlabel('Mean recall time, $\tau$','Interpreter','latex','FontSize',16);
ylabel('Recognition performance, $\overline{\mathrm{SNR}}(\tau)$','Interpreter','latex','FontSize',16);
title('Heuristic envelope','Interpreter','latex','FontSize',20);
legend({'Numeric envelope',...
    'Heuristic envelope',...
    },...
    'Location','northeast','Interpreter','latex','FontSize',16);

taubnd=1./sbnd(2:3);
Abnd=SerialLaplaceEnv(sbnd,12);
Abnd(1)=[];
Abnd=100*Abnd./taubnd;

line([1 1]*taubnd(1),yl,'Color','k','LineStyle','--','LineWidth',2);
line([1 1]*taubnd(2),yl,'Color','k','LineStyle','--','LineWidth',2);


annotation('textbox',...
    dsxy2figxy(gca,[taubnd(2)/2 yl(1) taubnd(2)*2 yl(1)*2]),...
    'String','$r\tau=0.73$',...
    'Interpreter','latex','FontSize',16,...
    'LineStyle','none','VerticalAlignment','bottom','HorizontalAlignment','center');

annotation('textbox',...
    dsxy2figxy(gca,[taubnd(1)/2 yl(1) taubnd(1)*2 yl(1)*2]),...
    'String','$r\tau=0.22M^2$',...
    'Interpreter','latex','FontSize',16,...
    'LineStyle','none','VerticalAlignment','bottom','HorizontalAlignment','center');

annotation('textbox',...
    dsxy2figxy(gca,[xl(1) AenvHeuristic(end) taubnd(2) 2*AenvHeuristic(end)]),...
    'String','$\frac{\sqrt{N}}{1+r\tau}$',...
    'Interpreter','latex','FontSize',22,...
    'LineStyle','none','VerticalAlignment','baseline','HorizontalAlignment','left');

annotation('textbox',...
    dsxy2figxy(gca,[taubnd(2) Abnd(2)/2 taubnd(1) Abnd(2)]),...
    'String','$\frac{1.1\sqrt{N}}{\sqrt{r\tau}}$',...
    'Interpreter','latex','FontSize',22,...
    'LineStyle','none','VerticalAlignment','bottom','HorizontalAlignment','right');

annotation('textbox',...
    dsxy2figxy(gca,[taubnd(1) Abnd(1)/2 xl(2) Abnd(1)]),...
    'String','$\frac{\sqrt{N}(M-1)}{r\tau}$',...
    'Interpreter','latex','FontSize',22,...
    'LineStyle','none','VerticalAlignment','bottom','HorizontalAlignment','right');


