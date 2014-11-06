
%
% wait for an allowed keypress until max time 
% check against correctKey 
%
% if varargin, do not accept keypresses until varargin{1}
%   use direction of varargin{2}
% @ time varargin{1}, cue color would change and subject would be allowed
%   to respond

function r=event_Rsp(w,maxtime,correctKey,allow,varargin)
 
 if length(varargin)==2;
     t=event_Cue(w,varargin{1},varargin{2},256*[1 1 1]);
     r.display_onset = t.onset;
 end
 
 initTime=GetSecs();
 RT=initTime;
 keyCode=zeros(256,1);
 % show fix time
 t=-Inf;
 
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
 
 r.pushtime=RT;
 r.RT=RT-initTime;
 r.correct=correct;
 
end
