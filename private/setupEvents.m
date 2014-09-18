  
    
%     
%         t.ITI = ITI(w,startime,white);
%         t.Prp = Prp(w,startime+times(1),rect, easy );
%         
%         
%         %t.ISI = ISI(w,startime+times(2),black);
%         
%         t.Cue = Cue(w,startime+times(3), dir );
%         
%         [t.Rsp,correct] = Rsp(t.Cue+.5,allow,ck);
%         
%         t.Fbk  = Fbk(w,startime+times(4),rew,correct);

function [eList, manips] = setupEvents(totalTrl,rew)
    % total number of trials to get manips for
    % screenResolution to specify rectangle size --this should move...maybe
    % rewardblock?

    %% settings
    white=255.*[1 1 1];
    black=[0 0 0];
    % what keys can we use
    allow=KbName({'1!','2@','escape'});

    %% possible events and their timing
    eventOrder={'ITI','Prp','Cue','Fbk'};
    eTime.ITI=1.0;
    eTime.Prp=0.5;
    eTime.Cue=0.5;
    eTime.Fbk=0.5;
    times = cumsum(cellfun(@(x) (eTime.(x)), eventOrder));
    
     

    %% manipulations
    % list of easy? (1 or 0) and dir(1 or 2)
    easys=1:4; % only 4 will be hard
    dirs=1:2;  % 1 is left, 2 is right
    manips.val=combvec(dirs,easys)';
    manips.dirIdx=1;
    manips.easyIdx=2;

    manips.val=Shuffle(repmat(manips.val,ceil(totalTrl/size(manips.val,1)),1));
    manips.val(:,manips.easyIdx)=manips.val(:,manips.easyIdx)<4;
    % easy dir keyidx
    % 0     1     2
    % 0     2     1
    % 1     1     1
    % 1     2     2
    ckIdx = mod( ...
                 manips.val(:,manips.easyIdx) ...
               + manips.val(:,manips.dirIdx),  ...
               2 ) +1 ;
    % allow is 1,2, 1=left,2=right == same as dir         
    manips.correctKeys=allow(ckIdx);

    % truncate manips
    manips.val = manips.val(1:totalTrl,:);
    
    % colored box dimensions
    %[width, height]=Screen('WindowSize', w);
    %screenResolution=[width height];
    %rect= [ screenResolution/2 screenResolution/2 ] + [ -10 -10 10 10 ]; 
    
    % size of event list is events*trials -- as long as there are no
    % catchtrials
    
    eList = cell( length(times)*totalTrl +1 , 1);
    
    eidx=0;
    cumtim=0;
    % trlNum, startTime, endTime, eventFunction, eventParams
    for trl=1:totalTrl
        
        
        % of the four types, only 1 is not easy 
        %three 0s for every one 1
        easy=manips.val(trl,manips.easyIdx);
        %1=left, 2=right
        dir=manips.val(trl,manips.dirIdx);
        % what key should be pushed
        ck=manips.correctKeys(trl);
        
        % start
        % ITI
        eidx=eidx+1;
        endtime=cumtim + eTime.('ITI');
        eList{eidx} = {trl,@event_ITI,'ITI',cumtim, endtime, white};
        cumtim=endtime;
        
        %Prb
        eidx=eidx+1;
        endtime=cumtim + eTime.('Prp');
        eList{eidx} = {trl,@event_Prp,'Prp',cumtim, endtime, easy};
        cumtim=endtime;
        
        %Cue
        eidx=eidx+1;
        endtime=cumtim + eTime.('Cue');
        eList{eidx} = {trl,@event_Cue,'Cue',cumtim, endtime, dir};
        cumtim=endtime;
        
        %Rsp -- different than the rest, we are giving max time not cumtime
        eidx=eidx+1;
        eList{eidx} = {trl,@event_Rsp,'Rsp',endtime, endtime,ck,allow};
        %cumtime=endtime;
        
        
        %Fbk
        eidx=eidx+1;
        endtime=cumtim + eTime.('Fbk');
        eList{eidx} = {trl,@event_Fbk,'Fbk',cumtim, endtime, rew};
        cumtim=endtime;
        
        
    end
    
    %top it off with an ITI
    eList{eidx+1} = {totalTrl,@event_ITI,'ITI',...
                      cumtim+.5,cumtim+.5+eTime.('ITI'), ...
                      white };
end