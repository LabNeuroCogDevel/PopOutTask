function subj = po()
    screenResolution=[800 600];
    backgroundColor=255/2*[1 1 1];
    eventOrder={'ITI','Prp','ISI','Cue','Fbk'};
    eTime.ITI=1.0;
    eTime.Prp=0.5;
    eTime.ISI=1.0;
    eTime.Cue=0.5;
    eTime.Fbk=0.5;
    times = cumsum(cellfun(@(x) (eTime.(x)), eventOrder));
    
    
    
    w=setupScreen(backgroundColor,screenResolution);
    white=255.*[1 1 1];
    black=[0 0 0];
    % what keys can we use
    allow=KbName({'1!','2@','escape'});
    
    % total number of trials
    totalTrl=20;
    
    % possible manipulations
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
    correctKeys=allow(ckIdx);
    
    % always a reward block right now
    rew=1;
    
    % rectange for Prp
    rect= [ screenResolution/2 screenResolution/2 ] + [ -10 -10 10 10 ]; 

    startime=GetSecs();
    
        
    fprintf('easy\tdir\tck\n');
    for trl=1:totalTrl
        % of the four types, only 1 is not easy 
        %three 0s for every one 1
        easy=manips.val(trl,manips.easyIdx);
        %1=left, 2=right
        dir=manips.val(trl,manips.dirIdx);
        % what key should be pushed
        ck=correctKeys(trl);


        fprintf('%d\t%d\t%d\n',easy,dir,ck);
        t.ITI = ITI(w,startime,white);
        t.Prp = Prp(w,startime+times(1),rect, easy );
        t.ISI = ISI(w,startime+times(2),black);
        t.Cue = Cue(w,startime+times(3), dir );
        
        [t.Rsp,correct] = Rsp(t.Cue+.5,allow,ck);
        
        t.Fbk  = Fbk(w,startime+times(4),rew,correct);
        
        % show time diffs 
        tdif=struct2array(t);
        tdif=diff(tdif([1:4,6]));
        fprintf('\t\t\t'); fprintf('%.2f ',tdif); fprintf('\n');
        
        time(trl)=t;
        
        % update next start time
        startime=startime+times(5);
    end
    
    
    subj.time=time;
    
    closedown();
end


function t=ITI(w,when,color)
  DrawFormattedText(w,'+','center','center',color);
  [v,t] = Screen('Flip',w,when);
end

function t=ISI(w,when,color)
  t=ITI(w,when,color);
end

function t=Prp(w,when,rect,easy)
  if(easy)
      Screen('FillRect',w,[ 0 255 0],rect);
  else
      Screen('FillRect',w,[ 255 0 0],rect);
  end
  [v,t] = Screen('Flip',w,when);
end

function t=Cue(w,when,dir)
  if(dir==2)
      disp='>';
  else
      disp='<';
  end
  DrawFormattedText(w,disp,'center','center');
  [v,t] = Screen('Flip',w,when);
end


function [RT,correct]=Rsp(maxtime,allow,correctKey)
 RT=GetSecs();
 keyCode=zeros(256,1);
 while RT < maxtime && ~any(keyCode(allow))
     [key, RT, keyCode] = KbCheck;
 end
 
 if(~any(keyCode(allow)))
     RT=Inf;
     correct=-1;
 elseif keyCode(KbName('escape'))
     closedown();
     error('early exit');
 else
     correct=keyCode(correctKey);
     fprintf('\t\t\t%d=%d ==> %d\n', find(keyCode),correctKey,correct);
 end
 
end

function t=Fbk(w,when,rew,correct)
  %% set text
  if(correct>0)
      disptext='RIGHT';
  else
      disptext='WRONG';
  end
  
  if(rew)
      disptext=['$ ' disptext ' $'];
  else
      disptext=['# ' disptext ' #' ];
      color=[0 0 255];
  end
  
  %% color
  % black if neut
  % by correct (green/red) if reward
  % red if too slow
  if(correct==-1)
      % ignore previous disp text
      disptext = 'too slow!';
      color=[0 0 255];
  elseif(correct && rew)
       color=[0 255 0];
  elseif(~correct && rew)
       color=[255 0 0];
       
  else % not rew
       color=[0 0 0 ];
  end
  
    
  %% draw
  DrawFormattedText(w,disptext,'center','center',color);
  [v,t] = Screen('Flip',w,when);
end
