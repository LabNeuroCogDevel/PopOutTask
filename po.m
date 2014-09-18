% po(rew=0|1) - popout Task rewarded block or not
function subj = po(varargin) 
    screenResolution=[800 600];
    backgroundColor=256/2*[1 1 1];

    % setup the screen, font size and blending
    w=setupScreen(backgroundColor,screenResolution);

    % get textures from images (persistent in fuction)
    event_Fbk(w,[],[],[]);
    % similair for sounds, also initialize psych sounds;
    playSnd(); 
    
    
    % total number of trials
    %totalTrl=68;
    totalTrl=2;
    
    if ~isempty(varargin)
        ID = varargin{1};
        rewblock=varargin{2}; % 0 or 1
    else
        ID=[ date '_' num2str(now) ];
        rewblock=1;
    end
    % event list -- event_ITI event_Prp event_Cue event_Rsp event_Fbk 
    [eList, manips] = setupEvents(totalTrl,rewblock);
    %  {trl,@func,eventname,starttime, endtime, args};
    
    startime=GetSecs();
    trialInfo=struct(); % we'll build trial info without output of each event
    
    %% setup on the fly manipulations
    diffScale= calcDifficulty([0 0],[],[]); % diffScale from 0 to 1, where 1 is 4/9 distractors
                                            % diffScale = [ hard easy ]

    RTshift  = calcRTshift([0 0],[],[]); % +/- seconds of RT window
                                         % RTshift = [ hard easy ]

    %% get where to start and end
    % what events are we running
    firstEvent=1; 
    lastEvent=length(eList);
    
    %% we update this after each trial, init for first trl
    isEasy = manips.val(1,manips.easyIdx);

    
    %% go through each event we are running
    for eidx=firstEvent:lastEvent
        
        %% name event variables
        evt=eList{eidx}; 
        % eList for this event has all the info we need to display an event
        trl= evt{1};     % which trial the event is a part of
        func=evt{2};     % the function to use for this event
        eName=evt{3};    % the name of the event
        estart=evt{4}+startime; % this is cum time start
                                % unless RSP, then it's max of RT window
        params=evt(6:length(evt)); % parameters to pass to the event func

        
        %% EVENT SPECIFIC CONSIDERATIONS
        % * feedback depend on if Rsp was correct or not
        % * Cue needs to be scaled by performance
        
                
        % Fbk needs correct value
        if strmatch(eName,'Fbk')
           estart=GetSecs(); % start feedback right away (after Rsp)
           params = [ params, {trialInfo(trl).Rsp.correct} ];
           
        % Cue needs difficulty value   
        elseif strmatch(eName,'Cue')
           
           % add diff scale to the parameters of the Cue func
           %  - use the first diffScale if not easy, second if is easy
           params = [ params, diffScale(isEasy+1) ];
           

        end
        
        %% the actual event
        % run the event and save struct output into nested struct array
        
        trialInfo(trl).(eName) = func(w, estart, params{:} );
        
          
        %% per trial calculations
        % set difficulty using # correct and if it was easy or not
        % NOTE: this uses only between firstEvent and trl
        %       no support for an initial setting

        if trl>firstEvent && trl ~= eList{eidx-1}{1}
           % get lists of easy and correct based on up to this trial
           [isEasyL,isCorrectL] = getEasyAndCorrect(firstEvent, trl,trialInfo,manips);
           [hardCorrectRatio, easyCorrectRatio] = getCorrectRatios(isEasyL,isCorrectL);

           % use 2 lists to get how difficult the cue should be
           diffScale = calcDifficulty(diffScale, hardCorrectRatio, easyCorrectRatio);
           
           % RT manipulation
           RTshift   = calcRTshift(RTshift, hardCorrectRatio, easyCorrectRatio);
           
           %TODO, shift maxRsp, feedback and ITI based on RT shift
           isEasy = manips.val(trl,manips.easyIdx);
           nxt=eidx+1;
           while nxt<=lastEvent && eList{nxt}{1} == trl 
               if  any( strcmp(eList{nxt}{3}, {'Rsp','Fbk','ITI'}) )
                   eList{nxt}{4} = eList{nxt}{4} + RTshift(isEasy+1);
               end
               
               % add again to make ITI shorter and keep Fbk the same
               if  any( strcmp(eList{nxt}{3}, {'ITI'}) )
                   eList{nxt}{4} = eList{nxt}{4} + RTshift(isEasy+1);
               end
               
               nxt=nxt+1;
           end
           
           trialInfo(trl).RTshift   = RTshift;
           trialInfo(trl).diffScale = diffScale;
           trialInfo(trl).ratios    = [hardCorrectRatio, easyCorrectRatio];
           
        end
        
    end
    
    %% stuff to save
    subj.trialInfo = trialInfo;
    subj.events = eList;
    subj.manips = manips;
    save([ID '.mat'],'-struct','subj' );
    
    
    %% draw done screen
    DrawFormattedText(w,'Thanks For Playing','center','center',[ 0 0 0 ]);
    Screen('Flip',w);
    KbWait;
    
    %% finish up
    closedown();
    plotResults(subj);

end

%% get easy and correct logical lists from responses and manipulations
% will be used to manipulate trial difficulty
function [isEasy,isCorrect] = getEasyAndCorrect(firstEvent, trl,trialInfo,manips)
       isEasy = manips.val(firstEvent:(trl-1), manips.easyIdx);

       % list of correct or incorrect
       isCorrect = cellfun(@(x) x.correct,...
                           {trialInfo(firstEvent:(trl-1)).Rsp})>0;
end

