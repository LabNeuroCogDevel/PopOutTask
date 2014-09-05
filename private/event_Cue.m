function t=event_Cue(w,when,dir,diffScale)
  if(dir==2)
      dispd='>';
      wrgd='<';
  else
      dispd='<';
      wrgd='>';
  end
  yd=1;
  xd=9;
  n=yd*xd;
  maxwrng=floor(.49*n);
  
  flanker=repmat(dispd,yd,xd);
  idxs=Shuffle(1:n);
  flanker(idxs(1:ceil(maxwrng*diffScale)))=wrgd;
  disptxt = reshape([ flanker repmat('\n',yd,1)]',[1 n+2*yd]);
  
  % TODO: some at .6 are much harder than others
  %   if have one row like >>> -- easy
  
  DrawFormattedText(w,disptxt,'center','center');
  
  [v,t.onset] = Screen('Flip',w,when);
  t.flanker=flanker;
end