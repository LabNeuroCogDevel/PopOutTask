% display the cue ("dir" 1 or 2 -> "<" or ">") at time "when"
% varargin set the color; by default, color is off gray

function t=event_Cue(w,when,dir,varargin)
  t.ideal=when;
  t.dir=dir;
  
  if isempty(varargin)
    color=[256 256 256];
    %color=[256 256 256];
  else
    color=varargin{1};
  end
  
    center=Screen('Rect',w)/2;
    center=center(3:4);
    degsize=40;
    % -1 = left; +1 = right
    x=-2.*(dir==1)+1;
    
    % (x;y x;y) (x;y x;y)
    scaleby=.5.*degsize;
    linewidth=min(6,degsize/6); %GFX card on laptop maxs at 6.99
    
    % two lines that make a < or > "chevron"
    arrowLines = [0 x, x 0; ...
                  1 0, 0 -1 ];
        
    % make the arrows bigger
    arrowLines=arrowLines.*scaleby;
    

    % center chevrons 
    moveby=x.*scaleby/2;
    arrowLines(1,:)=arrowLines(1,:)-moveby;    
   
    
    %% draw everything to the screen
    
    Screen('DrawLine', w, color, ...
        arrowLines(1,1)+center(1), ...
        arrowLines(2,1)+center(2),...
        arrowLines(1,2)+center(1)+moveby, ...
        arrowLines(2,2)+center(2),linewidth );

    Screen('DrawLine', w, color, ...
        arrowLines(1,3)+center(1)+moveby, ...
        arrowLines(2,3)+center(2),...
        arrowLines(1,4)+center(1), ...
        arrowLines(2,4)+center(2),linewidth );
  
  
  
  
  [v,t.onset] = Screen('Flip',w,when);
end


%   if(dir==2)
%       disptxt='>';
%   else
%       disptxt='<';
%   end
% 
% 
%   %screensize=Screen('Rect',w);
%   %screensize(4)=screensize(4)+36; % hack to recenter text
%   
%   DrawFormattedText(w,disptxt,'center','center',color); %, ...
%        ...[], 0,0,1,0, screensize);
