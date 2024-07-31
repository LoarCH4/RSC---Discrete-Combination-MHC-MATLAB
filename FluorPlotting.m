function [mixPerc, GaccRange, Gmean, Gstd] = FluorPlotting(RGB_profile, window, alpha)

    RGBmat = readmatrix(RGB_profile);

    PP = RGBmat(:,1);
    P0 = PP(1); Pn = PP(length(PP));
    subp = linspace(P0,Pn);

    RR = RGBmat(:,2);
    GG = RGBmat(:,3);
    BB = RGBmat(:,4);

    MMR = movmean(RR,window);
    MMG = movmean(GG,window);
    MMB = movmean(BB,window);

    Gmean = mean(MMG);
    Gstd = std(MMG);

    GaccBot = Gmean - alpha .* Gstd;
    GaccTop = Gmean + alpha .* Gstd;
    GaccRange = ['[', num2str(GaccBot),',',num2str(GaccTop),']'];

    strMean = ['average of moving mean = ',num2str(Gmean)];
    strBot = ['lower acceptable limit = ',num2str(GaccBot)];
    strTop = ['upper acceptable limit = ',num2str(GaccTop)];

    mixPerc = (sum(MMG >= GaccBot & MMG <= GaccTop))./(size(MMG,1));

    strMix = ['mixed ratio = ',num2str(mixPerc)];

    figure()
    plot(PP,RR,'r-',PP,GG,'g-',PP,BB,'b-',PP,MMG,'k-',PP,Gmean,'k.',PP,GaccBot,'k.',PP,GaccTop,'k.');
    legend('R profile','G profile', 'B profile', 'Moving average of B');
    xlabel('pixel position');
    ylabel('Fluorescent Colored Signal Intensity');
    text(PP(length(PP)-30),(Gmean+2),strMean);
    text(PP(length(PP)-30),(GaccTop+2),strTop);
    text(PP(length(PP)-30),(GaccBot+2),strBot);
    text(PP(5),190,strMix);

end