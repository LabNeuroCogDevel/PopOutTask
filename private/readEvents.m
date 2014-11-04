  
    
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

function [eList, manips] = readEvents(fname,rew)
    % total number of trials to get manips for
    % screenResolution to specify rectangle size --this should move...maybe
    % rewardblock?

    %% settings
    white=255.*[1 1 1];
    black=[0 0 0];
    % what keys can we use
    s=popSettings();
    
    % what keys can we use
    allow=s.keys;% allow=KbName({'1!','0)','escape'});

    %% possible events and their timing
    %eventOrder={'ITI','Prp','Cue','Fbk'};
    %eTime.ITI=1.0;
    %eTime.Prp=0.5;
    %eTime.Cue=0.5;
    %eTime.Fbk=0.5;
    eTime=s.timing;
    eventOrder=s.order;
    
    times = cumsum(cellfun(@(x) (eTime.(x)), eventOrder));
    
     

    %% manipulations
    % list of easy? (1 or 0) and dir(1 or 2)
    dirs=1:2;  % 1 is left, 2 is right
    manips.dirIdx=1;
    manips.easyIdx=2;
    
    fid=fopen(fname);
    %[192x1 double] [192x1 int32] [192x1 double] [192x1 double] {192x1 cell}
    ts=textscan(fid,'%f%d%f%f%s');
    tsi=struct('onset',1, 'evnum',2,'dur',3,'name',5);
    fclose(fid);
    
    %% counter balance cong/incongruent with left and right

    % look at trial size
    % no catch trials; everything that is not null is a trial
    %   either cong or incong
    congIncong = ts{tsi.name}(~strncmp(ts{tsi.name},'NULL',4));
    nTrl=length(congIncong);
    
    % set the easy idx (1 cong, 2 incong)
    incong=strncmp(congIncong,'inco',4);
    nincong=length(find(incong));
    ncongru=length(find(~incong));
    
    manips.val(:,manips.easyIdx)=incong+1;
    % shuffle mostly balanced directions
    % until they dont repeat a lot
    paren=@(x,varargin) x(varargin{:});
    maxinarow=3;
    toomanyinarow=1;
    while toomanyinarow
        manips.val(incong,manips.dirIdx) = ...
             paren(Shuffle(repmat(dirs,1,ceil(nincong/length(dirs)))),1:nincong);
        manips.val(~incong,manips.dirIdx) = ...
             paren(Shuffle(repmat(dirs,1,ceil(ncongru/length(dirs)))),1:ncongru);

        ckIdx = mod( ...
                         manips.val(:,manips.easyIdx) ...
                       + manips.val(:,manips.dirIdx),  ...
                       2 ) +1 ;
        manips.correctKeys=allow(ckIdx);
        
        r=rle(manips.correctKeys);
        toomanyinarow = any(r{1}(r{2}>maxinarow));
    end
    
    % cong|incog is 1|2; want 1|0
    manips.val(:,manips.easyIdx)=~( manips.val(:,manips.easyIdx) -1 );
    
    % breakdown of occurances:
    %[a,b,c]=unique(manips.val,'rows'); [d,e]=histc(c,1:length(b)); [d a],

    %% create event list
    % number of events from file 
    nfevts=length(ts{1}); 
    
    % eList stores trial structure
    % there are 4 parts to each trial (including ITI)
    %   and 1 additional ITI
    eList = cell( length(times)*nTrl +1 , 1);
    
    % initialze event and trial count
    eidx=0;
    trl=1;
    
    % read lines of the optseq file
    for nf=1:nfevts
        onset= ts{tsi.onset}(nf);
        
        % ITI fix
        if strncmp(ts{tsi.name}{nf},'NULL',4)
            eidx=eidx+1;
            eList{eidx} = {trl,@event_ITI,'ITI',onset, onset+eTime.ITI, white};
            continue
        end
       
        % easy= congruent
        easy=manips.val(trl,manips.easyIdx);
        %1=left, 2=right
        dir=manips.val(trl,manips.dirIdx);
        % what key should be pushed
        ck=manips.correctKeys(trl);
        
        %Prb
        eidx=eidx+1;
        cumtim=onset;
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
        trl=trl+1;
        
    end
    
end