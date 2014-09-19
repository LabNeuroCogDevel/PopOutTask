% display the cue ("dir" 1 or 2 -> "<" or ">") at time "when"
% varargin set the color; by default, color is off gray

function t=event_Cue(w,when,dir,varargin)
  t.ideal=when;
  t.dir=dir;
  
  if isempty(varargin)
    color=[256 256 256]*.75;
  else
    color=[256 256 256];
  end
  
  if(dir==2)
      disptxt='>';
  else
      disptxt='<';
  end


  screensize=Screen('Rect',w);
  screensize(4)=screensize(4)+36; % hack to recenter text
  
  DrawFormattedText(w,disptxt,'center','center',color, ...
       [], 0,0,1,0, screensize);
  
  [v,t.onset] = Screen('Flip',w,when);
end