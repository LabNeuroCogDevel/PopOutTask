% po(rew=0|1) - popout Task rewarded block or not
function subj = pop(varargin) 
    screenResolution=[1600 1200];
    backgroundColor=256/2*[1 1 1];

    % setup the screen, font size and blending
    w=setupScreen(backgroundColor,screenResolution);

    % get textures from images (persistent in fuction)
    event_Fbk(w,[],[],[]);
    % similair for sounds, also initialize psych sounds;
    playSnd(); 
    
    
    % total number of trials

    %totalTrl=2;
    
    %% REWARD OR NEUTRAL
    % Quest or no Quest
    if ~isempty(varargin)
        ID = varargin{1};
        rewblock=varargin{2}; % 0 or 1
        
        %not practice, know ideal RT
        if(length(varargin)>2)
            baseRT = varargin{3};
            runQuest=0;
            totalTrl=68;
            %totalTrl=4;
            fprintf('not questing\n');
            
        % is practice, finding RT
        else
            fprintf('questing!\n');
            baseRT=.5;
            runQuest=1;
            totalTrl=200;
        end

    else
        
        ID=[ date '_' num2str(now) ];
        rewblock=1;
        % not practice, have an RT
        error('give me some input');
    end
    
    
    %% Setup events
    fname='optseq/test-001.par';
    % event list -- event_ITI event_Prp event_Cue event_Rsp event_Fbk 
    %[eList, manips] = setupEvents(totalTrl,rewblock);
    [eList, manips] = readEvents(fname,rewblock)
    %  {trl,@func,eventname,starttime, endtime, args};
    
    instructions(w);
    
    startime=GetSecs();
    trialInfo=struct(); % we'll build trial info without output of each event
    
    % expected RT for 80% correct

    RT = questRTshift(baseRT,[],[]);
    RTshift = 0;

    %% get where to start and end
    % what events are we running
    firstEvent=1; 
    lastEvent=length(eList);
    
    
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
        % - Cue no longer needs to be scaled by performance
        
                
        % Fbk needs correct value, and if this is quest
        if strmatch(eName,'Fbk')
           estart=GetSecs(); % start feedback right away (after Rsp)
           params = [ params, runQuest==0, {trialInfo(trl).Rsp.correct} ];  
        end
        
        %% print timing
        nt=GetSecs();
        fprintf('\t%s @ %.2f \t %.3fs + %.3fs \n', ...
                eName, estart - startime, nt-startime, estart-nt);
        
            
            
        
        
        %% the actual event
        % run the event and save struct output into nested struct array
        trialInfo(trl).(eName) = func(w, estart, params{:} );
        
        
        
        
        
        
          
        %% per trial calculations
        % set difficulty using # correct and if it was easy or not
        % NOTE: this uses only between firstEvent and trl
        %       no support for an initial setting

        if trl>firstEvent && trl ~= eList{eidx-1}{1}
           fprintf('%d trl\n',trl);
           
           %%RT manipulation
           wasEasy = manips.val(trl-1,manips.easyIdx);
           if ~wasEasy
             wasCorrect = trialInfo(trl-1).Rsp.correct;
             RT=questRTshift(RT,wasCorrect,runQuest);
             RTshift = RT - baseRT;
             fprintf('\tnew RT: %.2f, %.2f diff than base\n',RT,RTshift);
           end
           
           %shift following events by RTs
           nxt=eidx+1;
           while nxt<=lastEvent && eList{nxt}{1} == trl 
                             
               if  any( strcmp(eList{nxt}{3}, {'Rsp','Fbk','ITI'}) )
                   eList{nxt}{4} = eList{nxt}{4} + RTshift;
               end
               
               % add again to make ITI shorter and keep Fbk the same
               if  any( strcmp(eList{nxt}{3}, {'ITI'}) )
                   eList{nxt}{4} = eList{nxt}{4} + RTshift;
               end
               
               nxt=nxt+1;
           end
           
           trialInfo(trl).RTshift   = RTshift;
           
        end
        
    end
    
    %% stuff to save
    subj.start      = startime;
    subj.trialInfo  = trialInfo;
    subj.events     = eList;
    subj.manips     = manips;
    subj.idealRTwin = baseRT + trialInfo(end).RTshift;
    save([ID '.mat'],'-struct','subj' );
    
    
    %% draw done screen
    DrawFormattedText(w,'Thanks For Playing','center','center',[ 0 0 0 ]);
    Screen('Flip',w);
    KbWait;
    
    %% finish up
    closedown();
    plotResults(subj);
    
    fprintf('====\nideal RT: %.3f\n===\n',subj.idealRTwin);

end

%% get easy and correct logical lists from responses and manipulations
% will be used to manipulate trial difficulty
function [isEasy,isCorrect] = getEasyAndCorrect(firstEvent, trl,trialInfo,manips)
       isEasy = manips.val(firstEvent:(trl-1), manips.easyIdx);

       % list of correct or incorrect
       isCorrect = cellfun(@(x) x.correct,...
                           {trialInfo(firstEvent:(trl-1)).Rsp})>0;
end

