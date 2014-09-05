
function r=event_Rsp(w,maxtime,correctKey,allow)
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
