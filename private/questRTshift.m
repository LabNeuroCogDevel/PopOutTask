function RT   = questRTshift(RT, prevCrct,runme)
    if ~isempty(runme) && ~runme
        return
    end

    %% using Quest step 
    persistent q;
    if isempty(q) || isempty(prevCrct)
        tGuess=.6;      % RT @ .80% correct
        pThreshold=0.85; % we want 80% correct
        
        
        %p2=delta*gamma+(1-delta)*(1-(1-gamma)*exp(-10.^(beta*(x-xThreshold))));
        % x represents log10 contrast relative to threshold
        tGuessSd = .3;
        beta=3.5;
        delta=0.1;
        gamma=0.3;
        % from QuestDemo
        q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
        q.normalizePdf=1;
        if isempty(prevCrct)
            return
        end
    end
    
    % misses are same as wrong here
    if prevCrct<0
        prevCrct=0;
    end
    % use ~correct b/c if correct we want to go faster
    q=QuestUpdate(q,RT,prevCrct);
    RT=QuestQuantile(q);
    % keep RTtime in bounds
    RT=max([.2,RT]);
    RT=min([.9,RT]);
end

function testMe
    %% ctrl+enter here
    RT=[NaN questRTshift(.5,[],[])];
    preformance= .6 % .2 + (1-.2).*rand
    for i=2:50; 
      prevRT=RT(i-1,2);
      RT(i-1,1)= (randi(12)>1) * (prevRT>preformance) > 0;
      prevCT=RT(i-1,1);
      RT(i,2)=questRTshift(prevRT,prevCT,1);
    end
    RT
    corIdx=find(RT(:,1));
    errIdx=find(~RT(:,1));
    
    plottype={'-',':','-.','--'};
    colors  = 'gcmyk';
    pt=[ plottype{randi(4)} colors(randi(5)) ];
        
    plot(RT(:,2),pt);
    hold on;
    plot(corIdx,prod(RT(corIdx,2),2),'b*');
    plot(errIdx,prod(RT(errIdx,2),2),'r*');

    sum(RT(:,1))/(length(RT)-1)
end
