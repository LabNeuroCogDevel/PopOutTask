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
    
    % but actually move the chevrons to the left or right of teh screen
    reelin=center(1)*.20; % how much not to go to the edge
    movetosideoffset=center(1)-scaleby-reelin;
    movetosideoffset=movetosideoffset*x;
   
    
    %% draw everything to the screen
    nminichevs=5;
    for i=1:nminichevs; 
        Screen('DrawLine', w, color, ...
            arrowLines(1,1)+center(1)+movetosideoffset*i/nminichevs, ...
            arrowLines(2,1)+center(2),...
            arrowLines(1,2)+center(1)+moveby+movetosideoffset*i/nminichevs, ...
            arrowLines(2,2)+center(2),linewidth );

        Screen('DrawLine', w, color, ...
            arrowLines(1,3)+center(1)+moveby+movetosideoffset*i/nminichevs, ...
            arrowLines(2,3)+center(2),...
            arrowLines(1,4)+center(1)+movetosideoffset*i/nminichevs, ...
            arrowLines(2,4)+center(2),linewidth );
    end
    % make it an arrow instead of a chevron
    if 1 % want the line?
    Screen('DrawLine', w, color, ...
        arrowLines(1,3)+center(1)+moveby+movetosideoffset, ...
        center(2),...
        arrowLines(1,4)+center(1), ...
        center(2),linewidth );
    end
  
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
