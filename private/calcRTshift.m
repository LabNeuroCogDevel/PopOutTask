function RTshift   = calcRTshift(RTshift, hardratio,easyratio)
%%  using a function 
  persistent f;
  
  % 1   correct:  -.3 sec  % as quicks 
  % 0 in    "     +.4 sec  % out to .9s to resond
  %maxShift=.4;
  %minShift=-.3;
  % f=fit([1;0],[minShift; maxShift, 'poly1')
  
  if isempty(f)
    f=@(x) -0.7*x +0.4; 
  end
  
  % maybe we are initializing
  if isempty(easyratio) || isempty(hardratio)
      return
  end
  
  RTshift(1)=f(hardratio);
  RTshift(2)=f(easyratio);
  fprintf('\tRTshift: %.02fs hard %.02fs easy\n',RTshift(1),RTshift(2));

end
%%%%%
%     %% setup on the fly manipulations
%     diffScale= calcDifficulty([0 0],[],[]); % diffScale from 0 to 1, where 1 is 4/9 distractors
%                                             % diffScale = [ hard easy ]
% 
%     RTshift  = calcRTshift([0 0],[],[]); % +/- seconds of RT window
%                                          % RTshift = [ hard easy ]
%%%% in po.m after a trial (in trial loop):
%            % get lists of easy and correct based on up to this trial
%            [isEasyL,isCorrectL] = getEasyAndCorrect(firstEvent, trl,trialInfo,manips);
%            [hardCorrectRatio, easyCorrectRatio] = getCorrectRatios(isEasyL,isCorrectL);
% 
%            % use 2 lists to get how difficult the cue should be
%            diffScale = calcDifficulty(diffScale, hardCorrectRatio, easyCorrectRatio);
           
%            % RT manipulation
%            RTshift   = calcRTshift(RTshift, hardCorrectRatio, easyCorrectRatio);
%            
%            %TODO, shift maxRsp, feedback and ITI based on RT shift
%            isEasy = manips.val(trl,manips.easyIdx);
%            nxt=eidx+1;
%            while nxt<=lastEvent && eList{nxt}{1} == trl 
%                if  any( strcmp(eList{nxt}{3}, {'Rsp','Fbk','ITI'}) )
%                    eList{nxt}{4} = eList{nxt}{4} + RTshift(isEasy+1);
%                end
%                
%                % add again to make ITI shorter and keep Fbk the same
%                if  any( strcmp(eList{nxt}{3}, {'ITI'}) )
%                    eList{nxt}{4} = eList{nxt}{4} + RTshift(isEasy+1);
%                end
%                
%                nxt=nxt+1;
%            end