function subj = po()
    global textures; % probably not a good idea to copy these around
    screenResolution=[800 600];
    backgroundColor=255/2*[1 1 1];

    % setup the screen. includes audio
    w=setupScreen(backgroundColor,screenResolution);

    % get textures from images (in global workspace)
    textures=getTextures(w);
    
    % total number of trials
    totalTrl=20;
    rewblock=1;
    
    % event list -- event_ITI event_Prp event_Cue event_Rsp event_Fbk 
    [eList, manips] = setupEvents(totalTrl,screenResolution,rewblock);
    %  {trl,@func,eventname,starttime, endtime, args};
    
    startime=GetSecs();
    trialInfo=struct(); % we'll build trial info without output of each event
    diffScale=calcDifficulty(0,[],[]); % diffScale from 0 to 1, where 1 is 4/9 distractors
                                       % diffScale = [ hard easy ]
    
    % what events are we running
    firstEvent=1; 
    lastEvent=length(eList);
    
    % go through each event we are running
    for eidx=firstEvent:lastEvent
        
        
        evt=eList{eidx}; 
        % eList for this event has all the info we need to display an event
        trl= evt{1};     % which trial the event is a part of
        func=evt{2};     % the function to use for this event
        eName=evt{3};    % the name of the event
        estart=evt{4}+startime; % this is cum time start
                                % unless RSP, then it's max of RT window
        params=evt(6:length(evt)); % parameters to pass to the event func
        
        % EVENT SPECIFIC CONSIDERATIONS
        % * feedback depend on if Rsp was correct or not
        % * Cue needs to be scaled by performance
        
        % Fbk needs correct value
        if strmatch(eName,'Fbk')
           params = { params{:}, trialInfo(trl).Rsp.correct  };
           
        % Cue needs difficulty value   
        elseif strmatch(eName,'Cue')
           
           % set difficulty using # correct and if it was easy or not
           % NOTE: this uses only between firstEvent and trl
           %       no support for an initial setting
            
           if trl>firstEvent
               % list of difficulty
               isEasy = manips.val(firstEvent:(trl-1), manips.easyIdx);
               
               % list of correct or incorrect
               isCorrect = cellfun(@(x) x.correct,...
                                   {trialInfo(firstEvent:(trl-1)).Rsp})>0;
                       
               % use 2 lists to get how difficult the cue should be
               diffScale = calcDifficulty(diffScale, isEasy, isCorrect);
           end
           
           % add diff scale to the parameters of the Cue func
           %  - use the first diffScale if not easy, second if is easy
           isEasy = manips.val(trl,manips.easyIdx);
           params = [ params, diffScale(isEasy+1) ];
           

        end
        
        
        % run the event and save struct output into nested struct array
        trialInfo(trl).(eName)=  func(w, estart, params{:} );
        
         
    end
        
    closedown();
end




