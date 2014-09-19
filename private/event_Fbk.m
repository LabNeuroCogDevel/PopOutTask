% testing 
% global textures; w=setupScreen([150 150 150], [800 600]);cd ..;textures=getTextures(w); cd private/; event_Fbk(w,GetSecs(),1,1)

function t=event_Fbk(w,when,rewblock,correct)
  t.ideal=when;
  %% set textures
  persistent textures;
  if isempty(textures) || ( isempty(when) && isempty(rewblock))
     textures=getTextures(w);
     if isempty(when) && isempty(rewblock)
         t.onset=0;
         return;
     end
  end
  
  if correct>0 && rewblock
      centertext='C';%'✔'; 
      ringtext  ='$';
      color=[0 256 0];
      type='crt';

  elseif correct<1 && rewblock % error on reward, or too slow
      centertext='x';%'✖';
      ringtext  ='#';
      color=[256 0  0];
      type='wrg';
      
  else % rewblock == 0 
      centertext='+';
      ringtext='#'; 
      color=[0 0 255];
      type='neu'
  end
  
  
    
  %% draw
  %Screen('DrawText',w,ringtext,100,100,color);
  %Screen('DrawText',w,centertext,400,400,color);
  
  % get the center point of the window
  [ center(1), center(2) ] = Screen('WindowSize', w);
  center=center./2;
  
  % scale down to these dimensions (sx by sy)
  sx=40;sy=40;
  destrect = [ center(1)-sx center(2)-sy center(1)+sx center(2)+sy ];
  Screen('DrawTexture', w,  textures.cnt.(type),[],destrect );
  
  
  % Draw ring of images
  nInRing=6; % how many figs in the ring?

  % angle of diff between objects
  angle=2*pi/nInRing;
  % how far from the center?
  rscale=100;
  
  % display size (sx by sy)
  sx=20;sy=20;
  
  
  for n=1:nInRing
      pos = center - rscale*[ cos(n*angle) sin(n*angle) ];
      xs= pos(1) + sx*[-1 +1];
      ys= pos(2) + sy*[-1 +1];
      
      destrect = [ min(xs),  min(ys),  max(xs), max(ys)];
      Screen('DrawTexture', w,  textures.rng.(type), [], destrect )
  end
  
  
  
  [v,t.onset] = Screen('Flip',w,when);
  playSnd(type);
end