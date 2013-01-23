function VORcomparison( Wp,Wm,w,t,df,tchange,WpM,WmM,varargin )
%ph=VOREXPT(Wp,Wm,w,t,df,tchange,...) Simulation of VOR expt
%   T = time values
%   WP = potentiation transition rates
%   WM = depression transition rates
%   DF = Change in fraction of potentiation transitions
%   w = Weights of states (+/-1)

Parent=gca;
altfig=[];
fig3=[];
Superpose=false;
varargin=assignApplicable(varargin);

if isempty(altfig)
    altaxWT=[];
    altaxKn=[];
else
    if isscalar(altfig)
        clf(altfig);
        altaxWT=subplot(2,1,1,'Parent',altfig);
        altaxKn=subplot(2,1,2,'Parent',altfig);
    else
        clf(altfig(1));
        clf(altfig(2));
        altaxWT=axes('Parent',altfig(1));
        altaxKn=axes('Parent',altfig(2));
        embiggen(altaxWT);
        embiggen(altaxKn);
    end
end

if Superpose
%     phWT=VORsuperpose(Wp,Wm,w,t,df,'LinSpec','k','Parent',Parent,'altax',altaxWT,varargin{:});
%     phKn=VORsuperpose(WpM,WmM,w,t,df,'LinSpec','r','Parent',Parent,'altax',altaxKn,varargin{:});
    phWT=VORexptSuperpose(Wp,Wm,w,t,df,tchange,'LinSpec','k','Parent',Parent,varargin{:});
    phKn=VORexptSuperpose(WpM,WmM,w,t,df,tchange,'LinSpec','r','Parent',Parent,varargin{:});
else
    [phWT,P_WT_nopre,P_WT_pre]=VORexpt(Wp,Wm,w,t,df,tchange,'LinSpec','k','Parent',Parent,varargin{:});
    [phKn,P_Kn_nopre,P_Kn_pre]=VORexpt(WpM,WmM,w,t,df,tchange,'LinSpec','r','Parent',Parent,varargin{:});
end%if 

if ~isempty(altfig)
    EqProbPlot(Wp,Wm,df,'Parent',altaxWT,varargin{:});
    EqProbPlot(WpM,WmM,df,'Parent',altaxKn,varargin{:});
%     plot(altax,[EqProb(fp*Wp+(1-fp)*Wm); EqProb((fp+df)*Wp+(1-fp-df)*Wm); EqProb((fp-df)*Wp+(1-fp+df)*Wm)]');
%     xlabel(altax,'State');
%     ylabel(altax,'Equilibrium prob.');
%     legend(altax,{'Untrained','Gain increase','Gain decrease'},'Location','Best');
end

axes(Parent);
xlabel('Training time')
ylabel('Learning (-\Delta mean w)')
embiggen

if Superpose
    legend({'WT, no-pre';'WT, pre';'D^bK^b-/-, no-pre';'D^bK^b-/-, pre'},'Location','Best')
else
    yl=ylim;
    xl=xlim;
    line(tchange*[1 1],[yl(1) 0],'LineStyle',':','Color','k');
    [x,y]=dsxy2figxy([xl(1) xl(2)], (0.95*yl(2)+0.05*yl(1))*[1 1]);
    annotation('doublearrow',x,y);
    pos=dsxy2figxy([0.6*xl(1)+0.4*xl(2) (0.9*yl(2)+0.1*yl(1)) 0.2*(xl(2)-xl(1)) 0.05*(yl(2)-yl(1))]);
    annotation('textbox',pos,'String','training','VerticalAlignment','top','LineStyle','none','HorizontalAlignment','center');
    [x,y]=dsxy2figxy([xl(1) tchange], (0.95*yl(1)+0.05*yl(2))*[1 1]);
    annotation('doublearrow',x,y);
    pos=dsxy2figxy([0.6*xl(1)+0.4*tchange (0.95*yl(1)+0.05*yl(2)) 0.2*(tchange-xl(1)) 0.05*(yl(2)-yl(1))]);
    annotation('textbox',pos,'String','pre-training','VerticalAlignment','bottom','LineStyle','none','HorizontalAlignment','center');
    [x,y]=dsxy2figxy([tchange xl(2)], (0.95*yl(1)+0.05*yl(2))*[1 1]);
    annotation('doublearrow',x,y);
    pos=dsxy2figxy([0.6*tchange+0.4*xl(2) (0.95*yl(1)+0.05*yl(2)) 0.2*(xl(2)-tchange) 0.05*(yl(2)-yl(1))]);
    annotation('textbox',pos,'String','training','VerticalAlignment','bottom','LineStyle','none','HorizontalAlignment','center');
    legend([phWT(1);phKn(1)],{'WT';'D^bK^b-/-'},'Location','Best')
    drawnow;
    
    if isscalar(fig3)
        clf(fig3);
        h=subplot(2,2,1,'Parent',fig3);
        ProbEvol(P_WT_nopre,t,'WT no pre-training','Parent',h);
        h=subplot(2,2,2,'Parent',fig3);
        ProbEvol(P_WT_pre,t,'WT pre-training','Parent',h);
        h=subplot(2,2,3,'Parent',fig3);
        ProbEvol(P_Kn_nopre,t,'D^bK^b-/- no pre-training','Parent',h);
        h=subplot(2,2,4,'Parent',fig3);
        ProbEvol(P_Kn_pre,t,'D^bK^b-/- pre-training','Parent',h);
    elseif numel(fig3)==4
        h=axes('Parent',fig3(1));
        ProbEvol(P_WT_nopre,t,'WT no pre-training','Parent',h,'FontSize',16);
        embiggen(h);
        h=axes('Parent',fig3(2));
        ProbEvol(P_WT_pre,t,'WT pre-training','Parent',h,'FontSize',16);
        embiggen(h);
        h=axes('Parent',fig3(3));
        ProbEvol(P_Kn_nopre,t,'D^bK^b-/- no pre-training','Parent',h,'FontSize',16);
        embiggen(h);
        h=axes('Parent',fig3(4));
        ProbEvol(P_Kn_pre,t,'D^bK^b-/- pre-training','Parent',h,'FontSize',16);
        embiggen(h);
    end
end

if ~isempty(altfig)
    title(altaxWT,'WT');
    title(altaxKn,'D^bK^b-/-');
end





end
