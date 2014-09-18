function t=event_Cue(w,when,dir)%,diffScale)
  diffScale=[0 0]; 
  if(dir==2)
      dispd='>';
      wrgd='<';
  else
      dispd='<';
      wrgd='>';
  end
  yd=1;
  xd=1;
  n=yd*xd;
  maxwrng=floor(.49*n);
  
  flanker=repmat(dispd,yd,xd);
  idxs=Shuffle(1:n);
  flanker(idxs(1:ceil(maxwrng*diffScale)))=wrgd;
  disptxt = reshape([ flanker repmat('\n',yd,1)]',[1 n+2*yd]);
  
  % TODO: some at .6 are much harder than others
  %   if have one row like >>> -- easy
  screensize=Screen('Rect',w);
  screensize(4)=screensize(4)+36; % hack to recenter text
  
  DrawFormattedText(w,disptxt,'center','center',[256 256 256], ...
       [], 0,0,1,0, screensize);
  
  [v,t.onset] = Screen('Flip',w,when);
  t.flanker=flanker;
end